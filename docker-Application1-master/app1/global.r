
########################
# Load package
########################
library(shiny)
library(shinydashboard)

# For the plots
library(ggplot2)
library(RColorBrewer)

# For data transformation
library(data.table)

#For LOF
library(DMwR)

#Rules engine
#library(queryBuildR)

#Outliers detection
library(outliers)

#One class SVM
#library(e1071)

#Multivariate Prediction
library(caret)
library(lars)

#Descriptive tatistic
#library(Hmisc) pour la function describe

#Check data & Rules engine
library(editrules)
#library(datacheck)

# Load the kohonen package for Self-Organising Maps
library(kohonen)

#Library for Density-Based Clustering
library(dbscan)

#Angle-based outlier detection (ABOD) algorithm
#library(HighDimOut) #Too slow, but could be parallized
library(abodOutlier)

########################
# Load source file
########################


#run data_cleaning
source("./scripts/data_cleaning.R")

#run rules_engines
source("./scripts/rules_engine_script.R")

#run benford_script
source("./scripts/benford_script.R")


#run control_script
source("./scripts/statistical_script.R")

#run 
source("./scripts/abod_script.R")


#run lof_script
source("./scripts/lof_script.R")

#run one class support vector machine
source("./scripts/oneclassSVM_script.R")

#run optic_script
source("./scripts/optic_script.R")


#run Self-Organizing Map
source("./scripts/som_script.R")


#run score
#source("./scripts/score_script.R")






