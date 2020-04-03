# Phylogeographic reconstruction using air transportation data
This repository contains all data and software for the manuscript ["Phylogeographic reconstruction using air transportation data and its application to the 2009 H1N1 influenza A pandemic"](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1007101) published in PLOS Computational Biology.

## Data
This folder contains data for all steps of the simulation and evaluation, including:
* the gvd file specifying the model for the geographic simulation in GLEAMviz, as well as the output of one simulation used in this publication
* the input and configuration for the simulation of the sampling, the tree and the sequences with FAVITES
* the output for all 50 simulations, including trees, sequences and geographic locations for all nodes of the tree
* the result of the parsimonious phylogeographic reconstruction for all 50 simulations
* the xml file used for the analysis with BEAST stating all parameters, as well as the maximum clade credibility trees and trees with the most probable locations for each nodes that were used for the evaluation

For further details on all available files, please see the [readme in the data directory](https://github.com/hzi-bifo/Phylogeography_Paper/blob/master/Data/README.md).

## Figures&Tables
This folder contains all figures and tables of the manuscript, as well as some additional tables stating all Fréchet tree distances.

## Software
This folder contains all codes for:
* the simulation pipeline that prepares the input for FAVITES based on the GLEAMviz output, calls FAVITES to simulate sampling, tree and sequences and postprocesses the output
* the parsimonious phylogeographic reconstruction using the Sankoff algorithm
* the summary of the maximum clade credibility tree created by BEAST

For details stating dependencies, necessary input files as well as instructions how to run the software, please see the [readme for the simulation](https://github.com/hzi-bifo/Phylogeography_Paper/blob/master/Software/Simulation/README.md) as well as the [readme for the reconstruction](https://github.com/hzi-bifo/Phylogeography_Paper/blob/master/Software/Reconstruction/README.md).

The distance matrices used for the parsimonious reconstruction can be found [in this data repository](https://zenodo.org/record/2643163#.XMqf4kNS-EI).

Software for the comparison of the reconstructed spread to the simulated one can be found in the [FrechetTreeDistance repository](https://github.com/hzi-bifo/FrechetTreeDistance).
