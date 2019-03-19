#!/usr/bin/env Rscript

# This script takes the tree simulated by FAVITES, the list of transmissions as well as the metadata of the GLEAMviz simulation and labels the internal nodes of the tree.

library("ape")

get_transmission_path <- function(destination, transmission_list){
  # remove first line (origin)
  transmission_list <- transmission_list[2:nrow(transmission_list),]
  
  # initialize integer vector to save ids of nodes in this path
  path <- integer();
  
  stop <- 0;
  id <- destination;
  
  # set first location
  path <- c(id, path);
  
  while(stop == 0) {
    # look for incoming edges
    position <- which(transmission_list$V2 == id);
    # if no incoming edge: current node is the root (leave the while loop)
    if (length(position) == 0) {
      stop <- 1;
    }
    # if there is an incoming edge: get id of next node
    id <- transmission_list[position, 1];
    # add location and id
    path <- c(id, path);
  }
  return(path)
}

# read data

args = commandArgs(trailingOnly=TRUE)

tree = args[1]
transmissions = args[2]
metadata = args[3]
output = args[4]

sim_tree <- read.tree(tree)
transmission_list <- read.table(transmissions, sep = "\t", quote="", stringsAsFactors = FALSE)
meta <- read.table(metadata, sep = "\t", quote="", stringsAsFactors = FALSE)

# do a postorder traversal of the tree
sim_tree <- reorder(sim_tree,"postorder")

# get the sequence ids created by FAVITES
label <- sim_tree$tip.label
label_split <- t(matrix(unlist(strsplit(label, "|", fixed=TRUE)),nrow=3))
#second column of sequence ids contains location id
location <- vector(mode = "character", length = (Ntip(sim_tree) + sim_tree$Nnode))
location[1:Ntip(sim_tree)] <- label_split[,2]

# internal nodes to traverse
int_nodes <- unique(sim_tree$edge[,1])

# traverse tree and get locations for internal nodes
for (current_node in int_nodes) {
  # list of child nodes for current internal node
  child_nodes <- sim_tree$edge[sim_tree$edge[,1]==current_node,2]
  
  current_destinations <- location[child_nodes]
  
  # get paths from these destinations to the origin
  path1 <- get_transmission_path(current_destinations[1], transmission_list)
  path2 <- get_transmission_path(current_destinations[2], transmission_list)
  
  result <- c()
  # get overlap of these paths and then get the latest location
  for (i in 1:min(length(path1), length(path2))){
    if (path1[i] == path2[i]){
      result <- path1[i]
      next
    } else {
      break
    }
  }
  
  location[current_node] <- result
}

# create annotation for evaluation and visualization
new_labels <- paste("intNode", seq(1, sim_tree$Nnode), sep="")
sim_tree$node.labels <- new_labels

location_airports <- vector(mode = "character", length = length(location))
location_countries <- vector(mode = "character", length = length(location))
location_countries_id <- vector(mode = "character", length = length(location))
for (i in 1:length(location)){
  location_airports[i] <- meta$V3[which(meta$V1 == location[i])]
  location_countries[i] <- meta$V5[which(meta$V1 == location[i])]
  location_countries_id[i] <- meta$V11[which(meta$V1 == location[i])]
}

annotation <- data.frame(label = c(sim_tree$tip.label, sim_tree$node.label), location = location_airports)
annotation_country <- data.frame(label = c(sim_tree$tip.label, sim_tree$node.label), location = location_countries_id)

# save tree and annotation for all nodes
write.tree(sim_tree, paste(output, "/new_tree.labeled.phy", sep = ""))
write.tree(sim_tree, paste(output, "/new_tree.labeled.country.phy", sep = ""))
write.table(annotation, paste(output, "/new_tree.labeled.annotation.txt", sep = ""), sep="\t", row.names=FALSE, quote=FALSE)
write.table(annotation_country, paste(output, "/new_tree.labeled.country.annotation.txt", sep = ""), sep="\t", row.names=FALSE, quote=FALSE)

# save only annotation for the tips to do the reconstruction
annotation_small <- annotation[1:Ntip(sim_tree),]
write.table(annotation_small, paste(output, "/tipdata.txt", sep = ""), sep="\t", row.names=FALSE, quote=FALSE)

annotation_country_small <- annotation_country[1:Ntip(sim_tree),]
write.table(annotation_country_small, paste(output, "/tipdata.country.txt", sep = ""), sep="\t", row.names=FALSE, quote=FALSE)
