FROM rocker/tidyverse:4.2.2

# see here: https://rstudio.github.io/renv/articles/docker.html
ENV RENV_VERSION 0.16.0
RUN R -e "install.packages('remotes')"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

WORKDIR /project
# to facilitate caching, we first only copy renv-related files
COPY renv.lock renv.lock
COPY .Rprofile .Rprofile
COPY renv renv

ENV RENV_PATHS_CACHE /project/cache
RUN echo 'options(renv.config.repos.override = c(RSPM = "https://packagemanager.rstudio.com/all/latest"))' >> ".Rprofile"
RUN Rscript -e 'renv::restore()'

# copy the package source
COPY . pkg/

RUN Rscript -e 'devtools::install_local("pkg/")'

ENV R_LIBS_USER /project/renv/library/R-4.2/x86_64-pc-linux-gnu
