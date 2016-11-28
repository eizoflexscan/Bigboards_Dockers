# R tint on Bigboards
===============================


This repository contains the necessary files for setting up a Hadoop, Spark, Rstudio & Shiny containerized application up and running on a [Bigboard](www.bigboards.io).

No prior knowledge of containers or Docker is necessary, but it assumed that your cluster is linked to the Hive http://docs.bigboards.io/en/latest/gettingstarted/. 

## Load the existing R-tint
There is a publicly open tint, called 'R tint'. From your hive, dubble click on it to install....
To Be done!!!


## Customize your own tint

Short desciption of each repository. Browse in each repository and read the 'Readme file' for more details.

### bb-stack-spark-on-hadoop-master


### docker-rstudio-server-master
#### Description
[RStudio](https://www.rstudio.com/products/rstudio/)RStudio is an integrated development environment (IDE) for R. It includes a console, syntax-highlighting editor that supports direct code execution, as well as tools for plotting, history, debugging and workspace management. 
#### Version
Rstudio Server Open Source Edition
#### Port
Access on port 8787
#### Users & Passwords

### docker-r-shiny-master
#### Description
[Shiny](https://www.rstudio.com/products/shiny/) is an open source R package that provides an elegant and powerful web framework for building web applications using R. Shiny helps you turn your analyses into interactive web applications without requiring HTML, CSS, or JavaScript knowledge.
Note that shiny is here combined with [ShinyProxy](http://www.shinyproxy.io/) wih as a built-in functionality for LDAP authentication and authorization.

#### Version
Shiny package and ShinyProxy 
#### Port
Access on port 3838
#### Users & Passwords
- name: jack &password: password
- name: jeff & password: password


### docker-Application1-master & docker-Application2-master
#### Description
This repository provides a template to deploy your own Shiny apps on ShinyProxy. Full explanation on the contents of this repository is offered at http://www.shinyproxy.io/deploying-apps/

#### Version
Shiny package and ShinyProxy 
#### Port
Access on port 3838
#### Users & Passwords
- name: jack &password: password
- name: jeff & password: password
