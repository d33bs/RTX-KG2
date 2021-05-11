#!/bin/env python3
"""
This script creates a 'meta knowledge graph' (per TRAPI) and records node neighbor counts by category (in the
kg2c.sqlite file generated by create_kg2c_files.py). It uses the 'lite' KG2c JSON file to derive this meta info.
You must specify what version of the Biolink model to use (should match what the corresponding KG2 uses; e.g., 1.8.1)
Usage: python3 record_kg2c_meta_info.py <biolink model version> [--test]
"""
import argparse
import json
import logging
import os
import pickle
import sqlite3
import time
from collections import defaultdict
from datetime import datetime
from typing import Dict, Set, Tuple, DefaultDict

import requests
from treelib import Tree
import yaml

KG2C_DIR = f"{os.path.dirname(os.path.abspath(__file__))}"


def serialize_with_sets(obj: any) -> any:
    # Thank you https://stackoverflow.com/a/60544597
    if isinstance(obj, set):
        return list(obj)
    else:
        return obj


def _create_tree_recursive(root_id: str, parent_to_child_map: Dict[str, Set[str]], tree: Tree):
    # Recursively builds a treelib tree based on direct parent-to-child relationships
    for child_id in parent_to_child_map.get(root_id, []):
        tree.create_node(child_id, child_id, parent=root_id)
        _create_tree_recursive(child_id, parent_to_child_map, tree)


def _get_ancestors(node_id: str, tree: Tree, root_node_id: str) -> Set[str]:
    # Gets IDs of all ancestors (including the given node itself)
    ancestors = {node_id}
    node = tree.get_node(node_id)
    while node.identifier != root_node_id:
        parent = tree.parent(node.identifier)
        ancestors.add(parent.identifier)
        node = parent
    return ancestors


def _convert_to_trapi_predicate_format(english_predicate: str) -> str:
    # Converts a string like "treated by" to "biolink:treated_by"
    return f"biolink:{english_predicate.replace(' ', '_')}"


def _create_expanded_predicates_maps(biolink_version: str) -> Tuple[DefaultDict[str, set], Dict[str, str]]:
    # Build maps of predicate ancestors and inverses, since KG2c considers these when answering queries
    logging.info("Generating ancestor/inverse predicates maps..")

    # First load the biolink model into a tree
    root_predicate = "biolink:related_to"
    biolink_tree = Tree()
    inverses_map = dict()
    biolink_model_yaml = f"https://raw.githubusercontent.com/biolink/biolink-model/{biolink_version}/biolink-model.yaml"
    response = requests.get(biolink_model_yaml, timeout=10)
    if response.status_code == 200:
        # Build little helper maps of slot names to their direct children/inverses
        biolink_model = yaml.safe_load(response.text)
        parent_to_child_dict = defaultdict(set)
        for slot_name_english, info in biolink_model["slots"].items():
            slot_name = _convert_to_trapi_predicate_format(slot_name_english)
            parent_name_english = info.get("is_a")
            if parent_name_english:
                parent_name = _convert_to_trapi_predicate_format(parent_name_english)
                parent_to_child_dict[parent_name].add(slot_name)
            inverse_name = info.get("inverse")
            if inverse_name:
                inverse_name_formatted = _convert_to_trapi_predicate_format(inverse_name)
                inverses_map[slot_name] = inverse_name_formatted
        # Recursively build the predicates tree starting with the root
        biolink_tree.create_node(root_predicate, root_predicate)
        _create_tree_recursive(root_predicate, parent_to_child_dict, biolink_tree)
    else:
        logging.warning(f"Unable to load Biolink yaml file. Will not be able to factor predicate ancestors "
                        f"or inverses into meta triples.")

    # Then use the biolink tree to build up a more convenient map of predicate ancestors
    ancestors_map = defaultdict(set)
    for predicate_node in biolink_tree.all_nodes():
        predicate = predicate_node.identifier
        ancestors_map[predicate] = _get_ancestors(predicate, biolink_tree, root_predicate)

    return ancestors_map, inverses_map


def build_meta_kg(nodes_by_id: Dict[str, Dict[str, any]], edges_by_id: Dict[str, Dict[str, any]],
                  meta_kg_file_name: str, label_property_name: str, biolink_model_version: str, is_test: bool):
    predicate_ancestors, inverses_map = _create_expanded_predicates_maps(biolink_model_version)
    logging.info("Gathering all meta triples..")
    meta_triples = set()
    for edge in edges_by_id.values():
        subject_node_id = edge["subject"]
        object_node_id = edge["object"]
        if not is_test or (subject_node_id in nodes_by_id and object_node_id in nodes_by_id):
            subject_node = nodes_by_id[subject_node_id]
            object_node = nodes_by_id[object_node_id]
            subject_categories = subject_node[label_property_name]
            object_categories = object_node[label_property_name]
            predicates = predicate_ancestors.get(edge["predicate"], {edge["predicate"]})
            for subject_category in subject_categories:
                for predicate in predicates:
                    for object_category in object_categories:
                        meta_triples.add((subject_category, predicate, object_category))
                        # Add the inverse of this meta triple as well (and its ancestors), if one exists
                        if inverses_map.get(predicate):
                            inverse_predicate = inverses_map[predicate]
                            inverse_ancestors = predicate_ancestors.get(inverse_predicate, {inverse_predicate})
                            for inverse_ancestor in inverse_ancestors:
                                meta_triples.add((object_category, inverse_ancestor, subject_category))
    meta_edges = [{"subject": triple[0], "predicate": triple[1], "object": triple[2]} for triple in meta_triples]
    logging.info(f"Created {len(meta_edges)} meta edges")

    logging.info("Gathering all meta nodes..")
    with open(f"{KG2C_DIR}/equivalent_curies.pickle", "rb") as equiv_curies_file:
        equivalent_curies_dict = pickle.load(equiv_curies_file)
    meta_nodes = defaultdict(lambda: defaultdict(lambda: set()))
    for node_id, node in nodes_by_id.items():
        equivalent_curies = equivalent_curies_dict.get(node_id, [node_id])
        prefixes = {curie.split(":")[0] for curie in equivalent_curies}
        categories = node[label_property_name]
        for category in categories:
            meta_nodes[category]["id_prefixes"].update(prefixes)
    logging.info(f"Created {len(meta_nodes)} meta nodes")

    logging.info("Saving meta KG to JSON file..")
    meta_kg = {"nodes": meta_nodes, "edges": meta_edges}
    with open(f"{KG2C_DIR}/{meta_kg_file_name}", "w+") as meta_kg_file:
        json.dump(meta_kg, meta_kg_file, default=serialize_with_sets)


def add_neighbor_counts_to_sqlite(nodes_by_id: Dict[str, Dict[str, any]], edges_by_id: Dict[str, Dict[str, any]],
                                  sqlite_file_name: str, label_property_name: str, is_test: bool):
    logging.info("Counting up node neighbors by category..")
    # First gather neighbors of each node by label/category
    neighbors_by_label = defaultdict(lambda: defaultdict(lambda: set()))
    for edge in edges_by_id.values():
        subject_node_id = edge["subject"]
        object_node_id = edge["object"]
        if not is_test or (subject_node_id in nodes_by_id and object_node_id in nodes_by_id):
            subject_node = nodes_by_id[subject_node_id]
            object_node = nodes_by_id[object_node_id]
            for label in object_node[label_property_name]:
                neighbors_by_label[subject_node_id][label].add(object_node_id)
            for label in subject_node[label_property_name]:
                neighbors_by_label[object_node_id][label].add(subject_node_id)

    # Then record only the counts of neighbors per label/category
    neighbor_counts = defaultdict(dict)
    for node_id, neighbors_dict in neighbors_by_label.items():
        for label, neighbor_ids in neighbors_dict.items():
            neighbor_counts[node_id][label] = len(neighbor_ids)

    # Then write these counts to the sqlite file
    logging.info(f"Saving neighbor counts (for {len(neighbor_counts)} nodes) to sqlite..")
    connection = sqlite3.connect(sqlite_file_name)
    connection.execute("DROP TABLE IF EXISTS neighbors")
    connection.execute("CREATE TABLE neighbors (id TEXT, neighbor_counts TEXT)")
    rows = [(node_id, json.dumps(neighbor_counts)) for node_id, neighbor_counts in neighbor_counts.items()]
    connection.executemany(f"INSERT INTO neighbors (id, neighbor_counts) VALUES (?, ?)", rows)
    connection.execute("CREATE UNIQUE INDEX node_neighbor_index ON neighbors (id)")
    connection.commit()
    cursor = connection.execute(f"SELECT COUNT(*) FROM neighbors")
    logging.info(f"Done adding neighbor counts to sqlite; neighbors table contains {cursor.fetchone()[0]} rows")
    cursor.close()
    connection.close()


def add_category_counts_to_sqlite(nodes_by_id: Dict[str, Dict[str, any]], sqlite_file_name: str,
                                  label_property_name: str):
    logging.info("Counting up nodes by category..")
    # Organize node IDs by their categories/labels
    nodes_by_label = defaultdict(set)
    for node_id, node in nodes_by_id.items():
        for category in node[label_property_name]:
            nodes_by_label[category].add(node_id)

    # Then write these counts to the sqlite file
    logging.info(f"Saving category counts (for {len(nodes_by_label)} categories) to sqlite..")
    connection = sqlite3.connect(sqlite_file_name)
    connection.execute("DROP TABLE IF EXISTS category_counts")
    connection.execute("CREATE TABLE category_counts (category TEXT, count INTEGER)")
    rows = [(category, len(node_ids)) for category, node_ids in nodes_by_label.items()]
    connection.executemany(f"INSERT INTO category_counts (category, count) VALUES (?, ?)", rows)
    connection.execute("CREATE UNIQUE INDEX category_index ON category_counts (category)")
    connection.commit()
    cursor = connection.execute(f"SELECT COUNT(*) FROM category_counts")
    logging.info(f"Done adding category counts to sqlite; category_counts table contains "
                       f"{cursor.fetchone()[0]} rows")
    cursor.close()
    connection.close()


def record_meta_kg_info(biolink_version: str, is_test: bool):
    input_kg_file_name = f"kg2c_lite{'_test' if is_test else ''}.json"
    meta_kg_file_name = f"kg2c_meta_kg{'_test' if is_test else ''}.json"
    sqlite_file_name = f"kg2c{'_test' if is_test else ''}.sqlite"
    label_property_name = "expanded_categories"

    start = time.time()
    with open(f"{KG2C_DIR}/{input_kg_file_name}", "r") as input_kg_file:
        logging.info(f"Loading {input_kg_file_name} into memory..")
        kg2c_dict = json.load(input_kg_file)
        nodes_by_id = {node["id"]: node for node in kg2c_dict["nodes"]}
        edges_by_id = {edge["id"]: edge for edge in kg2c_dict["edges"]}
        del kg2c_dict

    build_meta_kg(nodes_by_id, edges_by_id, meta_kg_file_name, label_property_name, biolink_version, is_test)
    add_neighbor_counts_to_sqlite(nodes_by_id, edges_by_id, sqlite_file_name, label_property_name, is_test)
    add_category_counts_to_sqlite(nodes_by_id, sqlite_file_name, label_property_name)

    logging.info(f"Recording meta KG info took {round((time.time() - start) / 60, 1)} minutes.")


def main():
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s %(levelname)s: %(message)s',
                        handlers=[logging.FileHandler("metainfo.log"),
                                  logging.StreamHandler()])
    logging.info("Starting to record KG2c meta info..")
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument("biolink_model_version", type=str)
    arg_parser.add_argument("--test", dest="test", action='store_true', default=False)
    args = arg_parser.parse_args()

    record_meta_kg_info(args.biolink_model_version, args.test)


if __name__ == "__main__":
    main()
