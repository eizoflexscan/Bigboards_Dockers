######################
#DATA CLEANING
######################
# data cleaning script, taking user-data.frame and transform it so that it can be used by the applciation


CleanUp <- function(dataframe){
  
    #Remove special character from column names
    colnames(dataframe) <- gsub("[[:punct:]]", "", colnames(dataframe))
    
    #Converte ID to Character variable
    dataframe[,1] <- as.character(dataframe[, 1])
    
    #Getting time variable in the right format
    for (i in 2:ncol(dataframe)) {
      if(grepl("^[0-9]{4}\\[0-9]{2}\\[0-9]{2}", dataframe[2,i], ignore.case = TRUE)==TRUE){
        dataframe[,i] <- as.Date(as.character(dataframe[,1]), format = "%Y/%m/%d")
      }
    }
    
    #Getting categorical data into shape
    for (i in 2:ncol(dataframe)) {
      if(is.character(dataframe[,i])==TRUE){
        #Removing special character
       dataframe[,i] <- gsub("[[:punct:]]", "", dataframe[,i])     
        #Convert to factor
        dataframe[,i] <- as.factor(dataframe[,i])
      }
    }

}
  
  

######################
#DATA PREPROCESSING
######################



######################
#HAVE A LOOK AT RESULT
######################

#print variable by type
DataType <- function(dataframe){
  Variables <- NA
  Variables[1] <- (paste(colnames((dataframe[1])), " : an ID", sep="  "))
  for (i in 2:ncol(dataframe)) {
    if(is.numeric(dataframe[,i])==TRUE){
      Variables[i]<- (paste(colnames((dataframe[i])), " : a Numerical feature", sep="  "))
    } else if (is.factor(dataframe[,i])==TRUE){
      Variables[i]<- (paste(colnames((dataframe[i])), " : a Categorical feature", sep="  "))
    } else {Variables[i] <- (paste(colnames((dataframe[i])), " : a Date feature", sep="  "))} 
  }
  return(as.data.frame(Variables))
}


#Print summary
DataSummary <- function(dataframe){
  variablesummary <- as.data.frame(t(summary(dataframe))[-1 , c(1,4,6)])
  colnames(variablesummary) <- c("Min", "Mean", "Max")
return(variablesummary)
}

#Print Nearzero variable
NearZeroVar<- function(dataframe){
  dataframe$ID <- NULL 
  isnzv <-  nearZeroVar(dataframe, saveMetrics= FALSE)
  NearZeroVariance <- as.data.frame(names(dataframe)[isnzv])
return(NearZeroVariance)
}

#print sample
SampleTable <- function(dataframe, variable, nrow){
  dataframe[1:nrow, variable]
}


