################################
#Ordering points to identify the clustering structure (OPTIC)
################################


#COMPUTE OPTIC
#-------------
Optic <- function(dataframe, variable, parameterReachability, parameterminPts, parameterIntraReachability){
  optic_result <- optics(as.matrix(scale(dataframe[,variable])), 
                         eps = parameterReachability, 
                         minPts = parameterminPts, 
                         eps_cl = parameterIntraReachability
                         )
  return(optic_result)
}


#PLOT THE DENSITY OF THE optic SCORE
#-----------------------------------
OpticPlot<-function(optic_result, z_score){
  temp <- optic_result$reachdist < Inf
  reachdist <- optic_result$reachdist[temp]
  d <- density(reachdist, na.rm = TRUE) #estimate density function
  plot(d, main="", lwd=1.5)
  polygon(d, col="lightgray", border="#00bdef")
  abline(v= z_score * sd(reachdist, na.rm=TRUE) + mean(reachdist, na.rm=TRUE),
         lwd=1, 
         col="#f7931d",
         lty="dashed")
}



#SHOW DATA WITH THE HIGHEST optic SCORE
#--------------------------------------
OpticTable <- function(dataframe, variable, z_score, optic_result){
  
  #extra the reachability distance
  dataframe$reachdist <- optic_result$reachdist
  
  #compute Score
  dataframe$Score <- Inf
  dataframe[is.na(dataframe$reachdist), "Score"] <- NA
  dataframe[dataframe$reachdist < Inf & !is.na(dataframe$reachdist), "Score"] <- round(scale(dataframe[dataframe$reachdist < Inf & !is.na(dataframe$reachdist) , "reachdist"]) , 1) #compute the Z-score
  
  #Select row of interest
  dataframe <- dataframe[dataframe$Score >= z_score | dataframe$Score == Inf  , c("ID", variable, "Score")]  # most extreme
  dataframe[order(-dataframe$Score), ]  
}







