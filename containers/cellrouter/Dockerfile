FROM rocker/tidyverse

# most steps are taken from https://github.com/edroaldo/cellrouter
RUN R -e " \
list.of.packages <- c('reshape','reshape2','pheatmap','tsne','igraph','ggplot2','mclust','grid','Rtsne','cccd', 'irlba'); \
new.packages <- list.of.packages[!(list.of.packages %in% rownames(installed.packages()))]; \
if(length(new.packages)) install.packages(new.packages, repos=c('http://cran.rstudio.com/', 'https://bioconductor.org/biocLite.R')); \
"

# get lib
RUN git clone https://github.com/edroaldo/cellrouter.git

# install java
RUN apt-get install -y default-jre

# install feather
RUN R -e "install.packages('feather')"

ADD . /code
ENTRYPOINT Rscript /code/run.R
