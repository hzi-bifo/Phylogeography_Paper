#!/usr/bin/env Rscript

# This script transforms the seedings file from a GleamViz simulation (containing transmissions) into a transmission file that can be read by the FAVITES pipeline.
# Necessary arguments are the path to seedings file and the desired number of transmissions.

args = commandArgs(trailingOnly=TRUE)
movementfile <- args[1]
num_events <- args[2]

# read gleamviz data
movements <- read.table(movementfile)

# initialize new transmission file
transmission_file <- data.frame(origin=integer(), destination=integer(), time=integer(), stringsAsFactors=FALSE)

# initialize origin
transmission_file <- rbind(transmission_file, data.frame(origin="None", destination=movements$V2[1], time=0, stringsAsFactors=FALSE))

# keep track of possible origins
origins <- c(movements$V2[1])

# loop over rest of movements to generate transmissions
for (i in 1:nrow(movements)){
#for (i in 1:10){
  # check if origin was already infected
  if (movements$V2[i] %in% origins){
    # add next destination to possible origins
    origins <- c(origins, movements$V3[i])
  } else {
    next
  }
  
  # add info to transmission file
  transmission_file <- rbind(transmission_file, data.frame(origin=movements$V2[i], destination=movements$V3[i], time=movements$V1[i], stringsAsFactors=FALSE))
}

# remove duplicates (only happen when a location has two different origins on the same day)
transmission_file <- transmission_file[which(!duplicated(transmission_file$destination)),]

# get the desired subset of the data (a specific number of movements)
transmission_file <- transmission_file[1:num_events,]

# create contact network
n <- nrow(transmission_file)

locations <- unique(c(transmission_file$origin[2:n], transmission_file$destination))
contact_file_nodes <- data.frame(name=rep("NODE", length(locations)), node=locations, info=rep(".", length(locations)), stringsAsFactors=FALSE)
contact_file_edges <- data.frame(name=rep("EDGE", n-1), origin= transmission_file$origin[2:n], destination=transmission_file$destination[2:n], info=rep(".", n-1), directed=rep("d", n-1), stringsAsFactors=FALSE)

# save new files
write.table(transmission_file, "FAVITES_input/favites_transmissions.txt", row.names=FALSE, col.names=FALSE, quote=FALSE, sep="\t")
write.table(contact_file_nodes, "FAVITES_input/tmp_contacts_1.txt", row.names=FALSE, col.names=FALSE, quote=FALSE, sep="\t")
write.table(contact_file_edges, "FAVITES_input/tmp_contacts_2.txt", row.names=FALSE, col.names=FALSE, quote=FALSE, sep="\t")
