################################
#Local Outlier Factor algorithm (LOF)
################################

Lof <- function(dataframe, variable, parameterK){
  dataframe$lofvalue <- round(lofactor(scale(dataframe[, variable], center = TRUE, scale = TRUE), parameterK),2)
  dataframe$ID <- as.character(dataframe$ID)
  return(as.data.frame(dataframe))
}

#PLOT THE DENSITY OF THE LOF SCORE
#-----------------------------------
LofPlot<-function(dataframe, z_score){  
  d <- density(dataframe[, "lofvalue"], na.rm = TRUE) #estimate density function
  plot(d, main="", lwd=1.5)
  polygon(d, col="lightgray", border="#00bdef")
  abline(v= z_score * sd(dataframe[dataframe$lofvalue < Inf , "lofvalue"], na.rm=TRUE) + mean(dataframe[dataframe$lofvalue < Inf , "lofvalue"], na.rm=TRUE),
         lwd=1, 
         col="#f7931d",
         lty="dashed")
  }

  

#SHOW DATA WITH THE HIGHEST LOF SCORE
#--------------------------------------
LofData <- function(dataframe, variable,  z_score){
  #compute Score
  dataframe$Score <- Inf
  dataframe[is.na(dataframe$lofvalue), "Score"] <- NA
  dataframe[dataframe$lofvalue < Inf & !is.na(dataframe$lofvalue), "Score"] <- round(scale(dataframe[dataframe$lofvalue < Inf & !is.na(dataframe$lofvalue) , "lofvalue"]) , 1) #compute the Z-score
  
  #Select row of interest
  dataframe <- dataframe[dataframe$Score >= z_score | dataframe$Score == Inf  , c("ID", variable, "Score")]  # most extreme
  dataframe[order(-dataframe$Score), ]  
}




