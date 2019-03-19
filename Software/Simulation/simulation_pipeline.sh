#!/bin/bash

# gleamviz output files
transmissions=$1
metadata=$2
# path to favites and config file
favites_docker_path=$3
config=$4
# folder for the output of the simulation
output_folder=$5

num_transmissions=200

# prepare favites input
mkdir -p FAVITES_input
Rscript create_favites_input.R $transmissions $num_transmissions
cat FAVITES_input/tmp_contacts_1.txt FAVITES_input/tmp_contacts_2.txt > FAVITES_input/favites_contacts.txt
rm FAVITES_input/tmp_contacts_1.txt FAVITES_input/tmp_contacts_2.txt

# run favites
$favites_docker_path -c $config

# unzip all necessary files
gunzip FAVITES_output/error_free_files/sequence_data.fasta.gz
gunzip FAVITES_output/error_free_files/transmission_network.txt.gz
gunzip FAVITES_output/error_free_files/phylogenetic_trees/tree_0.tre.gz
gunzip FAVITES_output/error_free_files/phylogenetic_trees/tree_0.time.tre.gz
gunzip FAVITES_output/seed_sequences.tsv.gz

# label internal nodes of the simulated tree
mkdir -p $output_folder
Rscript label_internal_nodes.R FAVITES_output/error_free_files/phylogenetic_trees/tree_0.tre FAVITES_output/error_free_files/transmission_network.txt $metadata $output_folder

cp FAVITES_output/error_free_files/sequence_data.fasta $output_folder"/simulated_seq_cds.fa"

head -n 1 FAVITES_output/seed_sequences.tsv | awk '{print ">" $1}' > $output_folder"/outgroup.fa"
head -n 1 FAVITES_output/seed_sequences.tsv | awk '{print $2}' >> $output_folder"/outgroup.fa"
