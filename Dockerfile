## R 4.6.2 + RStudio Server + tidyverse + Pandoc + Quarto + TeX Live (TinyTeX-style)
FROM rocker/verse:4.6.2

## Binder runs the image as a non-root user with UID 1000 (= "rstudio" in rocker images)
ENV NB_USER=rstudio
ENV VIRTUAL_ENV=/opt/venv
ENV PATH=${VIRTUAL_ENV}/bin:${PATH}
ENV DEBIAN_FRONTEND=noninteractive

USER root

## Jupyter + jupyter-rsession-proxy, so Binder can start RStudio (?urlpath=rstudio)
RUN /rocker_scripts/install_jupyter.sh

## System packages listed in apt.txt
COPY apt.txt /tmp/apt.txt
RUN apt-get update \
    && xargs -a /tmp/apt.txt apt-get install --yes --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/apt.txt

## LaTeX packages for German PDF output (baked into the image, not downloaded per session)
RUN tlmgr install babel-german hyphen-german

USER ${NB_USER}
WORKDIR /home/${NB_USER}

## R packages (copied first so this layer is cached when only course files change)
COPY --chown=${NB_USER} install.R /tmp/install.R
RUN R --quiet -f /tmp/install.R

## Course material
COPY --chown=${NB_USER} . /home/${NB_USER}

EXPOSE 8888
CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--no-browser"]
