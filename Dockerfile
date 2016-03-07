# Guidelines: http://www.projectatomic.io/docs/docker-image-author-guidance/

FROM wnameless/oracle-xe-11g:latest

MAINTAINER frevvo Inc <sysops@frevvo.com>

# RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d # avoid invoke-rc.d: policy-rc.d denied execution of start.
# -----------------------------------------------------------------

ENV DUMP_DIR /dump
ENV DUMP_FILE dump.dmp
ENV TABLE_SPACE_SIZE 100M

ENV ORACLE_HOME /u01/app/oracle/product/11.2.0/xe
ENV PATH $ORACLE_HOME/bin:$PATH
ENV ORACLE_SID XE

ADD files/setup.sh /setup.sh

USER root
RUN apt-get install -y nano
RUN env
RUN chmod +x /*.sh
RUN /setup.sh

VOLUME ${DUMP_DIR}
