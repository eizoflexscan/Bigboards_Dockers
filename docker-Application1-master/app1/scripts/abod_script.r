#Angle-based outlier degree
#-------------------------

Abod_global <- function(dataframe,variables, percentage){
  abod_resultat <- abod(data=dataframe[, variables], method="randomized", n_sample_size = trunc(nrow(data) * percentage) )
  return(abod_resultat)
}


Abod_local <- function(dataframe,variables, neighbour){
  abod_resultat <- abod(data=dataframe[, variables], method="randomized", k = neighbour )
  return(abod_resultat)
}



AbodPlot <- function(abodvalue, z_score){
  d <- density(abodvalue,na.rm = TRUE) #estimate density function
  plot(d, main="", lwd=1.5)
  polygon(d, col="lightgray", border="#00bdef")
  abline(v= z_score * sd(abodvalue) + mean(abodvalue), lwd=1,  col="#f7931d",lty="dashed")
}


AbodTable <- function(dataframe, variables, z_score, abodvalue){
  
  #extra the distance
  dataframe$abodvalue <- abodvalue
  
  #compute Score
  dataframe$Score <- Inf
  dataframe[is.na(dataframe$abodvalue), "Score"] <- NA
  dataframe[dataframe$abodvalue < Inf & !is.na(dataframe$abodvalue), "Score"] <- round(scale(dataframe[dataframe$abodvalue < Inf & !is.na(dataframe$abodvalue) , "abodvalue"]) , 1) #compute the Z-score
  
  #Select row of interest
  dataframe <- dataframe[dataframe$Score >= z_score | dataframe$Score == Inf  , c("ID", variables, "Score")]  # most extreme
  dataframe[order(-dataframe$Score), ]  
}


