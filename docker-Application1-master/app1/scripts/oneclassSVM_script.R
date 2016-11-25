##################################
# APLLY ONE_CLASS SVM
##################################

OneClassSVMTable <- function(dataframe, dependent, explicative){

  temp_x <- dataframe[ , explicative]
  temp_y <- dataframe[ , dependent]

model <- svm(temp_x, temp_y,type='one-classification') #train an one-classification model 

# test on the whole set
pred <- predict(model) #create predictions

dataframe[!pred, ] # print rows with predicted value FALSE which mean that they do not belongs to the group
}