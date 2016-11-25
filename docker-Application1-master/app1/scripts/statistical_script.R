
######################
#STATISTICAL APPROCH
#####################
#CHEKC Package 'outliers'


#UNIVARIATE APPROACH
#-------------------------
###SHOULD ADAPTE DENSITY TO ALLOW FOR TRUNCATED DENSITY FUCNTION WITH OPTION FROM / TO -> see ?density

UniPlot <- function(dataframe, feature, z_score){
  d <- density(dataframe[ , feature],na.rm = TRUE) #estimate density function
  plot(d, main="", lwd=1.5)
  polygon(d, col="lightgray", border="#00bdef")
  abline(v= z_score * sd(dataframe[ , feature], na.rm=TRUE) + mean(dataframe[ , feature], na.rm=TRUE), lwd=1,  col="#f7931d",lty="dashed")
}


UniTable <- function(dataframe, feature, z_score){
  dataframe$Score <- round(scale(dataframe[,feature], center = TRUE, scale = TRUE), 1) #compute the Z-score
  dataframe <- dataframe[dataframe$Score >= z_score, c("ID", feature, "Score")]  # most extreme
  dataframe[order(-dataframe$Score), ]
}


#MULTIVARIATE APPROACH
#------------------------

FeaturePlot <- function(dataframe,dependent, explicative){
  #Draw smooth univariate regression
  featurePlot(x = dataframe[ ,explicative],
              y = dataframe[ ,dependent],
              plot = "scatter",
              type = c("p","r"),  #"point and line
              col= "#00bdef",
              pch = 16,
              alpha = 0.3
             # cex = 0.2
  )
}


#ELASTIC NET
#...............

Elasticnet <- function(dataframe,dependent, explicative){
                
    #Elestic Net (Mix between Ridge and lasso)
    ctrl <- trainControl(method = 'cv', number = 10)
    enetGrid <- expand.grid(.lambda = c(0,0.01,0.1),
                            .fraction = seq(0.05,1, length = 20)
                            )
    
    model <- train(x = dataframe[ , explicative],
                   y = dataframe[ , dependent],
                   form = dependent ~ . + rm:dependent,
                       data = dataframe,
                       method = "enet",
                       tuneGrid = enetGrid,
                       tr.Control = ctrl,
                       na.action = na.omit, 
                       preProc = c("center","scale")
                       )
    
   dataframe$prediction <- predict(model, dataframe[ , explicative])
   dataframe$error <- dataframe[, dependent] - dataframe[, "prediction"] 
   dataframe$Score <- round(scores(dataframe[ , "error"], type="chisq") , 1) #compute the Z-score
   dataframe$ID <- as.character(dataframe$ID)
   return(dataframe)
} 
 
#Plot predicted value  versus residuals
ElasticnetPlot <- function(dataframe,dependent, limit){
    plot(dataframe[, dependent], dataframe[, "Score"], pch=16, col="#00bdef", cex=0.8, xlab=dependent, ylab= "Score")
    abline(h = limit,lty =2, col="#f7931d") 
    text(x=dataframe[, dependent], y=dataframe[, "Score"], labels=ifelse(dataframe[, "Score"] > limit , dataframe[,"ID"],""),lty="dashed", col="#f7931d")
}


ElasticnetTable <- function(dataframe,dependent, explicative, limit){
  dataframe <- dataframe[dataframe$Score > limit,c("ID",dependent, explicative, "Score")]
  dataframe[order(-dataframe$Score), ]
}

#COOK's DISTANCE
#...............
#Best: http://r-statistics.co/Outlier-Treatment-With-R.html#outliers%20package
#Cook's distance is a measure computed with respect to a given regression model and therefore is impacted only by the X variables included in the model. But, what does cook's distance mean? It computes the influence exerted by each data point (row) on the predicted outcome.

Cook <- function(dataframe,dependent, explicative){
  temp_x <- dataframe[ , explicative]
  temp_y <- dataframe[ , dependent]
  temp <- as.data.frame(cbind(temp_y, temp_x))  
  model <- lm(formula = temp_y ~ .  , data=temp) #Technically, . means all variables not already mentioned in the formula. For example
  temp$cookdistance <- round(cooks.distance(model), 2)
  temp$ID <- as.character(dataframe$ID)
  colnames(temp) <- c(dependent,explicative, "cookdistance", "ID")
  dataframe <- temp[, c("ID", dependent, explicative, "cookdistance" ) ]
  return(dataframe)
}
  

CookMultiPlot <- function(dataframe,dependent, param){
    plot(x= dataframe[, dependent], y= dataframe[, "cookdistance"], pch=20, col="#00bdef", cex=0.8, main="",  xlab=dependent, ylab= "Cook's distance") +  # plot cook's distance
    abline(h = param*mean(dataframe[,"cookdistance"], na.rm=T), col="#f7931d", lty =2) +  # add cutoff line
    text(x=dataframe[, dependent], 
         y=dataframe[, "cookdistance"], 
         labels=ifelse(dataframe[, "cookdistance"] > param*mean(dataframe[,"cookdistance"], na.rm=T),dataframe[, "ID"],""),
         lty="dashed", 
         col="#f7931d")  # add labels
}

CookMultiTable <- function(dataframe, param){
  #Get the list of influential individuals
  dataframe[dataframe$cookdistance > param * mean(dataframe[,"cookdistance"], na.rm=T), ]  # influential observations.
  dataframe[order(-dataframe$cookdistance), ] 
}

  
