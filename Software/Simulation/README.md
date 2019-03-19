## Simulation pipeline

The simulation pipeline takes the GLEAMviz output to create input files for FAVITES, runs FAVITES using the Docker image and processes the output files.

## Requirements

It requires the following software:
* R and Rscript (tested on version 3.4.4)
* The R package ape (tested on version 5.1)
* FAVITES (https://github.com/niemasd/FAVITES) with Python3 and Docker

## Input

The pipeline needs the following input:
* a list of transmissions as stated in the seedings.tsv file created by GLEAMviz
* the corresponding metadata
* the path to run FAVITES via the Docker image
* the config file used to run FAVITES
* the name of the output folder

## Running the pipeline

Using the data in this repository, the pipeline can be called from this folder via:

> bash simulation_pipeline.sh ../../Data/Gleamviz/seedings.tsv ../../Data/Gleamviz/metadata_cities.tsv /path/to/FAVITES/run_favites_docker.py ../../Data/FAVITES/flu_spread_config.json simulation_output

## Output

In the specified output folder, the following files are created:
* new_tree.labeled.phy: the simulated tree with labeled internal nodes
* new_tree.labeled.annotation.txt: locations for all tips and internal nodes (airports)
* new_tree.labeled.country.annotation.txt: locations for all tips and internal nodes (countries)
* tipdata.txt: locations for all tips (airports)
* tipdata.country.txt: locations for all tips (countries)
* simulated_seq_cds.fa: sequences simulated on the phylogenetic tree
* outgroup.fa: the (randomly generated) ancestral sequence used to simulate the sequences
