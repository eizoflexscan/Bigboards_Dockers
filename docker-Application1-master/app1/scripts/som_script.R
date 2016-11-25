
######################
#Self-Organising Maps
#####################

Kohonen <- function(dataframe,variable, dimX, dimY){
  
  # Create a training data set (rows are samples, columns are variables
  # Here I am selecting a subset of my variables available in "data"
  temp <- dataframe[, variable]
  
  # Change the data frame with training data to a matrix
  # Also center and scale all variables to give them equal importance during
  # the SOM training process. 
  temp <- as.matrix(scale(temp))
  
  # Create the SOM Grid - you generally have to specify the size of the 
  # training grid prior to training the SOM. Hexagonal and Circular 
  # topologies are possible
  som_grid <- somgrid(xdim = dimX, ydim=dimY, topo="hexagonal")
  
  # Finally, train the SOM, options for the number of iterations,
  # the learning rates, and the neighbourhood are available
  som_model <- som(temp, 
                   grid=som_grid, 
                   #rlen=100, 
                   #alpha=c(0.05,0.01), 
                   keep.data = TRUE,
                   n.hood="circular")
  
   return(som_model)
} 
 

#################
# MODEL TUNING
#################

#Training Progress:
#------------------

#As the SOM training iterations progress, the distance from each node's weights to the samples 
#represented by that node is reduced. Ideally, this distance should reach a minimum plateau. 
#This plot option shows the progress over time. If the curve is continually decreasing, more iterations are required.

TrainingProgressPlot <- function(model){
plot(model, type="changes", main="")  
}

#Node Counts
#-----------
#The Kohonen packages allows us to visualise the count of how many samples are mapped to each node on the map. This metric can be used as a measure of map quality - ideally the sample distribution is relatively uniform. Large values in some map areas suggests that a larger map would be benificial. Empty nodes indicate that your map size is too big for the number of samples. Aim for at least 5-10 samples per node when choosing map size.
NodeCountPlot <- function(model){
  plot(model, type="count")
}

 

###############################
# DEFINE THE NUMBER OF CLUSTER
###############################


#Find the number of cluser
#---------------------------
#The mean values and distributions of the training variables within each cluster are used to build a meaningful picture of the cluster characteristics. 
NbreClusterPlot <- function(model,dimX, dimY ){
  maxcluster <- (dimX * dimY) - 1
  mydata <- model$codes 
  wss <- (nrow(mydata)-1)*sum(apply(mydata,2,var)) 
  for (i in 2:maxcluster) {
    wss[i] <- sum(kmeans(mydata, centers=i)$withinss)
  }
  plot(wss)
}


#Neighbour Distance
#------------------
#Often referred to as the "U-Matrix", this visualisation is of the distance between each node and its neighbours. Typically viewed with a grayscale palette, areas of low neighbour distance indicate groups of nodes that are similar. Areas with large distances indicate the nodes are much more dissimilar - and indicate natural boundaries between node clusters. The U-Matrix can be used to identify clusters within the SOM map.
#U-matrix visualisation
U_matrixPlot <- function(model, nbreclusters){
  
  ## use hierarchical clustering to cluster the codebook vectors
  som_cluster <- cutree(hclust(dist(model$codes)), nbreclusters)
  plot(model, type="dist.neighbours", main="")
  add.cluster.boundaries(model, som_cluster)
}



#########################
# EXPLORATION 
#########################

#Heatmaps
#-----------
#Heatmaps are perhaps the most important visualisation possible for Self-Organising Maps. The use of a weight space view as in (4) that tries to view all dimensions on the one diagram is unsuitable for a high-dimensional (>7 variable) SOM. A SOM heatmap allows the visualisation of the distribution of a single variable across the map. Typically, a SOM investigative process involves the creation of multiple heatmaps, and then the comparison of these heatmaps to identify interesting areas on the map. It is important to remember that the individual sample positions do not move from one visualisation to another, the map is simply coloured by different variables.
#The default Kohonen heatmap is created by using the type "heatmap", and then providing one of the variables from the set of node weights. In this case we visualise the average education level on the SOM.
#Kohonen Heatmap creation

HeatmapPlot <- function(model, nbreclusters, feature){
  som_cluster <- cutree(hclust(dist(model$codes)), nbreclusters)
  plot(model, type = "property", property = model$codes[,feature])
  add.cluster.boundaries(model, som_cluster)
}


##################
#Print result
##################


# THE SUSPICIOUS NODE
SomTable1 <- function(dataframe, model, variable, nodeid){
  
  #Create a dataframe with original data and the node they belongs to (i.e. their unit)
  som_result <- as.data.frame(cbind(model$unit.classif, model$distances))
  colnames(som_result) <- c("node", "distance")
  
  dataframe <-  as.data.frame(cbind(dataframe,som_result))
  #Add the cluster
  #som_cluster <- as.data.frame(som_cluster)
  #som_cluster$nodes=as.numeric(row.names(som_cluster))
  #som_result <- merge(som_result, som_cluster, by.x="V5", by.y="nodes")
  dataframe <- dataframe[dataframe$node == nodeid, ]
  
  dataframe$Score <- round(scale(dataframe$distance) , 1) #compute the Z-score
  dataframe <- dataframe[, c("ID", variable, "Score")]  # most extreme
  dataframe[order(-dataframe$Score), ]
}


#THE FAREST DATA POINT
SomTable2 <- function(dataframe, model, variable, z_score){
  
  #Create a dataframe with original data and the node they belongs to (i.e. their unit)
  som_result <- as.data.frame(cbind(model$data, model$unit.classif, model$distances))
  colnames(som_result) <- c(variable, "node", "distance")
  
  dataframe$Score <- round(scale(som_result$distance) , 1) #compute the Z-score
  dataframe <- dataframe[dataframe$Score >= z_score, c("ID", variable, "Score")]  # most extreme
  dataframe[order(-dataframe$Score), ]
}
