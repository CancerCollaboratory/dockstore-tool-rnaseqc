FROM java:7-jdk

MAINTAINER John Vivian, jtvivian@gmail.com

RUN mkdir /opt/rnaseqc
RUN mkdir /data
VOLUME ["/data"]

WORKDIR /opt/rnaseqc
RUN wget http://www.broadinstitute.org/cancer/cga/tools/rnaseqc/RNA-SeQC_v1.1.8.jar

ADD wrapper.sh /opt/rnaseqc/
RUN chmod +x /opt/rnaseqc/wrapper.sh

WORKDIR /data
ENTRYPOINT ["/opt/rnaseqc/wrapper.sh"]

