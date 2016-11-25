#########################
# DATA QUALITY
#########################

BusinessRulesSummary<- function(dataframe,violated_rules, nbretoshow){
  violated_rules <-  as.data.frame(violated_rules)
  violated_rules$nbreofviolation <- rowSums(violated_rules)
  result <- cbind(dataframe[,1], violated_rules, dataframe[,"fraud_label"])
  result <- result[result$nbreofviolation > 0, ]
  result <- result[order(-result$nbreofviolation),]
  result <- result[1:nbretoshow,]
  return(result)
}

#########################
# OUTLIERS
#########################
Multivariate_Score <- function(elasticnet){
 MultivariateTest <- as.data.frame(round(scale(elasticnet$Score) , 1) )
    return(MultivariateTest)
}


COOK_Score <- function(cook){
  cook$score <- Inf
  cook[is.na(cook$cookdistance), "score"] <- NA 
  cook[cook$cookdistance != Inf & !is.na(cook$cookdistance), "score"] <- round(scale(cook[cook$cookdistance != Inf & !is.na(cook$cookdistance) , "cookdistance"]) , 1) 
  CookTest <- as.data.frame(cook$score)
  return(CookTest)
}

#ABOD_Score <- function(abod){
#  ABODTest <- round( , 1) 
#  return(ABODTest)
#}

LOF_Score <- function(lof){
  lof$score <- Inf
  lof[is.na(lof$lofvalue), "score"] <- NA 
  lof[lof$lofvalue != Inf & !is.na(lof$lofvalue), "score"] <- round(scale(lof[lof$lofvalue != Inf & !is.na(lof$lofvalue) , "lofvalue"]) , 1) 
  LOFTest <- as.data.frame(lof$score)
  return(LOFTest)
}


OPTIC_Score <- function(optic){
  optic <- as.data.frame(optic$reachdist)
  optic$score <- Inf
  colnames(optic) <- c("reachdist", "score")
  optic[is.na(optic$reachdist), "score"] <- NA 
  optic[optic$reachdist != Inf & !is.na(optic$reachdist), "score"] <- round(scale(optic[optic$reachdist != Inf & !is.na(optic$reachdist) , "reachdist"]) , 1) 
  OPTICTest <- as.data.frame(optic$score)
  return(OPTICTest)
}


OutlierSummary <- function(dataframe, elasticnet, lof, cook, optic, nbretoshow ){
  multivariate_score <- Multivariate_Score(elasticnet)
  lof_score   <- LOF_Score(lof)
  cook_score <- COOK_Score(cook) 
  optic_score <- OPTIC_Score(optic)

  dataframe <- cbind(dataframe[,1],multivariate_score, lof_score, cook_score, optic_score)
  colnames(dataframe) <- c("ID", "Multivariate_Score", "Loft_score", "Cook_score", "Optic_score")
  
  dataframe$MaxScore <- pmax(dataframe$Multivariate_Score, dataframe$Loft_score, dataframe$Cook_score, dataframe$Optic_sc, na.rm = TRUE)
  dataframe <-  dataframe[order(-dataframe$MaxScore), ]
  return(dataframe[1:nbretoshow, c("ID", "Multivariate_Score","Loft_score", "Cook_score","Optic_score", "MaxScore")])
}



#DOIT RAJOUTER UN IF EXIST!!!!
#ATTENTION is.infinite!!!!!

#  if(number<1|is.na(number)|is.nan(number)|is.infinite(number)){
#    result <- 0


################################
# PATTERN
################################
SomSummary <- function(dataframe, model, variable, nodeid, nbretoshow){
  
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
  return(dataframe[1:nbretoshow, ])
}


