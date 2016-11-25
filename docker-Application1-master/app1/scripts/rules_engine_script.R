
#############################################
#- Define rules
#- Verify data against them
#- Localize errors
###############################################
#The editrules package aims to provide an environment to conveniently define, read and check
#recordwise data constraints including
# . Linear (in)equality constraints for numerical data,
# . Constraints on value combinations of categorical data
# . Conditional constraints on numerical and/or mixed data




#PRINT RULES
#-----------
BusinessRules <- function(updated_rule){
  blocks(updated_rule)
}


#PLOT RULES VIOLATION SUMMARY
#-----------------------------
BusinessRulesViolationSummary <- function(violated_rules){
  plot(violated_rules, col = "#00bdef")
}


#PLOT THE RULES RELATIONS AS A GRAPH
#-------------------------------------
BusinessRulesNetwork <- function(updated_rule,violated_rules){
  
  plot(updated_rule, 
       nodetype = "all", 
       violated = violated_rules,
       edge.curved=TRUE,
       rules = editnames(updated_rule),
       vars = getVars(updated_rule),
       nabbreviate = 10,
       layout = igraph::layout.fruchterman.reingold, 
       edgecolor = "#454545",
       rulecolor = "#91c542", 
       varcolor = "#00bdef",
       violatedcolor = "#f7931d"
  )
}


#PRINT RECORDS WITH VIOLATED RULES
#----------------------------------
BusinessRulesViolationObservation <- function(dataframe,violated_rules){
  violated_rules <-  as.data.frame(violated_rules)
  violated_rules$nbreofviolation <- rowSums(violated_rules)
  result <- cbind(dataframe[,1], violated_rules, dataframe[,"fraud_label"])
  result <- result[result$nbreofviolation > 0, ]
  result <- result[order(-result$nbreofviolation),]
  return(result)
}
