## Phylogeographic reconstruction

The script phylogeo_sankoff.R implements the phylogeographic reconstruction using the Sankoff algorithm using a cost matrix with distances between all possible locations.

Required software and tested versions are:
* R and Rscript (version 3.4.4)
* The R package ape (version 5.1)

Input arguments are:
* A rooted phylogenetic tree in Newick format
* A tab-separated text file with a column called label stating the tip label in the phylogenetic tree, and a column called location stating the observed sampling location
* A csv file containing a distance matrix with distances between all possible locations. The locations (row and column names) must match the locations stated for the tip label
* The prefix used for the output files

The script can be called via:
> Rscript phylogeo_sankoff.R \[tree\] \[locations\] \[distance matrix\] \[output\]

For example, to perform the reconstruction for the first simulation in the study using effective distances and airports as possible locations:
> Rscript phylogeo_sankoff.R ../../Data/Simulations/Sim_1/simulated_seq_cds.labeled.phy ../../Data/Simulations/Sim_1/tipdata.txt /path/to/effective.distance.matrix.csv reconstruction_effective

The output files are:
* \[output\].phy: the phylogenetic tree with added (or overwritten if previously available) node labels
* \[output\].annotation.phy: a tab-separated text file stating the labels and the observed and reconstructed locations for all tips and internal nodes

## Evaluation pipeline

todo
