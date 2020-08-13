# What is KG2?

KG2 is the second-generation biomedical knowledge graph for the
[ARAX](https://github.com/RTXteam/RTX) system.  The GitHub subdirectory
`RTX/code/kg2` (including sub-subdirectories) centralizes all of the code for
building KG2 and all of the documentation about how to build, host, access, and
use KG2. The KG2 build system produces knowledge graphs in a
[Biolink model](https://biolink.github.io/biolink-model/) standard-compliant
JSON format and in a tab-separated value (TSV) format that can be imported into
a [Neo4j](https://neo4j.com) graph database system. Through additional scripts
in the `canonicalized` subdirectory, the build system can produce a
"canonicalized" knowledge graph where synonym concepts (nodes) are
identified. Through additional scripts in the `mediKanren` subdirectory, the
build system can produce an export of the KG2 knowledge graph that is suitable
for importing into the [mediKanren](https://github.com/webyrd/mediKanren)
biomedical reasoning system.

# KG2 team contact information

## Maintainers

- Stephen Ramsey, Oregon State University (stephen.ramsey@oregonstate.edu)
- Amy Glen, Oregon State University (glena@oregonstate.edu)

## Bug reports

Please use the GitHub issues page for this project, and add the label `kg2`.

# How to access RTX KG2

## Neo4j read-only endpoint for RTX KG2 as a graph database

http://kg2endpoint.rtx.ai:7474

(contact the KG2 maintainer for the username and password)

# What data sources are used in KG2?

Information from many knowledge databases is combined in bulding KG2, including
the entire contents of
[KG1](https://github.com/RTXteam/RTX/tree/master/code/reasoningtool), the RTX
first-generation knowledge graph.

| Knowledge source                | Type     | KG1 | KG2 | Redistribution license info                                                                                                                      | Home page                                                      |
|---------------------------------|----------|-----|-----|--------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------|
| Chembl   [without metabolism]   | data     | x   | x   | [link](https://chembl.gitbook.io/chembl-interface-documentation/about#data-licensing)                                                            | [link](https://www.ebi.ac.uk/chembl/)                                  |
| DGIdb                           | data     | x   | x   | [link](https://github.com/griffithlab/dgi-db/blob/master/LICENSE)                                                                                | [link](http://www.dgidb.org/)                                          |
| DisGeNET                        | data     | x   | x   | [link](http://www.disgenet.org/legal)                                                                                                            | [link](http://www.disgenet.org/)                                       |
| DrugBank                        | data     |     | x   | [link](https://www.drugbank.ca/legal/terms_of_use)                                                                                               | [link](https://www.drugbank.ca/)                                       |
| Ensembl Genes                   | data     |     | x   | [link](https://uswest.ensembl.org/info/about/legal/code_licence.html)                                                                            | [link](https://uswest.ensembl.org/index.html)                          |
| GeneProf                        | data     | x   | x   |                                                                                                                                                  | [link](https://bio.tools/geneprof)                                     |
| GO annotations from EBI         | data     |     | x   |                                                                                                                                                  | [link](https://www.ebi.ac.uk/GOA/)                                     |
| GtP                             | data     |     | x   | [link](https://www.guidetopharmacology.org/about.jsp#license)                                                                                    | [link](https://www.guidetopharmacology.org/)                           |
| HMDB                            | data     | x   | x   |                                                                                                                                                  | [link](http://www.hmdb.ca/)                                            |
| KEGG                            | data     | x   | x   | [link](https://www.kegg.jp/kegg/legal.html)                                                                                                      | [link](https://www.genome.jp/kegg/)                                    |
| miRBase                         | data     | x   | x   | [link](http://mirbase.org/help/FAQs.shtml#Do%20I%20need%20permission%20to%20download/use%20data%20contained%20in%20miRBase%20for%20my%20own%20research?) | [link](http://www.mirbase.org/)                                |
| miRGate                         | data     | x   | x   |                                                                                                                                                  | [link](http://mirgate.bioinfo.cnio.es/miRGate/)                        |
| MyChem.info                     | data     | x   | x   |                                                                                                                                                  | [link](https://mychem.info/)                                           |
| MyGene.info                     | data     | x   | x   |                                                                                                                                                  | [link](https://mygene.info/)                                           |
| NCBI Genes                      | data     |     | x   |                                                                                                                                                  | [link](https://www.ncbi.nlm.nih.gov/gene)                              |
| OMIM                            | data     | x   | x   | [link](https://www.omim.org/help/copyright)                                                                                                      | [link](https://www.omim.org/)                                          |
| Pathway Commons                 | data     | x   | x   |                                                                                                                                                  | [link](https://www.pathwaycommons.org/)                                |
| PathWhiz                        | data     |     | x   |                                                                                                                                                  | [link](https://smpdb.ca/pathwhiz)                                      |
| Pharos                          | data     | x   | x   |                                                                                                                                                  | [link](https://pharos.nih.gov/)                                        |
| Reactome                        | data     | x   | x   | [link](https://reactome.org/license)                                                                                                             | [link](https://reactome.org/)                                          |
| SciGraph data                   | data     | x   | x   |                                                                                                                                                  | [link](https://scigraph-data.monarchinitiative.org/scigraph/docs/)     |
| SemMedDB                        | data     | x   | x   | [link](https://skr3.nlm.nih.gov/TermsAndCond.html)                                                                                               | [link](https://skr3.nlm.nih.gov/SemMedDB/)                             |
| SIDER                           | data     | x   | x   |                                                                                                                                                  | [link](http://sideeffects.embl.de/)                                    |
| SMPDB                           | data     |     | x   | [link](https://smpdb.ca/about#citing)                                                                                                            | [link](https://smpdb.ca/)                                              |
| Therapeutic Target Database     | data     |     | x   |                                                                                                                                                  | [link](http://bidd.nus.edu.sg/group/cjttd/)                            |
| UniChem   [partial]             | data     |     | x   |                                                                                                                                                  | [link](https://www.ebi.ac.uk/unichem/)                                 |
| UniProtKB   [human + pathogens] | data     | x   | x   | [link](https://www.uniprot.org/help/license)                                                                                                     | [link](https://www.uniprot.org/help/uniprotkb)                         |
| Biolink model                   | ontology | x   | x   |                                                                                                                                                  | [link](https://github.com/biolink/biolink-api)                         |
| BFO                             | ontology |     | x   |                                                                                                                                                  | [link](http://www.obofoundry.org/ontology/bfo.html)                    |
| BSPO                            | ontology |     | x   |                                                                                                                                                  | [link](http://www.obofoundry.org/ontology/bspo.html)                   |
| Cell Ontology                   | ontology | x   | x   |                                                                                                                                                  | [link](http://www.obofoundry.org/ontology/cl.html)                     |
| ChEBI                           | ontology |     | x   |                                                                                                                                                  | [link](http://www.obofoundry.org/ontology/chebi.html)                  |
| DDANAT                          | ontology |     | x   |                                                                                                                                                  | [link](http://www.obofoundry.org/ontology/ddanat.html)                 |
| DOID                            | ontology | x   | x   |                                                                                                                                                  | [link](http://www.obofoundry.org/ontology/doid.html)                   |
| EFO                             | ontology |     | x   |                                                                                                                                                  | [link](https://www.ebi.ac.uk/efo/)                                     |
| EHDAA2                          | ontology |     | x   |                                                                                                                                                  | [link](http://obofoundry.org/ontology/ehdaa2.html)                     |
| FMA                             | ontology |     | x   |                                                                                                                                                  | [link](http://www.obofoundry.org/ontology/fma.html)                    |
| FOODON                          | ontology |     | x   |                                                                                                                                                  | [link](http://www.obofoundry.org/ontology/foodon.html)                 |
| GO                              | ontology | x   | x   |                                                                                                                                                  | [link](http://www.obofoundry.org/ontology/go.html)                     |
| GO-Plus                         | ontology |     | x   |                                                                                                                                                  | [link](http://www.obofoundry.org/ontology/go.html)                     |
| HPO                             | ontology |     | x   |                                                                                                                                                  | [link](http://www.obofoundry.org/ontology/hp.html)                     |
| Mondo                           | ontology |     | x   |                                                                                                                                                  | [link](http://obofoundry.org/ontology/mondo.html)                      |
| NBO                             | ontology |     | x   |                                                                                                                                                  | [link](http://www.obofoundry.org/ontology/nbo.html)                    |
| OLS (Ontology Lookup Service)   | ontology | x   | x   | [link](https://github.com/EBISPOT/OLS/blob/master/LICENSE)                                                                                       | [link](https://www.ebi.ac.uk/ols/index)                                |
| ORDO                            | ontology |     | x   |                                                                                                                                                  | [link](https://bioportal.bioontology.org/ontologies/ORDO)              |
| OxO                             | ontology | x   | x   |                                                                                                                                                  | [link](https://www.ebi.ac.uk/spot/oxo/)                                |
| PATO                            | ontology |     | x   |                                                                                                                                                  | [link](http://www.obofoundry.org/ontology/pato.html)                   |
| Prefix Commons                  | ontology | x   | x   |                                                                                                                                                  | [link](https://prefixcommons.org/)                                     |
| PRO                             | ontology |     | x   |                                                                                                                                                  | [link](http://www.obofoundry.org/ontology/pr.html)                     |
| RO                              | ontology |     | x   |                                                                                                                                                  | [link](http://www.obofoundry.org/ontology/ro.html)                     |
| SciGraph ontology               | ontology | x   | x   |                                                                                                                                                  | [link](https://scigraph-ontology.monarchinitiative.org/scigraph/docs/) |
| SNOMED CT                       | ontology | x   | x   | [link](https://www.nlm.nih.gov/healthit/snomedct/snomed_licensing.html)                                                                          | [link](http://www.snomed.org)                                          |
| taxslim                         | ontology |     | x   |                                                                                                                                                  | [link](http://www.obofoundry.org/ontology/ncbitaxon.html)              |
| Uberon                          | ontology |     | x   |                                                                                                                                                  | [link](http://www.obofoundry.org/ontology/uberon.html)                 |
| UMLS                            | ontology | x   | x   | [link](https://www.nlm.nih.gov/research/umls/knowledge_sources/metathesaurus/release/license_agreement.html)                                     | [link](https://www.nlm.nih.gov/research/umls/index.html)               |

# How to build your own RTX KG2

## General notes:

The KG2 build system is designed only to run in an Ubuntu 18.04 environment
(i.e., either (i) an Ubuntu 18.04 host OS or (ii) Ubuntu 18.04 running in a
Docker container) as a non-root user which must have passwordless `sudo` enabled
and should have `bash` as the default shell (the build commands in the
instructions in this README page assume a `bash` shell). The build system will
also need (but will set up for itself, prompting the user for access keys at
setup time) a local configured installation of the Amazon Web Services (AWS)
command-line interface (CLI) software in order to be able to retrieve various
required files on-demand from a storage bucket in the AWS Simple Storage Service
(S3) system. Currently, KG2 is built using a set of `bash` scripts that are
designed to run in Amazon's Elastic Compute Cloud (EC2), and thus,
configurability and/or coexisting with other installed software pipelines was
not a design consideration for the build system. The KG2 build system's `bash`
scripts create three subdirectories under the `${HOME}` directory of whatever
Linux user account you use to run the KG2 build software (if you run on an EC2
Ubuntu instance, this directory would by default be `/home/ubuntu`):

1. `~/kg2-build`
2. `~/kg2-code`
3. `~/kg2-venv`

The various directories used by the KG2 build system are configured in the
`bash` include file `master-config.shinc`. Most of the KG2 build system code is
written in the Python3 programming language, and designed to run in python3.7
(and tested specifically in python 3.7.5).

Note about atomicity of file moving: The build software is designed to run with
the `kg2-build` directory being in the same file system as the Python temporary
file directory (i.e., the directory name that is returned by the variable
`tempfile.tempdir` in Python). If the KG2 software or installation is modified
so that `kg2-build` is in a different file system from the file system in which
the directory `tempfile.tempdir` (as referenced in the `tempfile` python module)
resides, then the file moving operations that are performed by the KG2 build
software will not be atomic and interruption of `build-kg2.sh` or its
subprocesses could then leave a source data file in a half-downloaded (i.e.,
broken) state.

## Setup your computing environment

The computing environment where you will be running the KG2 build should be
running **Ubuntu 18.04**.  Your build environment should have the following
*minimum* specifications:

- 256 GiB of system memory
- 1,023 GiB of disk space in the root file system 
- high-speed networking (20 Gb/s networking) and storage
- ideally, AWS region `us-west-2` since that is where the RTX KG2 S3 buckets are located

## The KG2 build system assumes there is no MySQL database already present

The target Ubuntu system in which you will run the KG2 build should *not* have MySQL
installed; if MySQL is installed, you will need to delete it using the following
`bash` command, which requires `curl`: (WARNING! Please don't run this command
without first making a backup image of your system, such as an AMI):

    source <(curl -s https://raw.githubusercontent.com/RTXteam/RTX/master/code/kg2/delete-mysql-ubuntu.sh)

The KG2 build system has been tested *only* under Ubuntu 18.04. If you want to
build KG2 but don't have a native installation of Ubuntu 18.04 available, your
best bet would be to use Docker (see Option 3 below). 

## AWS authentication key and AWS buckets

In order to be able to build KG2, you'll need to have an AWS authentication key
pair that is configured to be able to read from the `s3://rtx-kg2` S3 bucket
(ask the KG2 maintainer to set this up), so that the build script can download a
copy of the full Unified Medical Language System (UMLS) distribution.  You will
be asked (by the AWS Command-line Interface, CLI) to provide this authentication
key when you run the KG2 setup script. Your configured AWS CLI will also need to
be able to programmatically write to the (publicly readable) S3 bucket
`s3://rtx-kg2-public` (both buckets are in the `us-west-2` AWS region). The KG2
build script downloads the UMLS distribution (including SNOMED CT) from the
private S3 bucket `rtx-kg2` (IANAL, but it appears that the UMLS is encumbered
by a license preventing redistribution so I have not hosted them on a public
server for download; but you can get it for free at the
[UMLS website](https://www.nlm.nih.gov/research/umls/) if you agree to the UMLS
license terms) and it uploads the final output file `kg2.json.gz` to the public
S3 bucket `rtx-kg2-public`. Alternatively, you can set up your own S3 bucket to
which to copy the gzipped KG2 JSON file (which you would specify in the
configuration file `master-config.shinc`), or in the file `build-kg2.sh`, you
can comment out the line that copies the final gzipped JSON file to the S3
bucket. You will also need to edit and place a file
`RTXConfiguration-config.json` in the S3 bucket `s3://rtx-kg2/`; this file
provides credentials (username, password, and HTTP URI for Neo4j REST API
server) for accessing a RTX KG1 Neo4j endpoint; the KG2 build system will dump
the KG1 graph from that endpoint and will merge that graph into KG2. As a
minimal example of the data format for `RTXConfiguration-config.json`, see the
file `RTXConfiguration-config-EXAMPLE.json` in this repository code directory
(note: that config file can contain authentication information for additional
server types in the RTX system; those are not shown in the example file in this
code directory). The KG1 Neo4j endpoint need not (and in general, won't be)
hosted in the same EC2 instance that hosts the KG2 build system. Currently, the
KG1 Neo4j endpoint is hosted in the instance `arax.rtx.ai`; the URI of its Neo4j
REST HTTP interface is: `http://arax.rtx.ai:7474`.

## My normal EC2 instance

The KG2 build software has been tested with the following instance type:

- AMI: Ubuntu Server 18.04 LTS (HVM), SSD Volume Type - `ami-005bdb005fb00e791` (64-bit x86)
- Instance type: `r5a.8xlarge` (256 GiB of memory)
- Storage: 1,023 GiB, Elastic Block Storage
- Security Group: ingress TCP packets on port 22 (`ssh`) permitted

As of summer 2019, an on-demand `r5a.8xlarge` instance in the `us-west-2` AWS
region costs $1.81 per hour, so the cost to build KG2 (estimated to take 67 hours)
would be approximately $121 (this is currently just a rough estimate, plus or
minus 20%). [Unfortunately, AWS doesn't seem to allow the provisioning of spot
instances while specifying minimum memory greater than 240 GiB; but perhaps soon
that will happen, and if so, it could save significantly on the cost of updating the RTX KG2.]
There is also an experimental Snakemake build system which takes advantage of
symmetric multiprocessing to bring the build time down to 54 hours (Option #2).

## Build instructions

Note: to follow the instructions for Option 3 and Option 4 below, in addition to
the requirements as described above, you will need to be using the `bash` shell
on your *local* computer.

### Build Option 1: build KG2 serially (about 67 hours) directly on an Ubuntu system:

These instructions assume that you are logged into the target Ubuntu system, and
that the Ubuntu system has *not* previously had `setup-kg2-build.sh` run (if it
has previously had `setup-kg2-build.sh` run, you may wish to clear out the
instance by running `clear-instance.sh` before proceeding, in order to ensure
that you are getting the exact python packages needed in the latest
`requirements-kg2-build.txt` file in the KG2 codebase):

(1) Install the `git` and `screen` packages if they are not already installed (though
in an Ubuntu 18.04 instance created using the standard AWS AMI, they should already
be installed):

    sudo apt-get update && sudo apt-get install -y screen git

(2) change to the home directory for user `ubuntu`:

    cd 
    
(3) Clone the RTX software from GitHub:

    git clone https://github.com/RTXteam/RTX.git

[An advantage to having the `git clone` command separated out from the install script is
that it provides control over which branch you want to use for the KG2 build code.]

(4) Setup the KG2 build system: 

    bash -x RTX/code/kg2/setup-kg2-build.sh

Note that there is no need to redirect `stdout` or `stderr` to a log file, when
executing `setup-kg2-build.sh`; this is because the script saves its own `stdout` and
`stderr` to a log file `${HOME}/setup-kg2-build.log`. This script takes just a
few minutes to complete. At some point, the script will print

    fatal error: Unable to locate credentials
    
This is normal. The script will then prompt you to enter your AWS Access Key ID
and AWS Secret Access Key, for an AWS account with access to the private S3
bucket that is configured in `master-config.shinc`. It will also ask you to
enter your default AWS region, which in our case is normally `us-west-2` (you
should enter the AWS region that hosts the private S3 bucket that you intend to
use with the KG2 build system). When prompted `Default output format [None]`,
just hit enter/return.

(5) Look in the log file `${HOME}/setup-kg2-build.log` to see if the script
completed successfully; it should end with `======= script finished ======`.

(6) [**THIS STEP IS NORMALLY SKIPPED**] If (and *only* if) you have made code
changes to KG2 that will cause a change to the schema for KG2 (or added a major
new upstream source database), you will want to increment the "major" release
number for KG2. To do that, at this step of the build process, you would run
this command:

    touch ~/kg2-build/major-release

(7) Initiate a `screen` session to provide a stable pseudo-tty:

    screen

(8) Within the `screen` session, run:

    bash -x ~/kg2-code/build-kg2.sh all

Then exit screen (`ctrl-a d`). Note that there is no need to redirect `stdout`
or `stderr` to a log file, when executing `build-kg2.sh`; this is because the
script saves its own `stdout` and `stderr` to a log file `build-kg2.log`. You can 
watch the progress of your KG2 build by using this command:

    tail -f ~/kg2-build/build-kg2.log
    
Note that the `build-multi-ont-kg.sh` script also saves `stderr` from running `multi_ont_to_json_kg.py`
to a file `~/kg2-build/build-kg2-ont-stderr.log`.

#### Note about versioning of KG2

KG2 has semantic versioning with a graph/major/minor release system:
- The graph release number is always 2. 
- The major release number is incremented when the schema for KG2 is changed
  (and the minor release is set to zero in that case)
- The minor release number is incremented for each non-test build for which the
  schema is not modified.
  
So an example version of KG2 would be "RTX KG 2.1.3" (graph release 2, major
release 1, minor release 3). This build version is recorded in three places:
- the top-level `build` slot in the KG2 JSON file
- in the `name` field of a node object with `id` field `RTX:KG2` (in both the
  JSON version of the KG and in the Neo4j version of the KG)
- the file `s3://rtx-kg2-public/kg2-version.txt` in the S3 bucket `rtx-kg2-public`.

By default, the KG2 build process (as outlined above) will automatically
increment the minor release number and update the file `kg2-version.txt` in the
S3 bucket.  If you are doing a build in which the KG2 schema has changed, you
should trigger the incrementing of the major release version by making sure to
do step (6) above.  The build script (specifically, the script `version.sh`)
will automatically delete the file `~/kg2-build/major-release` so that it will
not persist for the next build. Note: if the build system happens to terminate
unexpectedly while running `version.sh`, you should check what state the file
`s3://rtx-kg2-public/kg2-version.txt` was left in.

#### Partial build of KG2

In some circumstances, if there are no updates to any of the upstream source
databases (like UMLS, ChEMBL, SemMedDB, etc.) that are extracted using
`extract*.sh` scripts (as shown in the list of KG2 scripts), you can trigger
a "partial" build that just downloads the OBO ontologies and does a build
downstream of that. This can be useful in cases where you are testing a change
to one of the YAML configuration files for KG2, for example. To do a partial
build, in Step (8) above, you would run

    bash -x ~/kg2-code/build-kg2.sh

(note the absence of the `all` argument to `build-kg2.sh`). A partial build of KG2
may take about 12 hours.

#### Test build of KG2

For testing/debugging purposes, it is helpful to have a faster way to exercise
the KG2 build code. For this, you may want to execute a "test" build. This build
mode builds a smaller graph with a significantly reduced set of nodes and edges.
To execute a "test" build, in Step (8) above, you would run:

    bash -x ~/kg2-code/build-kg2.sh test
    
In the case of a test build, the build log file names are changed:

    ~/kg2-build/build-kg2-test.log
    ~/kg2-build/build-kg2-ont-test-stderr.log

and all of the intermediate JSON files that the build system creates will have
`-test` appended to the filename before the usual filename suffix (`.json`).

### Build Option 2: build KG2 in parallel (about 54 hours) directly on an Ubuntu system: (NOT CURRENTLY WORKING, see Issue 694)

<!-- (1)-(5) Follow steps (1) through (5) from Option 1 -->

<!-- (6) Initiate a `screen` session to provide a stable pseudo-tty: -->

<!--     screen -->

<!-- (7) Within the `screen` session, run: -->

<!--     ~/kg2-code/build-kg2-snakemake.sh -->

<!-- to generate the full size knowledge graph. Then exit screen (using `ctrl-a d`). Note that there is  -->
<!-- no need to redirect `stdout` or `stderr` to a log file when executing `build-kg2-snakemake.sh`;  -->
<!-- this is because the script saves its own `stdout` and `stderr` to a log file  -->
<!-- (`build-kg2-snakemake.log`, located in the build directory). If you don't want to see all of the  -->
<!-- printouts, but want to know which files have finished, you can look at the log file in `.snakemake/log/`  -->
<!-- (if you have run snakemake before, choose the file named with the date you started the build). -->

<!-- If you want to create a test size graph (about 31 hours), run: -->

<!--     ~/kg2-code/build-kg2-snakemake.sh test -->

<!-- You can watch the progress of your KG2 build by using this command: -->

<!--     tail -f ~/kg2-build/build-kg2-snakemake.log -->
    
<!-- Note that the `build-multi-ont-kg.sh` script also saves `stderr` from running `multi_ont_to_json_kg.py` -->
<!-- to a file `~/kg2-build/build-kg2-ont-stderr.log`. -->

<!-- (8) When the build is complete, look for the following line (the 2nd line from -->
<!--     the bottom) in `build-kg2-snakemake.log` and `.snakemake/log/` file (you only need -->
<!--     to check one): -->

<!--     22 of 22 steps (100%) done -->

<!-- If that line is present the Snakefile completed successfully (as more databases are added, 22 could grow to  -->
<!-- a larger number. The important piece is 100%). If any line says: -->

<!--     (exited with non-zero exit code) -->

<!-- the code failed. -->

### Build Option 3: setup ssh key exchange so you can build KG2 in a remote EC2 instance

This option requires that you have `curl` installed on your local computer. In a
`bash` terminal session, set up the remote EC2 instance by running this command
(requires `ssh` installed and in your path):

    source <(curl -s https://raw.githubusercontent.com/RTXteam/RTX/master/code/kg2/ec2-setup-remote-instance.sh)

You will be prompted to enter the path to your AWS PEM file and the hostname of
your AWS instance.  The script should then initiate a `bash` session on the
remote instance. Within that `bash` session, continue to follow the instructions
for Build Option 1, starting at step (4).

### Build Option 4: in an Ubuntu container in Docker

For Build Option 4, you will need a *lot* of disk space (see disk storage
requirements above) in the root file system, unless you modify the Docker
installation to store containers in some other (non-default) file system
location. Here are the instructions:

(1) Install Docker. If you are on Ubuntu 18.04 and you need to install Docker, you can
run this command in `bash` on the host OS:
   
    source <(curl -s https://raw.githubusercontent.com/RTXteam/RTX/master/code/kg2/install-docker.sh)
    
(otherwise, the subsequent commands in this section assume that Docker is
installed on whatever host system you are running). For some notes on how to
install Docker on MacOS via the Homebrew system, see
[macos-docker-notes.md](macos-docker-notes.md).  NOTE: if your docker
installation (like on macOS Homebrew) doesn't require `sudo`, just omit
`sudo` everywhere you see `sudo docker` in the steps below.

(2) Build a Docker image `kg2:latest`:

    sudo docker image build -t kg2 https://raw.githubusercontent.com/RTXteam/RTX/master/code/kg2/Dockerfile 
    
(3) Create a container called `kg2` from the `kg2:latest` image 

    sudo docker create --name kg2 kg2:latest

(4) Start the `kg2` container:

    sudo docker start kg2
    
(5) Open a bash shell as user `root` inside the container:

    sudo docker exec -it kg2 /bin/bash
    
(6) Become user `ubuntu`:

    su - ubuntu
    
Now follow the instructions for Build Option 1 above.

## The output KG

The `build-kg2.sh` script (run via one of the three methods shown above) creates
a gzipped JSON file `kg2-simplified.json.gz` and copies it to an S3 bucket
`rtx-kg2`. You can access the gzipped JSON file using the AWS command-line
interface (CLI) tool `aws` with the command

    aws s3 cp s3://rtx-kg2/kg2-simplified.json.gz .

The TSV files for the knowledge graph can be accessed via HTTP as well, 

    aws s3 cp s3://rtx-kg2/kg2-tsv.tar.gz .

You can access the various artifacts from the KG2 build (config file, log file,
etc.) at the AWS static website endpoint for the 
`rtx-kg2-public` S3 bucket: <http://rtx-kg2-public.s3-website-us-west-2.amazonaws.com/>

Each build of KG2 is labeled with a unique build date/timestamp. The build timestamp
can be found in the `build` slot of the `kg2-simplified.json` file and it can be
found in the node with ID `RTX:KG2` in the Neo4j KG2 database. Due to the size of KG2,
we are not currently archiving old builds of KG2 and that is why `kg2-simplified.json`
and the related large KG2 JSON files are stored in a *non-versioned* S3 bucket.

## Updating the KG2 build system

We generally try to make the KG2 shell scripts idempotent, following best
practice for *nix shell scripting. However, changes to `setup-kg2-build.sh` (or
`setup-kg2-neo4j.sh`) that would bring in a new version of a major software
dependency (e.g., Python) of the KG2 build system are not usually tested for
whether they can also upgrade an *existing* installation of the build system;
this is especially an issue for software dependencies that are installed using
`apt-get`. In the event that `setup-kg2-build.sh` undergoes a major change that
would trigger such an upgrade (e.g., from Python3.7 to Python3.8), instead of
rerunning `setup-kg2-build.sh` on your existing build system, we recommend that
you create a clean Ubuntu 18.04 instance and install using `setup-kg2-build.sh`.

## Hosting KG2 in a Neo4j server on a new AWS instance

We host our production KG2 graph database in Neo4j version 3.5.13 with APOC
3.5.0.4, on an Ubuntu 18.04 EC2 instance with 64 GiB of RAM and 8 vCPUs
(`r5a.2xlarge`) in the `us-east-2` AWS region, although it is possible to host KG2
on an `r5a.xlarge` instance and this is what we do for our test/dev KG2 host.

**Installation:** in a fresh Ubuntu 18.04 AWS
instance, as user `ubuntu`, run the following commands:

(1) Make sure you are in your home directory:

    cd
    
(2) Clone the RTX software from GitHub:

    git clone https://github.com/RTXteam/RTX.git

(3) Install and configure Neo4j, with APOC:

    RTX/code/kg2/setup-kg2-neo4j.sh

This script takes just a few minutes to complete. At some point, the script will
print

    fatal error: Unable to locate credentials
    
This is normal. The script will then prompt you to enter your AWS Access Key ID
and AWS Secret Access Key, for an AWS account with access to the private S3
bucket that is configured in `master-config.shinc`. It will also ask you to
enter your default AWS region; you should enter the AWS region that hosts the
private S3 bucket that you intend to use with the KG2 build system, which in our
case would be `us-west-2`. When prompted `Default output format [None]`, just
hit enter/return. Also, the setup script will print a warning

    WARNING: Max 1024 open files allowed, minimum of 40000 recommended. See the Neo4j manual.
    
but this, too, can be ignored [The `/lib/systemd/service/neo4j.service` file 
that is installed (indirectly) by the setup script actually sets the limit to 60000,
for when the Neo4j database system is run via systemd (but when running `neo4j-admin`
at the CLI to set the password, Neo4j doesn't know this and it reports a limit warning).]

(4) Look in the log file `${HOME}/setup-kg2-neo4j.log` to see if the script
completed successfully; it should end with `======= script finished ======`.

(5) Load KG2 into Neo4j:

    RTX/code/kg2/tsv-to-neo4j.sh > ~/kg2-build/tsv-to-neo4j.log 2>&1

This script takes about an hour. You may wish to run it in a `screen` session.

(6) Look in the log file `~/kg2-build/tsv-to-neo4j.log` to see if the script
completed successfully; it should end with `======= script finished ======`.

## Reloading KG2 into an existing Neo4j server

Once you have loaded KG2 into Neo4j as described above, if you want to reload
KG2, just run (as user `ubuntu`):

    ~/RTX/code/kg2/tsv-to-neo4j.sh > ~/kg2-build/tsv-to-neo4j.log 2>&1

## Co-hosting the KG2 build system and Neo4j server?

In theory, it should be possible to install Neo4j and load KG2 into it on the
same Ubuntu instance where KG2 was built; but this workflow is usually not
tested since in our setup, we nearly always perform the KG2 build and Neo4j
hosting on separate AWS instances.

# Structure of the JSON KG2

The file `kg2.json` is an intermediate file that is probably only of use to KG2
developers.  The file `kg2-simplified.json` is a key artifact of the build
process that feeds into several downstream artifacts and may be of direct use to
application developers. The `kg2-simplified.json` JSON data structure is a
name-value pair object (i.e., dictionary) with the following keys:

## `build` slot
The top-level `build` slot contains a dictionary whose keys are:

  - `version`: a string containing the version identifier for the KG2 build,
    like `RTX KG2.2.3`.  For a "test" build, the version identifier will have
    `-TEST` appended to it.
  - `timestamp_utc`: a string containing the ISO 8601 date/timestamp (in UTC)
  for the build, like this: `2020-08-11 21:51`.
  
## `nodes` slot

The top-level `nodes` slot contains a list of node objects. Each node object has
the following keys:
  - `category`: a string containing a CURIE ID for the semantic type of the
    node, as a category in the Biolink model. Example: `biolink:Gene`.
  - `category label`: a `snake_case` representation of the `category` field,
    without the `biolink:` CURIE prefix.
  - `creation date`: a string identifier of the date in which this node object
  was first created in the upstream source database; it has (at present) no
  consistent format, unfortunately (usual value is `null`).
  - `deprecated`: a Boolean field indicating whether or not this node has been
    deprecated by the upstream source database (usual value is `false`).
  - `description`: a narrative description field for the node, in prose text
  - `full name`: a longer name for the node (often is identical to the `name` field)
  - `id`: a CURIE ID for the node; this CURIE ID will be unique across nodes in
    KG2 (that constraint is enforced in the build process)
  - `iri`: a URI where the user can get more information about this node (we try
    to make these resolvable wherever possible)
  - `name`: a display name for the node
  - `provided by`: a CURIE ID (which corresponds to an actual node in KG2) for
  the upstream source database that is the definitive source for information
  about this node
  - `publications`: a list of CURIE IDs of publications (e.g., `PMID` or `ISBN`
    or `DOI` identifiers) that contain information about this node
  - `replaced by`: a CURIE ID for the node that replaces this node, for cases
    when this node has been deprecated (usually it is `null`).
  - `synonym`: a list of strings with synonyms for the node; if the node is a
  gene, the first entry in the list should be the official gene symbol; other
  types of information can for certain node types be found in this list, such as
  protein sequence information for UniProt protein nodes.
  - `update date`: a string identifier of the date in which the information for
  this node object was last updated in the upstream source database; it has (at
  present) no consitent format, unfortunately; it is usually not `null`.

## `edges` slot
- `edges`: a list of edge objects. Each edge object has the following keys:
  - `edge label`: a `snake_case` representation of the plain English label for
    the original predicate for the edge provided by the upstream source database
    (see the `relation` field)
  - `negated`: a Boolean field indicating whether or not the edge relationship
    is "negated"; usually `false`, in the normal build process for KG2
  - `object`: the CURIE ID (`id`) for the KG2 node that is the object of the
    edge
  - `provided by`: a list containing CURIE IDs (each of which should be a node
  in KG2) of the upstream source databases that reported this edge's specific
  combination of subject/predicate/object (in the case of multiple providers for
  an edge, the other fields like `publications` are merged from the information
  from the multiple sources).
  - `publications`: a list of CURIE IDs of publications supporting this edge
    (e.g., `PMID` or `ISBN` or `DOI` identifiers)
  - `publications info`: a dictionary whose keys are CURIE IDs from the list in the
  `publications` field, and whose values are described in the next subsection ("publication_info")
  - `relation`: a CURIE ID for the relation as reported by the upstream
    database source.
  - `simplified edge label`: a `snake_case` representation of the plain English
    label for the simplified predicate (see the `simplified relation`
    field); in most cases this is a predicate type from the Biolink model.
  - `simplified relation`: a CURIE ID for the simplified relation
  - `subject`: the CURIE ID (`id`) for the KG2 node that is the subject of the
    edge
  - `update date`: a string identifier of the date in which the information for
  this node object was last updated in the upstream source database; it has (at
  present) no consitent format, unfortunately; it is usually not `null`.

### `publication_info` slot

If it is not `null`, the `publication_info` object's values are objects containing
the following name/value pairs:
  - `publication date`: string representation of the date of the publication, in
    ISO 8601 format (`%Y-%m-%d %H:%i:%S`)
  - `sentence`: a string containing the natural language sentence from which the
    edge was inferred (this is only not `null` for SemMedDB edges, at present)
  - `subject score`: a string containing a confidence score; for SemMedDB edges,
    this score corresponds to a confidence with which the subject of the triple
    was correctly identified; for other edges (like ChEMBL drug to target
    predictinos), the score corresponds to a confidence in a computational
    prediction of the ligand-to-target binding relationship; NOTE: there at
    present no unified scale for this field, unfortunately
  - `object score`: for SemMedDB edges, this score corresponds to a confidence
    with which the subject of the triple was correctly identified; otherwise
    `null`

# For Developers

This section has some guidelines for KG2 developers

## KG2 coding standards

- For python, only python3 is allowed and please follow PEP8 formatting standards.
- Hard tabs are not permitted in source files such as python or bash (use spaces
instead).

# Credits

Thank you to the many people who have contributed to the development of RTX KG2:

## Code
Stephen Ramsey, Amy Glen, Finn Womack, Erica Wood, Veronica Flores, Deqing Qu, and Lindsey Kvarfordt.

## Advice and feedback
David Koslicki, Eric Deutsch, Yao Yao, Jared Roach, Chris Mungall, Tom Conlin, Matt Brush,
Chunlei Wu, Harold Solbrig, Will Byrd, Michael Patton, Jim Balhoff, Chunyu Ma, and Chris Bizon.

## Funding
National Center for Advancing Translational Sciences (award number OT2TR002520).

