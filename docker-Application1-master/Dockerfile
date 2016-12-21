FROM bigboards/java-8-x86_64

MAINTAINER BigBoards <hello@bigboards.io>

# install dependencies
RUN apt-get update && \
	apt-get install -y \
    					gdebi-core \ 
    					libapparmor1 \
                        wget \
                        libcurl4-openssl-dev \ 
                        sudo \
                        pandoc \
                        pandoc-citeproc \
                        libcurl4-gnutls-dev \
                        libcairo2-dev \
                        libxt-dev \
                        libssl-dev \
                        libssh2-1-dev \
                        libssl1.0.0 \
                        libmpfr-dev


# install latest R Base 
RUN codename=$(lsb_release -c -s) && \
	echo "deb http://freestatistics.org/cran/bin/linux/ubuntu $codename/" | tee -a /etc/apt/sources.list > /dev/null && \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 && \
	apt-get update && apt-get install -y r-base r-base-dev


# install R libraries (basic shiny functionality)
RUN R -e 'install.packages(c("devtools","shiny", "rmarkdown"), repos="http://cran.freestatistics.org/", dependencies=NA,clean=TRUE)'  && \
	R -e 'library("devtools"); install_github("mbojan/alluvial")' && \
	R -e 'update.packages(ask=FALSE,repos="http://cran.freestatistics.org/")'


## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
	locale-gen en_US.utf8 && \
	/usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# Basic shiny functionality
RUN R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cloud.r-project.org/')"

# install dependencies of the app1
RUN R -e "install.packages(c('shinydashboard', 'ggplot2', 'RcolorBrewer', 'data.table', 'DMwR', 'outliers','caret', 'lars', 'editrules', 'kohonen', 'dbscan', 'abodOutlier'), repos='https://cloud.r-project.org/')"

# Remove the package list to reduce image size. Note: do this as the last thing of the build process as installs can fail due to this!
# Additional cleanup
RUN apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# copy the app to the image
RUN mkdir /root/app1
COPY app1 /root/app1

COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e shiny::runApp('/root/app1')"]
