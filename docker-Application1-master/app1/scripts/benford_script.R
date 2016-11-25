
##################################
#Benford for data integrity check
##################################
#Has anyone manipulated the data?


#COMPUTE GOODNES OF FIT
################################
BenfordGoodnessTest <- function(dataframe, feature){
  
  string <- substr(as.character(dataframe[, feature]),1,1)
  
  first.digits <- as.integer(string)
  
  # In the event any of the 9 possible digits is not observed in the string, 
  # table(first.digits) will not display all digits 1, 2, ..., 9. An example is
  #
  # NAME     1  2  3  4  5  6  7  9
  # FREQ    12 11  9  8  6  5  4  2
  #
  # Here, obs <- as.integer(table(first.digits)) would only contain 8 elements.
  # To correct for this, initialize obs to a zero vector, loop through NAME, 
  # find FREQ corresponding to NAME,then paste that FREQ in obs[NAME].
  # This will also work for the case when all 9 possible digits are observed.
  
  Obs <- seq(from =0,to=0, length.out=9)
  
  for (i in as.numeric(names(table(first.digits))))  {
    pos <- which(as.numeric(names(table(first.digits)))==i)
    Obs[i]<- as.numeric(table(first.digits))[pos]
  }  
  i <- seq(1,9)
  
  Exp <- sum(Obs)*log10(1+1/i)  #Compute the theoritical value
  
  Digit <- seq(1,9)
  
  #print(info)
  
  chisq <- sum(((Obs-Exp)**2)/Exp)
  
  Exp <- round(Exp,3)
  info <- cbind(Digit,Obs,Exp)
  rownames(info)<-rep("",nrow(info))
  
  #print(chisq)
  
  p.value <- 1-pchisq(chisq,8)
  
  text.chi <- paste("Chi Square = ",format(round(chisq,3),nsmall=3),sep="")
  names(text.chi)<-""
  
  text.pval <- paste("P-Value = ",format(round(p.value,3),nsmall=3),sep="")
  names(text.pval)<-""
  
  print(info)
  print(text.chi,quote=F)
  print(text.pval,quote=F)
  
}



#PLOT PROPORTION OF FIRST DIGITS
#################################

BenfordPlotCompare<-function(dataframe, feature){
  
  string <- substr(as.character(dataframe[, feature]),1,1)
  
  first.digits <- as.integer(string)
  
  # In the event any of the 9 possible digits is not observed in the string, 
  # table(first.digits) will not display all digits 1, 2, ..., 9. An example is
  #
  # NAME     1  2  3  4  5  6  7  9
  # FREQ    12 11  9  8  6  5  4  2
  #
  # Here, obs <- as.integer(table(first.digits)) would only contain 8 elements.
  # To correct for this, initialize obs to a zero vector, loop through NAME, 
  # find FREQ corresponding to NAME,then paste that FREQ in obs[NAME].
  # This will also work for the case when all 9 possible digits are observed.
  
  Obs <- seq(from =0,to=0, length.out=9)
  
  for (i in as.numeric(names(table(first.digits))))  {  #same as taking i in (0:9)
    pos <- which(as.numeric(names(table(first.digits)))==i)
    Obs[i]<- as.numeric(table(first.digits))[pos]
  }  
  i <- seq(1,9)
  
  pmf.Exp <- cbind(seq(1,9)+0.065,log10(1+1/i))
  pmf.Obs <- cbind(seq(1,9)-0.065,Obs/sum(Obs))
  
  col1 <- brewer.pal(n = 8, name = "Blues")[7]
  col2 <- brewer.pal(n = 8, name = "Blues")[2]
  
  par(mar=c(3.5,4.5,2,0))
  
  my.lwd <- 3.75
  
  if (max(pmf.Obs[,2])>=max(pmf.Exp[,2])){
    plot(pmf.Obs[,1],pmf.Obs[,2],type="n",col=col1,xlim=c(0.75,9.25), xlab="",ylab="Proportion", xaxt="n", main="Proportion of First Digits")
    axis(1, at=seq(1,9), labels=c("1","2","3","4","5","6","7","8","9"))
    mtext("First Digit",1,line=2.5)
    for (i in 1:nrow(pmf.Obs)){
      lines(c(pmf.Obs[i,1],pmf.Obs[i,1]),c(0,pmf.Obs[i,2]),col=col1,lwd=my.lwd)
    }
    for (i in 1:nrow(pmf.Exp)){
      lines(c(pmf.Exp[i,1],pmf.Exp[i,1]),c(0,pmf.Exp[i,2]),col=col2,lwd=my.lwd)
      legend("topright", inset=.02,
             c("Observed Proportion","Benford's Law"), fill=c(col1,col2), horiz=F)
    }
  }
  
  if (max(pmf.Obs[,2])<max(pmf.Exp[,2])){
    plot(pmf.Exp[,1],pmf.Exp[,2],type="n",col=col2,xlim=c(0.75,9.25), xlab="", ylab="Proportion", xaxt="n", main="Proportion of First Digits")
    axis(1, at=seq(1,9), labels=c("1","2","3","4","5","6","7","8","9"))
    mtext("First Digit",1,line=2.5)
    for (i in 1:nrow(pmf.Obs)){
      lines(c(pmf.Exp[i,1],pmf.Exp[i,1]),c(0,pmf.Exp[i,2]),col=col2,lwd=my.lwd)
    }
    for (i in 1:nrow(pmf.Obs)){
      lines(c(pmf.Obs[i,1],pmf.Obs[i,1]),c(0,pmf.Obs[i,2]),col=col1,lwd=my.lwd)
    }
    legend("topright", inset=.02, 
           c("Observed Proportion","Benford's Law"), fill=c(col1,col2), horiz=F)
  }
}








