
## ui.R ##
library(shiny)
library(shinydashboard)
library(shinyBS)
library(shinythemes)




ui <- dashboardPage(skin = "black",
                    dashboardHeader(title = "MC DataLab"),
                    
                    
                    dashboardSidebar(disable = FALSE, 
                    sidebarSearchForm(textId = "searchText", buttonId = "searchButton", label = "Search..."),
                    sidebarMenu(
                                          menuItem("Home", tabName = "home", icon = icon("home"), selected = TRUE),
                                          menuItem("Uploading", tabName = "load", icon = icon("upload")),
                                          menuItem("Data Quality", icon = icon("bug"),
                                                   menuSubItem("Sanity Check", tabName = "rule"),
                                                   menuSubItem("Integrity Check", tabName = "integrity")
                                          ),
                                          menuItem("Global Outliers",icon = icon("user"),
                                                   menuSubItem("Univariate model", tabName = "uni"),
                                                   menuSubItem("Multivariate model", tabName = "multi"),
                                                   menuSubItem("Angle-based outlier degree", tabName = "abod_global")
                                          ),
                                          menuItem("Local Outliers",icon = icon("users"),
                                                   menuSubItem("Ordering points clustering", tabName = "optic"),
                                                   menuSubItem("Local Outlier Factor", tabName = "lof"),
                                                   menuSubItem("Angle-based outlier degree", tabName = "abod_local")
                                                   
                                          ),                                          
                                          menuItem("Patterns", tabName = "som", icon = icon("paw")
                                          ),
                                          #menuItem("Classifier",icon = icon("users"),
                                          #         menuSubItem("One-class SVM", tabName = "oneclasssvm"),
                                          #         menuSubItem("Two-class classifier", tabName = "twoclass")
                                          #),
                                          
                                          menuItem("Summary", tabName = "result",icon = icon("file-text-o"))  
                                       )
                    ),

                    dashboardBody(
                      #Upload customize CSS
                      tags$head( tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),  # Upload my CSS from www/CSS 
                      
                      
                      #Footnote
                      div(id = "myfooter",
                          span(
                            span("Created by "),
                            a("MC DataLab", id = "datalab"), 
                            bsModal(id = "datalabmodal", title = "MC Data Lab", trigger = "datalab", size = "large",
                                    includeHTML("html/datalab.html")),
                            HTML(" - "),
                            span("User Guide"),
                            a("on Shine", href = "https://teams.cmc.be/sites/191_d_mcass"),
                            HTML(" - "),
                            span("May 10, 2016"),
                            HTML(" - "),
                            a("Copyright", id = "copyright"), 
                            bsModal(id = "copyrightmodal", title = HTML("<p> &copy; Copyright</p>"), trigger = "copyright", size = "large",
                                    includeHTML("html/copyright.html"))
                          )
                      ),
                      
                                           
                      tabItems(   
                        
                        # CONTENT HOME
                        #----------------------------
                        tabItem(tabName = "home", 
                                div(class = "homepage",
                                    fluidRow(
                                      column(1),
                                      column(5, 
                                         br(),
                                         br(),
                                         br(),
                                         br(),
                                         br(),
                                         br(),
                                         br(),
                                         HTML("<img src ='./img/mac.png' style='width:100%; height: 100%;  position=absolute; left=0px; top=0px; opacity=1;'> "),
                                         HTML("
                                                <div id='carousel-example-generic' class='carousel slide' data-ride='carousel'> 
                                                  <!-- Indicators --> 
                                                    <ol class='carousel-indicators'> 
                                                      <li data-target='#carousel-example-generic' data-slide-to='0' class='active'></li> 
                                                      <li data-target='#carousel-example-generic' data-slide-to='1'></li> 
                                                      <li data-target='#carousel-example-generic' data-slide-to='2'></li> 
                                                    </ol> 
                                              
                                                  <!-- Wrapper for slides --> 
                                                  <div class='carousel-inner' role='listbox'> 
                                                  
                                                    <div class='item active'> 
                                                      <img src='./img/homepage1.jpg'> 
                                                      <div class='carousel-caption'> <h3> Upload Data </h3> </div> 
                                                    </div> 
                                                    
                                                    <div class='item'> 
                                                      <img src='./img/homepage2.jpg' > 
                                                      <div class='carousel-caption'> <h3> Run Analytics </h3></div> 
                                                    </div>
                                                    
                                                    <div class='item'> 
                                                      <img src='./img/homepage3.jpg'> 
                                                      <div class='carousel-caption'> <h3> Explore Insights </h3> </div> 
                                                    </div>
                                                  </div>  <!-- End Wrapper --> 
                                              
                                                  <!-- Controls --> 
                                                  <a class='left carousel-control' href='#carousel-example-generic' role='button' data-slide='prev'> 
                                                  <span class='glyphicon glyphicon-chevron-left' aria-hidden='true'></span> 
                                                  <span class='sr-only'>Previous</span> 
                                                  </a> 
                                                  <a class='right carousel-control' href='#carousel-example-generic' role='button' data-slide='next'> 
                                                  <span class='glyphicon glyphicon-chevron-right' aria-hidden='true'></span> 
                                                  <span class='sr-only'>Next</span> 
                                                  </a> 
                                              </div>                                         
                                              ") 
                                         ),
                                      column(5,
                                         br(),
                                         br(),
                                         br(),
                                         br(),
                                         br(),
                                         br(),
                                         br(),
                                         br(),
                                         br(),
                                          h1("Anomaly Detection"),
                                          h2("Let's bring the power of advanced analytics to let you spot suspicious cases that require investigation. 
                                              No knowledge of fraud schemes is required beforehand: just load your data in
                                          and look what happens."),
                                          HTML("<a class='btn btn-default' 
                                                    href='#shiny-tab-load' 
                                              data-toggle='tab' 
                                              data-value='load'
                                              >          
                                              <span>Show me the magic!</span>
                                              </a>")
                                      ),
                                      column(1)
                                    ),
                                    fluidRow(
                                    br(),
                                    br(),
                                    br(),
                                    br(),
                                    br(),
                                    br(),
                                    br()
                                    )
                                  ),
                                div(class = "homepagebanner",
                                    fluidRow(
                                      h1("A BASIC 3 STEPS PROCESS"),
                                      br(),
                                      br(),
                                      br(),
                                      br()
                                    ),
                                    fluidRow(
                                      
                                      column(4,
                                             div(style = " text-align: center; font-size: 80px; color: #222d32; opacity: 0.7; padding-left: 20%; padding-right:20%;",
                                                 icon("upload"),
                                                 h3("Preparation"),
                                                 p("Identify the data that needs to be used and organize them for analysis in a single spreadsheet.")
                                             )
                                      ),
                                      
                                      column(4,
                                             div(style = " text-align: center; font-size: 80px; color: #222d32; opacity: 0.7;padding-left: 20%; padding-right:20%;",
                                                 icon("magic"),
                                                 h3("Analyzation"),
                                                 p("Fraudster usually leaves tracks behind them, generating numbers that breaks statistics laws and rules.
                                                   The application looks for those numbers that behaves differently from what it should and assign accordingly a score,
                                                   giving you an hint on where to look to discover frauds.")
                                                 )
                                                 ),
                                      
                                      column(4,
                                             div(style = " text-align: center; font-size: 80px; color: #222d32; opacity: 0.7;padding-left: 20%; padding-right:20%;",
                                                 icon("search"),
                                                 h3("Investigation"),
                                                 p("Investigate suspicious cases by decreasing fraud scores and discover which records is affected by fraud.
                                                   Results of your investigations may then be used to tune the scoring system and feed a supervised learning algorithm.
                                                   ")
                                                 )
                                                 )
                                             )
                                      ),
                                
                                
                                
                                div(class="homepagebenef",
                                    fluidRow(
                                      h1("COMBINE TECHNICAL APPROACHES"),
                                      column(4, div(style = "padding-left:20%;padding-right:20%;",
                                                    h3("Data Quality Check"),
                                                    p("A business rules engine combine with a statistical tool operate sanity and integry checks.")
                                      )),      
                                      column(4, div(style = "padding-left:20%;padding-right:20%;",
                                                    h3("Outliers Detection"),
                                                    p("Outlier detection measures the distance between data points, particularly those that
                                                      are far ouside the common range of other data in the local and global set.")
                                                    )),
                                      column(4, div(style = "padding-left:20%;padding-right:20%;",
                                                    h3("New Patterns Discovery"),
                                                    p("A non-linear statisitcal tool modeled after the humain brain for identifying patterns.")
                                      ))
                                      )
                                      ),
                                
                                
                                
                                div(class="homepagebanner",
                                    fluidRow(
                                      h1("BRING MAJOR BENEFITS"),
                                      column(4, div(style = "padding-left:20%;padding-right:20%;",
                                                    h3("Higher Hit Rate"),
                                                    p("Statistically based methodologies offer an increased detection power compared to rules based approaches.
                                                      By ranking all cases from low to high suspiciousness, the system allows to allocate the limited resources more efficiently
                                                      and translates in a higher fraction of fraudulent cases among the inspected cases.")
                                                    )),      
                                      column(4, div(style = "padding-left:20%;padding-right:20%;",
                                                    h3("Lower Maintenance"),
                                                    p("Since fraud types can be complex and continuously evolve, developing and maintaining an effective and lean hard coded rules system is labour intensive compared to
                                                      a more automated data-driven approach.")
                                                    )),
                                      column(4, div(style = "padding-left:20%;padding-right:20%;",
                                                    h3("Detect Unknown"),
                                                    p("If we know what we are looking for already, rules based approaches are enough.
                                                      But there are often also unknown unknowns (things we don't know we don't know). In these cases, it's important to be able to find new types of pattern
                                                      that have never been seen before.Unsupervised learning techniques are useful in these cases.")
                                                    ))
                                                    )
                                      ),
                                
                                div(class = "homepageword",
                                    fluidRow(div(style = "text-align: justify;",
                                                 h1("SHARE A WORD"),
                                                 HTML("
                                                      <p>
                                                      Have a question, need some help, want to talk about your challenges or just interested in sharing thoughts
                                                      about the future of data and technology in fraud detection, feel free to drop us a line. We'd love to hear what you're working on
                                                      and how we could benefit from each other experiences and skills...
                                                      </p>                                                                
                                                      <ul>
                                                      <li> <strong>Phone:</strong> (+32) 022462695</li>
                                                      <li> <strong> Email: </strong> <a href='mailto:sven.wauters@mc.be'>sven.wauters@mc.be</a></li>
                                                      </ul>
                                                      "))
                                                 )
                                                 )
                                
                      ),  # END OF HOME PAGE
                        
                      
                      
                      
                      
                      # CONTENT LOAD DATA
                      #----------------------------
                      tabItem(tabName = "load", 
                          fluidRow(
                            box(
                              width = 3,
                              title="Load your data (or select demo mode)",
                              collapsible = TRUE,
                              h4("Option 1: Load your own data"),
                              helpText(HTML("Import your data set using the
                                       import button below. Your data must be supplied according to these <a id='instruction'> instructions </a> in the form of a text/csv file.
                                       If the uploading is done properly, a preview of the data is displayed below.
                                       If not,
                                       change the file uploading options.")
                              ),
                              bsModal("modalinstruction", "Instructions", "instruction", size = "large", includeHTML("./html/dataset_structure.html")),
                              
                              fluidRow(
                                  column(6,
                                         radioButtons(inputId = 'sep',
                                                      label = 'Separator',
                                                      c(Comma=',',
                                                        Semicolon=';',
                                                        Tab='\t'),
                                                       selected = ';')
                                  ),
                                  column(6,
                                         radioButtons('quote', 'Quote',
                                                      c(None='',
                                                        'Double Quote'='"',
                                                        'Single Quote'="'"),
                                                      selected = '"')
                                  )
                              ),
                              br(),
                              
                              fileInput(inputId ='file_selected', 
                                        label ='Choose CSV File',
                                        multiple = FALSE,
                                        accept=c('text/csv', 
                                                 'text/comma-separated-values,text/plain', 
                                                 '.csv')
                              ),
                              bsAlert("alertextension"),
                              bsAlert("alertduplicate"),
                              bsAlert("alertmissing"),
                              HTML("<hr />"), 
                              h4("Option 2: Lauch the demo"),
                              helpText(HTML("The application can be tested using example data files.
                                            If you click the bottom, it will upload a demo dataset.")),
                              br(),
                              bsButton("demo","Try the demo",style="primary"),  
                              br(),
                              HTML("<hr style='height: 3px; color: #00bdef; background-color: #D9D9D9; border: none;'>"),
                              
                              
                              h4("Define preview "),
                              helpText("Note: Even if the preview only shows a restricted
                                       number of observations, the map will be based on the full dataset."),
                              fluidRow(  
                                column(6, 
                                       uiOutput("showvariablesample")
                                ),
                                column(6,
                                       numericInput('nrow.preview','Number of rows in the preview',value = 10)
                                )
                              )   
                              
                            ),
                            box(
                              width = 2,
                              title="Near zero-variance variable",
                              collapsible = TRUE,
                              tableOutput("nearzerovariance")
                            ),
                            box(
                              width = 3,
                              title="Data type",
                              collapsible = TRUE, 
                              tableOutput("datatype")
                            ),
                            box(
                              width = 4,
                              title="Data Summary",
                              collapsible = TRUE,
                              tableOutput("summary")
                            )
                           
                          ),
                          fluidRow(
                            box(
                              width = 12,
                             title="Preview a sample of the dataset",
                             collapsible = TRUE,
                             dataTableOutput("sample")
                           )                    
                         )
                      ),
                            
                      # RULES ENGINE
                      #----------------------------
                      tabItem(tabName = "rule", 
                              fluidRow(
                                box(
                                  width =6,
                                  title = "Expert rule based detection",
                                  #queryBuildROutput("queryBuilderWidget",width="800px",height="100%")
                                  collapsible = TRUE,
                                  helpText(HTML("This tab allows users to (1) define new business rules
                                  (2) verify data against them and (3) localize errors.")),
                                  hr(),
                                  h4("Add Business Rules"),
                                  helpText(HTML("Business rules have to follow the following syntax,
                                                <ui>
                                                <li>employment %in% c('unemployed','employed','retired')</li>
                                                <li>if (employment == 'unemployed') salary == 'none' </li>
                                                <li>if( gender == 'male' ) !pregnant </li>
                                                <li>if ( x > 0 ) y > 0 </li>
                                                <li> x + y == z </li>
                                                </ui>
                                                In order to ease your task, variables name are printed hereby.
                                            ")),
                                  verbatimTextOutput("columnnames"),
                                  textInput(inputId = "rule", label = "", value = "Enter rules..."),
                                  #tags$textarea(id="foo", rows=3, "Default value"),
                                  br(),
                                  bsButton("submit_rule","Register Rules",style="primary",type ="action"),  
                                  br(),
                                  br(),
                                  bsAlert("alertRuleInfeasible"),
                                  bsAlert("alertRuleRedundance"),
                                  hr(),
                                  h4("Choose a visualization"),
                                  helpText(HTML("The round, blue nodes represent variables and the square nodes represent edit rules.")),
                                  radioButtons(inputId = 'rules_visualization',
                                               label = 'Select a visualization',
                                                 c("only rules"=1,
                                                   "only variables"=2,
                                                   "Variables and rules"=3
                                                  ),
                                               selected = 3)
                                ),
                                box(
                                  width =6,
                                  title = "Business rules blocks",
                                  collapsible = TRUE,
                                  verbatimTextOutput("businessrules")
                                )
                              ),
                              
                              fluidRow(
                                box(
                                  width =6,
                                  title = "Business rules violation summary",
                                  collapsible = TRUE,
                                  plotOutput("businessrulesviolationsummary")
                                ),
                                
                                box(
                                  width =6,
                                  title = "Business rules connections",
                                  collapsible = TRUE,
                                  plotOutput("businessrulesnetwork")
                                )
                              ),
                              
                              fluidRow(
                                box(
                                  width =12,
                                  title = "Observations with violated rule(s)",
                                  collapsible = TRUE,
                                  dataTableOutput("businessrulesviolationobservation")
                                )
                              )
                      ),
                                
                                
                                
                      # DATA INTEGRITY
                      #-----------------
                      tabItem(tabName = "integrity", 
                              fluidRow(
                                box(
                                  width = 6,
                                  title="Benford's Law",
                                  collapsible = TRUE,
                                  helpText(HTML("The <a id='benford' > Benford's Law </a> will apply a goodness of fit of the observed frequencies of the first-digits for the selected variable.
                                    You have to be cautious when using Benford's Law. It is unlikely to be useful in the following cases:
                                    <ui>
                                        <li>
                                        Data set is comprised of assigned numbers (example, 
                                        Check numbers, invoice numbers, zip codes),
                                        </li>

                                        <li>
                                        Numbers that are influenced by human thought  (example,
                                        Prices set at psychological thresholds (1.99), ATM withdrawals)
                                        </li>

                                        <li>
                                        Accounts with a large number of firm-specific numbers (example,
                                        An account specifically set up to record 100 refunds)
                                        </li>

                                        <li>
                                        Accounts with a built in minimum or maximum (for example,
                                        Set of assets that must meet a threshold to be recorded)
                                        </li>

                                        <li>
                                        Where no transaction is recorded (example, Thefts, kickbacks, contract rigging)
                                        </li>
                                    </ui>
                                    ")),
                                  bsModal("modalbenford", "Benford's Law", "benford", size = "large", includeHTML("./html/benford.html")),
                              
                                  uiOutput("variableselectionforbenford")
                                 ),
                                
                                box(
                                  width = 6,
                                  title="Goodnes of Fit Test",
                                  collapsible = TRUE,        
                                  p(tags$b("Goodness of Fit Test:")),
                                  verbatimTextOutput("benfordgoodnessfit")
                                )  
                              ),
                              
                              fluidRow(
                                box(
                                  width = 12,
                                  title="Proportion of First Digits",
                                  collapsible = TRUE,
                                  plotOutput("benfordplot")
                                 )
                              )#closes fluidRow
                      ),# End of Benford Law
                      
                      
                      # OUTLIERS DETECTION: STATISTICAL METHOD
                      #---------------------------------------
                      tabItem(tabName = "uni", 
                              fluidRow(
                                box(
                                  width = 4,
                                  title="Univariate approach",
                                  collapsible = TRUE,
                                  helpText(HTML("The <a id='univariate'> univariate statistical approach </a> find elements which do not follow the behaviour of the majority.
                                  They are points in a data set that are far away from the estimated value of the centre of the data set. 
                                                ")),
                                  bsModal("modalunivariate", "Univariate Statisitical Approach", "univariate", size = "large", includeHTML("./html/univariate.html")),
                                  #define selection input
                                  uiOutput("variableselectionunivariate"),
                                  #define input slider
                                  sliderInput("z_score_univariate",
                                              label = h5("Select a Z-score"),
                                              min = 2,
                                              max = 10,
                                              value = 3)
                                ),
                                box(
                                  width = 8,
                                  title="Density Distribution Control Chart",
                                  collapsible = TRUE,
                                  plotOutput("uniplot")
                                )
                              ),
                              fluidRow(  
                                box(
                                  width = 12,
                                  title="Results",
                                  collapsible = TRUE,
                                  dataTableOutput("unidata")
                                )
                              )
                      ),
                              
                      tabItem(tabName = "multi", 
                              fluidRow(
                                box(
                                  width = 4,
                                  title="Multivariate approach",
                                  collapsible = TRUE,
                                  helpText(HTML("The <a id='multivariate'> multivariate statistical approach </a> find elements which do not follow the behaviour of the global statistical model. 
                                                ")),
                                  bsModal("modalmultivariate", "Multivariate Statisitical Approach", "multivariate", size = "large", includeHTML("./html/multivariate.html")),
                                  
                                  
                                  #define selection inputs
                                  uiOutput("dependentvariableselectionmultivariate"),
                                  uiOutput("explainationvariableselectionmultivariate"),
                                  br(),
                                  #define input slider
                                  helpText("Scores higher than 3 are usually consider as outliers"),
                                  sliderInput("param_multi_enet",
                                              label = h5("Select a Z-score"),
                                              min = 0,
                                              max = 10,
                                              value = 2),
                                  helpText("Scores higher than 4 are usually consider as outliers"),
                                  sliderInput("param",
                                              label = h5("Select a Cook's distance"),
                                              min = 1,
                                              max = 15,
                                              value = 4)
                                ),
                                box(
                                  width = 8,
                                  title="Relationship between predictores and predicted value",
                                  collapsible = TRUE,
                                  plotOutput("featureplot")
                                )
                              ),
                              fluidRow( 
                                box(
                                  width = 4,
                                  title="Elastic Net Control Chart",
                                  collapsible = TRUE,
                                  helpText(HTML("The <a id='smart'> Elastic Net Regression Line</a> 
                                                computes residuals of predicted outcome from a regularized linear regression. 
                                                to find points that do not fit the model.")
                                  ),
                                  bsModal(id= "smart", title = "Multivariate adaptive regression spline", trigger ="smart", size = "large",
                                          HTML("Multivariate adaptive regression spline is ... 
                                               ")
                                  ),
                                  plotOutput("elasticnetplot")
                                ),
                                
                                box(
                                  width = 8,
                                  title="Results",
                                  collapsible = TRUE,
                                  dataTableOutput("elasticnettable")
                                )
                              ),   
                              
                              fluidRow( 
                                box(
                                  width = 4,
                                  title="Cook's Distanc Control Chart",
                                  collapsible = TRUE,
                                  helpText(HTML("The <a id='CookDistance'> Cooks Distance</a> 
                                                computes the influence exerted by each data point (row) 
                                                on the predicted outcome from a linear regression")
                                  ),
                                  bsModal(id= "modal_cook", title = "The Cook's Distance", trigger ="CookDistance", size = "large",
                                          HTML("Cook's distance is a measure computed with respect to a given regression model
                                               and therefore is impacted only by the X variables included in the model. 
                                               But, what does cook's distance mean? It computes the influence exerted 
                                               by each data point (row) on the predicted outcome.
                                               </br>
                                               The cook's distance for each observation i measures the change 
                                               in fitted value for all observations with and without the presence of observation i, 
                                               so we know how much the observation i impacted the fitted values. 
                                               ")
                                          ),
                                  plotOutput("cookmultiplot")
                                ),
                               
                                box(
                                  width = 8 ,
                                  title="Results",
                                  collapsible = TRUE,
                                  dataTableOutput("cookmultitable")
                                )
                              )   
                      ),
                              
              
                      
                      # ANGULAR  ABOD Global 
                      #---------------------------------------
                      tabItem(tabName = "abod_global", 
                              fluidRow(
                                box(
                                  width = 4,
                                  title="Angle-based outlier degree",
                                  collapsible = TRUE,
                                  helpText(HTML("
                                                The <a id='abod'> Angle-based outlier degree</a> search for data points that are at the border of 
                                                the data distribution by considering the spectrum of all angle between a specific point and other randomized points.
                                                A point is an outlier if most other points are located in similar directions.")),
                                  bsModal(id= "modal_abod", title = "Angle-based outlier degree", trigger ="abod", size = "large", includeHTML("./html/abod_global.html")),
                                  HTML("<hr/>"), 
                                  uiOutput("abodvariableselection_global"),
                                  
                                  #define input slider
                                  sliderInput("abodpercentage_global",
                                              label = h5("Define the percentage of data to use "),
                                              min = 0,
                                              max = 1,
                                              value =0.1),
                                  sliderInput("abodz_score_global",
                                              label = h5("Select s Z-core"),
                                              min = 2,
                                              max = 10,
                                              value = 3),
                                  br(),
                                  bsButton("abod_button_global","Go!",style="primary",type ="action")
                                  ),
                                box(
                                  width = 8,
                                  title="Control Chart",
                                  collapsible = TRUE,
                                  plotOutput("abodplot_global")
                                )
                              ),
                              fluidRow(  
                                box(
                                  width = 12,
                                  title="Results",
                                  collapsible = TRUE,
                                  dataTableOutput("abodtable_global")
                                )
                              )  
                      ),
                      
                              
                                                      
                      
                              
              # CLUSTERING: LOCAL OUTLIER FACTOR
              #---------------------------------------
                    tabItem(tabName = "lof", 
                              fluidRow(
                                box(
                                  width = 4,
                                  title="Local Outlier Factor",
                                  collapsible = TRUE,
                                  helpText(HTML("
                                The <a id='lof'> Local Outlier Factor </a> is an algorithm for identifying density-based local outliers. 
                                With LOF, the local density of a point is compared with that of its neighbors. 
                                If the former is signicantly lower than the latter (with an LOF value greater than one), 
                                the point is in a sparser region than its neighbors, which suggests it be an outlier.
                                ")),
                                  bsModal(id= "modal_lof", title = "Local Outlier Factor", trigger ="lof", size = "large", includeHTML("./html/lof.html")),
                                          
                                  HTML("<hr />"), 
                                  uiOutput("lofvariableselection"),
                                  #define input slider
                                  sliderInput("lofparameter",
                                              label = h5("Select the number of neighboors"),
                                              min = 1,
                                              max = 20,
                                              value = 5),
                                  sliderInput("lof_score",
                                              label = h5("Select a Z-score"),
                                              min = 2,
                                              max = 10,
                                              value = 3)
                                  
                                ),
                                box(
                                  width = 8,
                                  title="Control Chart",
                                  collapsible = TRUE,
                                  plotOutput("lofplot")
                                )
                              ),
                      fluidRow(  
                        box(
                          width = 12,
                          title="Results",
                          collapsible = TRUE,
                          dataTableOutput("loftable")
                              )
                            )  
                    ),
              
              # CLUSTERING: OPTIC
              #---------------------------------------
              tabItem(tabName = "optic", 
                      fluidRow(
                        box(
                          width = 4,
                          title="Ordering points to identify the clustering structure",
                          collapsible = TRUE,
                          helpText(HTML("The <a id='optic'> Ordering points to identify the clustering structure</a> 
                                        Ordering points to identify the clustering structure (OPTICS) is an algorithm for finding density-based clusters in spatial data. 
                                        Its basic idea is similar to DBSCAN, but it addresses one of DBSCAN's major weaknesses: 
                                        the problem of detecting meaningful clusters in data of varying density. 
                                        In order to do so, the points of the database are (linearly) ordered such that points which are spatially closest become neighbors 
                                        in the ordering. Additionally, a special distance is stored for each point that represents the density that needs to be accepted 
                                        for a cluster in order to have both points belong to the same cluster. ")
                          ),
                          bsModal(id= "modaloptic", title = "Density-Based Spatial Clustering", 
                                  trigger ="optic", size = "large",includeHTML("./html/optics.html")),
                          #define selection inputs
                          HTML("<hr />"), 
                          uiOutput("opticvariableselection"),
                          #define input slider
                          sliderInput("parameterReachability",
                                      label = h5("Select a reachability distance"),
                                      min = 0,
                                      max = 3,
                                      value = 2),
                          sliderInput("parameterminPts",
                                      label = h5("Select a min size for each cluster"),
                                      min = 1,
                                      max = 100,
                                      value = 10),
                          sliderInput("parameterIntraReachability",
                                      label = h5("Select a intra cluster reachability"),
                                      min = 0,
                                      max = 2,
                                      value = 1),
                          
                          sliderInput("optic_score",
                                      label = h5("Select a Z-score"),
                                      min = 2,
                                      max = 10,
                                      value = 3),
                          
                          br(),
                          bsButton("optic_button","Go!",style="primary",type ="action")
                        ),
                        box(
                          width = 8,
                          title="Control Chart",
                          collapsible = TRUE,
                          plotOutput("opticplot")
                        )
                      ),
                      
                      fluidRow(  
                        box(
                          width = 4,
                          title="Summary",
                          collapsible = TRUE, 
                          textOutput("opticsummary")
                        ),
                        box(
                          width = 8,
                          title="Reachability Plot",
                          collapsible = TRUE,
                          plotOutput("reachabilityplot")
                        )
                      ),
                      
                      fluidRow(  
                        box(
                          width = 12,
                          title="Results",
                          collapsible = TRUE,
                          dataTableOutput("optictable")
                        )
                      )  
              ),
              
              # ANGULAR  ABOD Local
              #---------------------------------------
              tabItem(tabName = "abod_local", 
                      fluidRow(
                        box(
                          width = 4,
                          title="Angle-based outlier degree",
                          collapsible = TRUE,
                          helpText(HTML("
                                        The <a id='abod_local'> Angle-based outlier degree</a> search for data points that are at the border of 
                                        the data distribution by considering the spectrum of all angle between a specific point and other points in the neighborhood.
                                        A point is an outlier if most other points are located in similar directions.")),
                          bsModal(id= "modal_abod_local", title = "Angle-based outlier degree", trigger ="abod_local", size = "large", includeHTML("./html/abod_local.html")),
                          HTML("<hr/>"), 
                          uiOutput("abodvariableselection_local"),
                          
                          #define input slider
                          sliderInput("abodneighbors",
                                      label = h5("Define the number of neighbors "),
                                      min = 10,
                                      max = 100,
                                      value =15),
                          sliderInput("abodz_score_local",
                                      label = h5("Select s Z-core"),
                                      min = 2,
                                      max = 10,
                                      value = 3),
                          br(),
                          bsButton("abod_button_local","Go!",style="primary",type ="action")
                          ),
                        box(
                          width = 8,
                          title="Control Chart",
                          collapsible = TRUE,
                          plotOutput("abodplot_local")
                        )
                          ),
                      fluidRow(  
                        box(
                          width = 12,
                          title="Results",
                          collapsible = TRUE,
                          dataTableOutput("abodtable_local")
                        )
                      )  
                        ),
              
              
            # SELF ORGANISING MAPS
            #---------------------------------------------
              tabItem(tabName = "som", 
                      fluidRow(
                        box(
                          width = 3,
                          title="Self-Organising Maps Calibration",
                          collapsible = TRUE,
                          helpText(HTML("<a id='som'> Self-Organising Maps </a> (SOMs) are an unsupervised data visualisation technique 
                          that can be used to visualise high-dimensional data sets in 2 dimensional representations. 
                          In this panel, you have to select values for each parameter, 
                          visualize right panel results and adapte them (if necessary) to better calibrate the model. ")),
                          bsModal(id= "modalsom", title = "Self-Organising Maps", 
                                  trigger ="som", size = "large",includeHTML("./html/som.html")),
          
                          #define selection inputs
                          uiOutput("variableselectionsom"),
                          numericInput("dimx", "Map dimension X:", 5, min= 1),
                          numericInput("dimy", "Map dimension Y:", 5, min= 1),
                          actionButton("trainbutton","Train SOM")
                        ),
                        box(
                          width = 4,
                          title="Training Iterations Progress",
                          collapsible = TRUE,
                          helpText("As the SOM training iterations progress, the distance from each node's weights to the samples 
                          represented by that node is reduced. Ideally, this distance should reach a minimum plateau. 
                          This plot option shows the progress over time. If the curve is continually decreasing, more iterations are required."),
                          hr(),
                          plotOutput("trainingprogressplot")
                        ),
                      
                        box(
                          width = 5,
                          title="Node Count",
                          collapsible = TRUE,
                          helpText("The Kohonen packages allows us to visualise the count of how many samples are mapped to each node on the map. 
                          This metric can be used as a measure of map quality - ideally the sample distribution is relatively uniform. 
                          Large values in some map areas suggests that a larger map would be benificial. 
                          Empty nodes indicate that your map size is too big for the number of samples. 
                          Aim for at least 5-10 samples per node when choosing map size.
                          "),
                          hr(),
                          plotOutput("nodecountplot")
                        )
                      ),
                      fluidRow(
                        box(
                          width = 3,
                          title="Group into superclasses",
                          collapsible = TRUE,
                          helpText(HTML("In this panel you can group the clusters into 'superclasses'.")),
                          numericInput("nbrecluster", "Select clusters number:", 5, min= 1)
                        ),
                        box(
                          width = 4,
                          title="Find the number of Superclasses",
                          collapsible = TRUE,
                          helpText(HTML("The mean values and distributions of the training variables within each cluster are used to build a 
                          meaningful picture of the cluster characteristics.")),
                          hr(),
                          plotOutput("nbreclusterplot")
                        ),
                        box(
                          width = 5,
                          title="Neighbour Distance",
                          collapsible = TRUE,
                          helpText("Often referred to as the 'U-Matrix', this visualisation is of the distance between each node and its neighbours.
                          Typically viewed with a grayscale palette, areas of low neighbour distance indicate groups of nodes that are similar. 
                          Areas with large distances indicate the nodes are much more dissimilar - and indicate natural boundaries between node clusters. 
                          The U-Matrix can be used to identify clusters within the SOM map."),
                          hr(),
                          plotOutput("umatrixplot")
                        )
                      ),  
                      
                      fluidRow(
                        box(
                          width = 3,
                          title="Explore classes and superclasses",
                          collapsible = TRUE,
                          helpText(HTML("In this panel you can group the clusters into 'superclasses'.")),
                          hr(),
                          #define variable to plot into the heatmap
                          uiOutput("featureforsom")
                        ),
                        
                        box(
                          width = 9,
                          title="Heatmaps",
                          collapsible = TRUE,
                          helpText("Heatmaps are perhaps the most important visualisation possible for Self-Organising Maps. The use of a weight space view as in (4) that tries to view all dimensions on the one diagram is unsuitable for a high-dimensional (>7 variable) SOM. A SOM heatmap allows the visualisation of the distribution of a single variable across the map. Typically, a SOM investigative process involves the creation of multiple heatmaps, and then the comparison of these heatmaps to identify interesting areas on the map. It is important to remember that the individual sample positions do not move from one visualisation to another, the map is simply coloured by different variables.
                          The default Kohonen heatmap is created by using the type 'heatmap', and then providing one of the variables from the set of node weights. In this case we visualise the average education level on the SOM.
                          Kohonen Heatmap creation."),
                          hr(),
                          plotOutput("heatmapplot")
                          )
                        ), 
                      
                      fluidRow(
                        box(
                          width = 3,
                          title="Explore a suspicious node",
                          collapsible = TRUE,
                          helpText(HTML("In this panel you can extract value of a suspicious node.")),
                          hr(),
                          numericInput('nodeid','Select a node ',value = "")
                        ),
                        box(
                          width = 9,
                          title="Results",
                          collapsible = TRUE,
                          dataTableOutput("somtable1")
                        )
                      ),
                      fluidRow(
                        box(
                          width = 3,
                          title="Explore outliers",
                          collapsible = TRUE,
                          helpText(HTML("In this panel you can extract distances-basedouliers.")),
                          hr(),
                          sliderInput("som_score",
                                      label = h5("Select a Z-score"),
                                      min = 2,
                                      max = 10,
                                      value = 3)
                        ),
                        box(
                          width = 9,
                          title="Results",
                          collapsible = TRUE,
                          dataTableOutput("somtable2")
                        )
                      )
                  ),
            
                    # CLASSIFIER: ONE-CLASS SVM
                    #--------------------------              
                    tabItem(tabName = "oneclasssvm", 
                                fluidRow(
                                  box(
                                    width = 4,
                                    title="One-Class Support Vector Machine",
                                    collapsible = TRUE,
                                    helpText(HTML("The <a id='oneclass'> One-Class Support Vector Machine</a> is a powerfull algorithm for novelty detection.
                                                  ")
                                    ),
                                    bsModal(id= "modalonclass", title = "One Class Support Vector Machine", 
                                            trigger ="oneclass", size = "large",includeHTML("./html/oneclass.html"))
                                    #define selection inputs
                                    # uiOutput("variableselectionsvm")
                                    ),
                                  box(
                                    width = 8,
                                    title="Visualization: To be done",
                                    collapsible = TRUE
                                    #plotOutput("")
                                  )
                        ),
                        fluidRow(  
                          box(
                            width = 12,
                            title="Results",
                            collapsible = TRUE
                            #dataTableOutput("oneclasssvmtable")
                          )
                        )   
                    ),
                              

                   
                            
    
                      
                      # DATA RESULTS
                      #-----------------
                      
                      tabItem(tabName = "result", 
                              fluidRow(
                                box(
                                  width = 3,
                                  title="Data Quality",
                                  collapsible = TRUE, 
                                  includeHTML("./html/score_quality.html"),
                                  hr(),
                                  numericInput('qualitynbre','Select a number of candidates',value = 10),
                                  hr(),
                                  h5("Click the button to export results"),
                                  downloadButton("downloaddataquality", "download result")
                                ),
                                box(
                                  width = 9,
                                  title="Data Quality",
                                  collapsible = TRUE,
                                  dataTableOutput("dataquality")
                                )
                              ),
                              
                              fluidRow(
                                box(
                                  width = 3,
                                  title="Global and Local Outliers",
                                  collapsible = TRUE, 
                                  includeHTML("./html/score_outliers.html"),
                                  hr(),
                                  numericInput('outliernbre','Select a number of candidates',value = 10),
                                  hr(),
                                  h5("Click the button to export results"),
                                  downloadButton("downloaddataoutlier", "download result")
                                ),
                                box(
                                  width = 9,
                                  title="Global and Local Outliers",
                                  collapsible = TRUE,
                                  dataTableOutput("outliersummary")
                                )
                              ),
                              fluidRow(
                                box(
                                  width = 3,
                                  title="Fraud Patterns",
                                  collapsible = TRUE, 
                                  includeHTML("./html/score_pattern.html"),
                                  hr(),
                                  numericInput('somnbre','Select a number of candidates',value = 10),
                                  hr(),
                                  h5("Click the button to export results"),
                                  downloadButton("downloaddatapattern", "download result")
                                ),
                                box(
                                  width = 9,
                                  title="Fraud Patterns",
                                  collapsible = TRUE,
                                  dataTableOutput("somsummary")
                                )
                              )
                      )
                              
                        
      )# end of tabItems
  ) # end of DashboardBody         
)# End of dashboard page
