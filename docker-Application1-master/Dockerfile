FROM eizoflexscan/docker-r-shiny-master

MAINTAINER Tobias Verbeke "tobias.verbeke@openanalytics.eu"

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl1.0.0

# system library dependency for the euler app
RUN apt-get update && apt-get install -y \
    libmpfr-dev

# basic shiny functionality
RUN R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cloud.r-project.org/')"

# install dependencies of the app1
RUN R -e "install.packages(c('shinydashboard', 'ggplot2', 'RcolorBrewer', 'data.table', 'DMwR', 'outliers','caret', 'lars', 'editrules', 'kohonen', 'dbscan', 'abodOutlier'), repos='https://cloud.r-project.org/')"

# copy the app to the image
RUN mkdir /root/app1
COPY euler /root/app1

COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e shiny::runApp('/root/app1')"]
