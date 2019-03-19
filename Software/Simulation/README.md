The simulation pipeline takes the GLEAMviz output to create input files for FAVITES, runs FAVITES using the Docker image and processes the output files.

It requires the following software:
* R and Rscript (tested on version 3.4.4)
* The R package ape (tested on version 5.1)
* FAVITES (https://github.com/niemasd/FAVITES) with Python3 and Docker

The pipeline needs the following input:
* a list of transmissions as stated in the seedings.tsv file created by GLEAMviz
* the corresponding metadata
* the path to run FAVITES via the Docker image
* the config file used to run FAVITES
* the name of the output folder

Using the data in this repository, the pipeline can be called from this folder via:

> bash simulation_pipeline.sh ../../Data/Gleamviz/seedings.tsv ../../Data/Gleamviz/metadata_cities.tsv /path/to/FAVITES/run_favites_docker.py ../../Data/FAVITES/flu_spread_config.json simulation_output
