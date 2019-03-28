This folder contains all input and result files for the simulation and reconstruction of phylogeographies.

## Gleamviz
* simulation.gvd: file specifying the model used for the spread simulation in GLEAMviz.
* seedings.tsv: output file of one simulation created with the model in simulation.gvd, including the origin, destination and time of new infections.
* metadata_cities.tsv: metadata to map airports or countries to the data in seedings.tsv.

## FAVITES
* favites_contacts.txt: contact network used as input for FAVITES, as defined via the GLEAMviz output in seedings.tsv.
* favites_transmissions.txt: transmissions used as input for FAVITES, as defined via the GLEAMviz output in seedings.tsv.
* flu_spread_config.json: configuration file specifying the simulation of the sampling, the tree and the sequences using FAVITES.

## Simulation
For each simulation:
* new_tree.labeled.phy: the simulated phylogenetic tree.
* new_tree.labeled.annotation.txt: the simulated phylogeographic spread (using airports) on the tree new_tree.labeled.phy.
* new_tree.labeled.country.annotation.txt: the simulated phylogeographic spread (using countries) on the tree new_tree.labeled.phy.
* tipdata.txt: the simulated sampling locations (using airports) for all tips in the simulated tree.
* tipdata.country.txt: the simulated sampling locations (using countries) for all tips in the simulated tree.
* simulated_seq_cds.fa: the simulated sequences cooresponding to all tips in the simulated tree.
* outgroup.fa: the (random) ancestral sequence used to simulate the sequences.
* simulated_seq_cds.labeled.phy: the phylogenetic tree inferred on the simulated sequences in simulated_seq_cds.fa and rooted using the outgroup.
* Reconstruction: subfolder containing all reconstructed phylogeographies using geographical and effective distances, airport and country resolutions, and either the inferred tree topology (simulated_seq_cds.labeled.phy) or the simulated tree topology (new_tree.labeled.phy, results denoted realtree).
* BEAST: subfolder containing the xml file used to start the analysis, the maximum clade credibility trees (output.tree and putput_asymmetric.tree), and the trees in Newick format with an annotation file stating the locations with the highest posterior probabilities.

## pH1N1
* pH1N1_until_20093004_cds.fa: HA sequences downloaded from Gisaid.
* pH1N1_until_20093004_cds_rooted.labeled.phy: phylogenetic tree inferred on the HA sequences.
* pH1N1_until_20093004_cds.map: table matching the ids in the tree to the sequence names in the fasta file.
* tipdata.txt: observed locations for all sequences.
* pH1N1_effective_dist.annotation.txt: phylogeographic spread inferred using effective distances.
* pH1N1_effective_dist.links.txt: counts of transmissions to new locations in the phylogeographic spread.
