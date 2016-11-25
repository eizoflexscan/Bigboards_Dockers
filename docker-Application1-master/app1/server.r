source("global.r",local =TRUE, verbose = TRUE)

#INCREASE THE MAXIMAM UPLOAD SIZE OF A USER FILE
#-----------------------------------------------
#increase from 5mb to 50MB
options(shiny.maxRequestSize=50*1024^2) 


# Define server logic
#----------------------
shinyServer(function(input, output, session) {
  
  
  #########################
  #HOME PAGE LOGIN
  ######################## 
  
  
  #########################
  #SAMPLE OF UPLOADED DATA
  ########################
  # assigning the loaded file to a data.frame
  data <- reactive({
    infile <- input$file_selected
    
    
    #Check extension + load data
    #----------------------------
    
    # IF the user has NOT uploaded a file yet
    if (is.null(infile)) {
      data <- read.csv("data/kddcup.data_10_percent_corrected", header=FALSE)
      data <- na.omit(data)
      data <- data[sample(nrow(data), size = 1000, replace = FALSE, prob = NULL),]
      
      data$ID <- paste("id",1:nrow(data), sep="")
      data <- cbind(ID = data[,43], data[,1:42])
      colnames(data) <- c(  "ID", 
                            "duration",
                            "protocol_type",
                            "service",
                            "flag",
                            "src_bytes",
                            "dst_bytes",
                            "land",
                            "wrong_fragment",
                            "urgent",
                            "hot",
                            "num_failed_logins",
                            "logged_in",
                            "num_compromised",
                            "root_shell",
                            "su_attempted", 
                            "num_root",
                            "num_file_creations",
                            "num_shells",
                            "num_access_files",
                            "num_outbound_cmds",
                            "is_host_login",
                            "is_guest_login",
                            "count",
                            "srv_count",
                            "serror_rate",
                            "srv_serror_rate",
                            "rerror_rate",
                            "srv_rerror_rate",
                            "same_srv_rate",
                            "diff_srv_rate",
                            "srv_diff_host_rate",
                            "dst_host_count",
                            "dst_host_srv_count",
                            "dst_host_same_srv_rate",
                            "dst_host_diff_srv_rate",
                            "dst_host_same_src_port_rate",
                            "dst_host_srv_diff_host_rate",
                            "dst_host_serror_rate",
                            "dst_host_srv_serror_rate",
                            "dst_host_rerror_rate",
                            "dst_host_srv_rerror_rate",
                            "fraud_label")
      
      # IF the user has uploaded his dataset
    } else {
      
      #IF the file extension is NOT correct
      ext <- tolower(tools::file_ext(infile))
      if (!ext %in% c("csv","txt")) {
        createAlert(session, "alertextension",  "Alert1",  title = "Oops",
                    content = "Only CSV and Txt files are allowed at the moment. Please upload again with the right format :-)", append = FALSE)
        
        #IF the file extension is correct
      } else {
      closeAlert(session, "Alert1")
      data <- read.csv(infile$datapath, 
                         header=TRUE, 
                         sep=input$sep, 
                         quote=input$quote,
                         na.strings = "NA",
                         stringsAsFactors = TRUE) 
        
        #IF the uploaded data contains duplicated rownames
        if(sum(duplicated(data[,1]))>0){
          createAlert(session, "alertduplicate",  "Alert2",  title = "Oops",
                      content = "The first row, which contains the rownames, is not unique. 
                      Please follow the instructions and load your data again.", append = FALSE)
          
          #IF no duplicate rownames
        } else {
          closeAlert(session, "Alert2")
        }
        
        # IF Contains NA value 
        nrowWithMissingValue <- sum(!complete.cases(data)) # Count the number of row with missing value
        if (nrowWithMissingValue > 0) {
          createAlert(session, "alertmissing",  "Alert3",  title = "Oops",
                      content = "Your dataset contains missing value. Rows with missing values will be removed from the dataset.", append = FALSE)  
          data <- na.omit(data)
        } else {
          closeAlert(session, "Alert3") 
        }
    data <- CleanUp(data())
      }
    }
    
    
  return(data)
  })
  
  
  
  #Show near zero variance
  output$nearzerovariance <-renderTable({NearZeroVar(data())})  
  
  #Show data type
  output$datatype <-renderTable({DataType(data())})  
  #show data summary
  output$summary <-renderTable({DataSummary(data())})
  
  #Select variables to print in the sample dataset
  output$showvariablesample <- renderUI({
    selectizeInput("samplevariable", "Variable(s) in the preview",
                   colnames(data()),
                   selected = "", 
                   multiple = TRUE
    )
  })
  
  
  #Print sample of the dataset
  output$sample <- renderDataTable({SampleTable(data(), input$samplevariable, input$nrow.preview)
  })
  
  
  #########################
  #BUSINESS RULES
  ########################
  #bsButton("submit_rule","Register Rules",style="primary",type ="action", icon = icon("ban")),   
  
  #UPDATE AND LOAD UPDATED RULES
  #-----------------------------
  # builds a reactive expression that only invalidates when the button is pressed)
  updated_rule <- eventReactive(input$submit_rule, {
    fileConn<-file("./data/rules.txt")
    rules <- readLines(fileConn, ok = TRUE, skipNul = TRUE)
    rules[length(rules)+1] <- input$rule
    writeLines(rules, fileConn, sep = "\n")
    close(fileConn)
    
    #editfile Read conditional numerical, numerical and categorical constraints from textfile
    rules <- editfile("./data/rules.txt", type ='all')
    
    if (sum(isObviouslyRedundant(rules))> 0) {
      createAlert(session, "alertRuleRedundance",  "Alert10",  title = "Oops",
                  content = "Soms rules are obviously redundant", append = FALSE)
    } else {
      closeAlert(session, "Alert10")
    }
    if (isObviouslyInfeasible(rules)) {
      createAlert(session, "alertRuleInfeasible",  "Alert11",  title = "Oops",
                  content = "Soms rules are not feasible", append = FALSE)
    } else {
      closeAlert(session, "Alert11")  
    }
    
    return(rules)  
  })
  
  
  
  #COMPUTE VIOLATED RULES
  #-----------------------
  #Send back a dataframe for all observation with a TRUE/FALSE value for each rules
  violated_rules <- reactive(violatedEdits(updated_rule(), data()))
  
  #COMPUTE OUTPUT FOR UI.r
  #-------------------------
  output$columnnames <- renderText({
    colname <- colnames(data())
    variable_name <- "Here are the column name:"
      for (i in 1:length(colname)){variable_name <- paste(variable_name, colname[i], sep =',')}
      return(variable_name)
  })
  
  output$businessrules <-  renderPrint({BusinessRules(updated_rule())})
  output$businessrulesviolationsummary <- renderPlot({BusinessRulesViolationSummary(violated_rules() )})
  output$businessrulesnetwork <- renderPlot({BusinessRulesNetwork(updated_rule(), violated_rules() )})  #,input$rules_visualization
  output$businessrulesviolationobservation <- renderDataTable({BusinessRulesViolationObservation(data(),violated_rules() ) })
  
  
  #########################
  #BENFORD INTEGRITY CHECK
  ########################
  
  # Create select box input for choosing one numerical feature
  #-----------------------------------------------------------
  
  #!!!!!ATTENTION SHOULD CORRECT TO OFFER ONLY NUMERICAL VARIABLE
  
  output$variableselectionforbenford <- renderUI({
    selectizeInput("variablesforbenford", "Select a numerical variable:",
                   colnames(data()),
                   selected = "duration", 
                   multiple = FALSE
    )
  })	
  
  
  output$benfordgoodnessfit <-  renderPrint({BenfordGoodnessTest(data(), input$variablesforbenford)})
  output$benfordplot <- renderPlot({  BenfordPlotCompare(data(), input$variablesforbenford) })
  
  
  
  
  #########################
  #UNIVARIATE TEST
  ########################
  #!!!!!ATTENTION SHOULD CORRECT TO OFFER ONLY NUMERICAL VARIABLE
  
  output$variableselectionunivariate <- renderUI({
    selectizeInput("variablesunivariate", "Select a numerical variable:",
                   colnames(data()),
                   selected = "src_bytes", 
                   multiple = FALSE
    )
  })	
  
  output$uniplot <-  renderPlot({ UniPlot(data(), input$variablesunivariate, input$z_score_univariate)})
  output$unidata <-  renderDataTable({UniTable(data(),input$variablesunivariate, input$z_score_univariate) })
  
  
  
  #########################
  #MULTIVARIATE TEST
  ########################
  
  output$dependentvariableselectionmultivariate <- renderUI({
    selectizeInput("dependantvariables", "Select a dependent variable:",
                   colnames(data()),
                   selected = "src_bytes", 
                   multiple = FALSE
    )
  })
  
  output$explainationvariableselectionmultivariate <- renderUI({
    selectizeInput("explainationtvariables", "Select explaination variable(s):",
                   colnames(data()),
                   selected = c("duration", "dst_bytes"), 
                   multiple = TRUE
    )
  })	
  
  
  output$featureplot    <- renderPlot({ FeaturePlot(data(), input$dependantvariables, input$explainationtvariables)})
  
  #Elastic Net
  elasticnet <- reactive(Elasticnet(data(), input$dependantvariables, input$explainationtvariables))
  output$elasticnetplot <- renderPlot({ElasticnetPlot(elasticnet(), input$dependantvariables, input$param_multi_enet)})
  output$elasticnettable <-  renderDataTable({ElasticnetTable(elasticnet(), input$dependantvariables, input$explainationtvariables, input$param_multi_enet)})
  
  #Cook
  cook <- reactive(Cook(data(),input$dependantvariables, input$explainationtvariables ))
  output$cookmultiplot  <-  renderPlot({CookMultiPlot(cook(), input$dependantvariables, input$param)})
  output$cookmultitable <-  renderDataTable({CookMultiTable(cook(), input$param)})

  
  
  #############################
  # ABOD GLOBAL
  #############################
  output$abodvariableselection_global <- renderUI({
    selectizeInput("abodvariables_global", "Select variable(s):",
                   colnames(data()),
                   selected =  c("dst_host_same_srv_rate",
                               "dst_host_diff_srv_rate",
                               "dst_host_same_src_port_rate",
                               "dst_host_srv_diff_host_rate",
                               "dst_host_serror_rate"), 
                   multiple = TRUE
    )
  })
  
  
  abod_global  <- eventReactive(input$abod_button_global, {
    Abod_global(data(), input$abodvariables_global,input$abodpercentage_global )
  })
  

  output$abodplot_global    <- renderPlot({ 
    if (input$abod_button_global == 0){return()
    }else {AbodPlot(abod_global(), input$abodz_score_global)}
  })
  
  
  output$abodtable_global <-  renderDataTable({
    if (input$abod_button_global == 0){return()
    }else {AbodTable(data(), input$abodvariables_global, input$abodz_score_global,abod_global())}
  })
  

  
  ############################
  #LOCAL OUTLIER FACTOR TEST
  ############################
  output$lofvariableselection <- renderUI({
    selectizeInput("lofvariables", "Select variable(s):",
                   colnames(data()),
                   selected = "src_bytes", 
                   multiple = TRUE
    )
  })
  
  lof <- reactive(Lof(data(),input$lofvariables, input$lofparameter))
  output$lofplot <-  renderPlot({ LofPlot(lof(), input$lof_score ) })
  output$loftable <-  renderDataTable({LofData(lof(), input$lofvariables, input$lof_score ) })
  
  
  #############################
  # OPTIC
  #############################
  output$opticvariableselection <- renderUI({
    selectizeInput("opticvariables", "Select variable(s):",
                   colnames(data()),
                   selected = c("dst_host_diff_srv_rate",
                                "dst_host_same_src_port_rate",
                                "dst_host_srv_diff_host_rate"
                                ),
                   multiple = TRUE
    )
  })	
  
  
  optic  <- eventReactive(input$optic_button, {
    Optic(data(),input$opticvariables,input$parameterReachability, input$parameterminPts, input$parameterIntraReachability)
  })
  

  output$opticsummary <- renderPrint({
    if (input$optic_button == 0){return()
    }else {print(optic()) }
  })
  
  
  output$reachabilityplot<- renderPlot({
    if (input$optic_button == 0){return()
    }else {plot(optic())}
  })
  
  
  output$opticplot    <- renderPlot({ 
    if (input$optic_button == 0){return()
    }else {OpticPlot(optic(), input$optic_score)}
  })
  
  
  output$optictable <-  renderDataTable({
    if (input$optic_button == 0){return()
    }else {OpticTable(data(), input$opticvariables, input$optic_score, optic())}
  })
    

  
  
  ############################
  #ONE CLASS SVM
  ############################
  #output$variableselectionsvm <- renderUI({
  #  selectizeInput("explainationtvariablessvm", "Select explaination variable(s):",
  #                 colnames(data()),
  #                 selected = "", 
  #                 multiple = TRUE)})	
  
  #output$oneclasssvmtable <-  renderDataTable({ OneClassSVMTable(data(), input$dependantvariablessvm, input$explainationtvariablessvm)})
  
  
  #############################
  # ABOD LOCAL
  #############################
  output$abodvariableselection_local <- renderUI({
    selectizeInput("abodvariable_local", "Select variable(s):",
                   colnames(data()),
                   selected =  c("dst_host_same_srv_rate",
                                 "dst_host_diff_srv_rate",
                                 "dst_host_same_src_port_rate",
                                 "dst_host_srv_diff_host_rate",
                                 "dst_host_serror_rate"), 
                   multiple = TRUE
    )
  })
  
  
  abod_local  <- eventReactive(input$abod_button_local, {
    Abod_local(data(), input$abodvariable_local,input$abodneighbors )
  })
  
  
  output$abodplot_local    <- renderPlot({ 
    if (input$abod_button_local == 0){return()
    }else {AbodPlot(abod_local(), input$abodz_score_local)}
  })
  
  
  output$abodtable_local <-  renderDataTable({
    if (input$abod_button_local == 0){return()
    }else {AbodTable(data(), input$abodvariables_local, input$abodz_score_local,abod_local())}
  })
  
  
  ############################
  #SELF-ORGANIZING MAPS
  ############################
  output$variableselectionsom <- renderUI({
    selectizeInput("variablessom", "Select variables:",
                   colnames(data()),
                   selected = c("src_bytes", "dst_bytes"),
                   multiple = TRUE
    )
  })
  
  
  output$featureforsom <- renderUI({
    selectizeInput("featuresom", "Select a feature for exploration:",
                   input$variablessom,
                   selected = input$variablessom[1], 
                   multiple = FALSE
    )
  })
 
  modelsom <- reactive(Kohonen(data(), input$variablessom, input$dimx, input$dimy))
  output$trainingprogressplot <- renderPlot({TrainingProgressPlot(modelsom())})
  output$nodecountplot        <- renderPlot({NodeCountPlot(modelsom())})
  output$nbreclusterplot      <- renderPlot({NbreClusterPlot(modelsom(), input$dimx, input$dimy) })
  output$umatrixplot          <- renderPlot({U_matrixPlot(modelsom(), input$nbrecluster )  })
  output$heatmapplot          <- renderPlot({HeatmapPlot(modelsom(), input$nbrecluster, input$featuresom )  })
  output$somtable1 <-  renderDataTable({SomTable1(data(), modelsom(), input$variablessom, input$nodeid) })
  output$somtable2 <-  renderDataTable({SomTable2(data(), modelsom(), input$variablessom, input$som_score) })
  
  
  #########################
  #RESULTS
  ########################

  # DATA QUALITY
  #-----------------
  dataqualitysummary <-  reactive(BusinessRulesSummary(data(),violated_rules(), input$qualitynbre) )
  
  #Print table
  output$dataquality <- renderDataTable({dataqualitysummary() })
  
  #Download result
  output$downloaddataquality <- downloadHandler(
    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = paste0("download_", Sys.Date(),".csv"),
    # Write to a file specified by the 'file' argument
    content = function(file) {write.table(x= dataqualitysummary() , file = file, row.names=FALSE, sep =";", col.names=TRUE)}
  )
  
  
  
  # LOCAL ET GLOBAL OUTLIER
  #-------------------------
   outliersummary <- reactive(OutlierSummary(data(), elasticnet(),lof(), cook(),optic(), input$outliernbre))
  
  #ATTENTION DOIT ENCORE AJOUTER optic()
  
  #Print Table
      output$outliersummary <- renderDataTable({outliersummary() })

  #Download result
      output$downloaddataoutlier <- downloadHandler(
        filename = paste0("download_", Sys.Date(),".csv"),
        content = function(file) {write.table(x= outliersummary() , file = file, row.names=FALSE, sep =";", col.names=TRUE)}
      )
  
  
  #PATTERNS
  #----------
  somsummary <-  reactive(SomSummary(data(), modelsom(), input$variablessom, input$som_score, input$somnbre) )
  
  #Print table
    output$somsummary <-  renderDataTable({somsummary() })
    
  #Download result
    output$downloaddatapattern <- downloadHandler(
      filename = paste0("download_", Sys.Date(),".csv"),
      content = function(file) {write.table(x= somsummary() , file = file, row.names=FALSE, sep =";", col.names=TRUE)}
    )
  

  
  
  
  
}) #End of shiny server


