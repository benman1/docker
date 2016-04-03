# start with the latest ubuntu
FROM ubuntu:latest

MAINTAINER Ben Auffarth

ENV DEBIAN_FRONTEND noninteractive
#RUN sed -i 's/exit 101/exit 0/' /usr/sbin/policy-rc.d
#
# Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# echo "libpam-systemd:amd64" | dpkg --set-selections &&
# some system packages
RUN apt-get update -qq && apt-get dist-upgrade -y && \
    apt-get install -y screen curl aptitude software-properties-common libc6 openjdk-7-* \
	libmyodbc libodbc1 odbc-postgresql odbcinst tdsodbc unixodbc unixodbc-dev odbcinst1debian2 \
	libcurl4-openssl-dev libpq-dev build-essential gcc g++ gfortran libblas-dev liblapack-dev \
	libffi-dev libfreetype6-dev libxft-dev && \
	add-apt-repository "deb http://cran.rstudio.com/bin/linux/ubuntu $(lsb_release -cs)/" && \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 && \
	apt-get update -qq && apt-get dist-upgrade -y && \
	apt-get install -y r-base r-base-dev r-recommended littler vim less wget \
	r-cran-rodbc r-cran-xml r-cran-rcurl r-cran-rmysql \
	r-cran-boot r-cran-class r-cran-cluster r-cran-codetools \
	r-cran-foreign r-cran-kernsmooth r-cran-lattice r-cran-mass \
	r-cran-matrix r-cran-mgcv r-cran-nlme r-cran-nnet \
	r-cran-rpart r-cran-spatial r-cran-survival r-cran-rjava \
	texlive-full \
	&& apt-get install -y --no-install-recommends \
	libpam-systemd:amd64 ed less locales \
	vim-tiny wget ca-certificates python-setuptools git \
	supervisor libedit2 \
	&& rm -rf /var/lib/apt/lists/* \
	&& apt-get install -y sudo libcurl3 file libapparmor1 \
	libssl-dev psmisc libcurl4-openssl-dev libssl1.0.0 \
	&& VER=$(wget --no-check-certificate -qO- https://s3.amazonaws.com/rstudio-server/current.ver) \
	&& wget -q http://download2.rstudio.org/rstudio-server-${VER}-amd64.deb \
	&& dpkg -i rstudio-server-${VER}-amd64.deb \
	&& rm rstudio-server-*-amd64.deb \
	&& ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin \
	&& ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin \
	&& wget https://github.com/jgm/pandoc-templates/archive/1.15.0.6.tar.gz \
	&& mkdir -p /opt/pandoc/templates && tar zxf 1.15.0.6.tar.gz \
	&& cp -r pandoc-templates*/* /opt/pandoc/templates && rm -rf pandoc-templates* \
	&& mkdir /root/.pandoc && ln -s /opt/pandoc/templates /root/.pandoc/templates \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/ \
	$(aptitude search -F '%p' cran)

RUN useradd docker \
	&& mkdir /home/docker \
	&& chown docker:docker /home/docker \
	&& addgroup docker staff

## Ensure that if both httr and httpuv are installed downstream, oauth 2.0 flows still work correctly.
RUN echo '\n\
\n# Configure httr to perform out-of-band authentication if HTTR_LOCALHOST \
\n# is not set since a redirect to localhost may not work depending upon \
\n# where this Docker container is running. \
\nif(is.na(Sys.getenv("HTTR_LOCALHOST", unset=NA))) { \
\n  options(httr_oob_default = TRUE) \
\n}' >> /etc/R/Rprofile.site

## A default user system configuration. For historical reasons,
## we want user to be 'rstudio', but it is 'docker' in r-base
RUN usermod -l rstudio docker \
  && usermod -m -d /home/rstudio rstudio \
  && groupmod -n rstudio docker \
  && git config --system user.name rstudio \
  && git config --system user.email rstudio@example.com \
  && git config --system push.default simple \
  && echo '"\e[5~": history-search-backward' >> /etc/inputrc \
  && echo '"\e[6~": history-search-backward' >> /etc/inputrc \
  && echo "rstudio:rstudio" | chpasswd

# ODBC
ADD *.ini /etc/

# R packages
ADD packages.R /tmp/packages.R
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile
RUN Rscript /tmp/packages.R


## User config and supervisord for persistant RStudio session
COPY userconf.sh /usr/bin/userconf.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /var/log/supervisor \
  && chgrp staff /var/log/supervisor \
  && chmod g+w /var/log/supervisor \
  && chgrp staff /etc/supervisor/conf.d/supervisord.conf
	

EXPOSE 8787

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
