#!/usr/bin/env Rscript

# This script takes a phylogenetic tree, locations for the tips as well as a cost matrix with distances between all possible locations.
# The Sankoff algorithm is used to perform a parsimonious ancestral state reconstruction to infer locations for internal nodes.

### define functions

# implementation of the sankoff algorithm
reconstruct_sankoff <- function(phylo, cost, isolate_matrix){
  
  # reformat isolate matrix to make id to row names
  isolate_matrix <- unstack(isolate_matrix, form=location~label)
  
  n_tips <- Ntip(phylo)
  n_nodes <- phylo$Nnode
  n <- n_tips + n_nodes
  
  # values represent minimal cost in subtree starting at a specific node, given that it is assigned a specific state
  # rows: nodes, columns: states
  values <- matrix(data = NA, nrow = n, ncol = nrow(cost))
  colnames(values) <- colnames(cost)
  
  # initialize values for leaf nodes (0 for observed state, otherwise infinity)
  for (i in 1:n_tips) {
    values[i,] <- Inf
    values[i, isolate_matrix[phylo$tip.label[i],]] <- 0
  }
  
  # for all other nodes: postorder traversal
  phylo <- reorder(phylo,"postorder")
  # internal nodes to traverse
  int_nodes <- unique(phylo$edge[,1])
  
  # calculate values for all internal nodes
  for (current_node in int_nodes) {
    # list of child nodes for current internal node
    child_nodes <- phylo$edge[phylo$edge[,1]==current_node,2]
    
    # get minimal costs for each possible state
    for (loc in colnames(values)) {
      sum_childs <- 0
      # sum over all child nodes
      for (child in child_nodes){
        sum_childs <- sum_childs + min(cost[loc,] + values[child,])
      }
      values[current_node, loc] <- sum_childs
    }
  }
  
  # reverse traversal to assign states
  states <- character(length = n)
  states[1:n_tips] <- isolate_matrix[,1]
  int_nodes <- rev(int_nodes)
  
  # state at root node is the one with the minimum cost
  root_options <- names(which(values[int_nodes[1],] == min(values[int_nodes[1],])))
  states[int_nodes[1]] <- root_options[1] # if more than one option, take first one
  
  # determine all other states
  for (current_node in int_nodes[2:length(int_nodes)]) {
    # get parent node
    parent <- states[phylo$edge[which(phylo$edge[,2] == current_node),][1]]
    # add minimum cost at current node with the cost of traveling from parent to child
    current_costs <- cost[parent,] + values[current_node,]
    # possible states
    options <- names(which(current_costs == min(current_costs)))
    
    if (length(options) == 1){
      # state is the one that minimizes these values
      states[current_node] <- options
    } else {
      if (parent %in% options){
        # delayed transformation: take same location as the parent to delay changes
        states[current_node] <- parent
      } else {
        # if there is still more than one possibility: take first one
        states[current_node] <- options[1]
      }
    }
  }
  
  # add internal node IDs
  node_label <- paste("intNode", seq(1, n_nodes), sep="")
  phylo$node.label <- node_label
  
  # create annotation
  node_annotation <- data.frame(label=c(rownames(isolate_matrix), node_label), location=states)
  
  return(list(tree=phylo, annotation=node_annotation))
}

# function to write tree and annotation
save_tree <- function(result, filename){
  write.tree(result$tree, paste(filename,".phy", sep=""))
  # write.tree replaces spaces in sequence names by underscores - do the same with annotation file
  result$annotation$label <- gsub(" ", "_", result$annotation$label)
  write.table(result$annotation, paste(filename, ".annotation.txt", sep=""), quote=FALSE, row.names=FALSE, sep="\t")
}


### load required packages

library("ape")      # package for phylogenetic trees

### define input data

args = commandArgs(trailingOnly=TRUE)
tree <- args[1]
tip_locations <- args[2]
dist_matrix <- args[3]
output <- args[4]

### read data

phylo <- read.tree(tree)
isolate_matrix <- read.table(tip_locations, header = T, sep="\t", stringsAsFactors=FALSE, na.strings = "")
cost <- as.matrix(read.csv(dist_matrix, header = TRUE, row.names = 1, check.names=FALSE, na.strings = ""))
colnames(cost)[which(is.na(colnames(cost)))] <- "NA"

# check if all locations in isolate_matrix are in cost matrix
if (!all(unique(isolate_matrix$location) %in% rownames(cost))){
  stop("One or more locations in the tips are not in the distance matrix. Check your input.")
}

### ancestral reconstruction of locations
phylo_reconstructed <- reconstruct_sankoff(phylo, cost, isolate_matrix)

### save new tree and reconstructed locations
save_tree(phylo_reconstructed, output)
