FROM ubuntu
MAINTAINER Rodrigo Emerenciano <rodrigo.emereciano@gmail.com>


ENV WILDFLY_VERSION wildfly-9.0.2.Final.tar.gz
ENV JDK_VERSION jdk-8u65-linux-x64.tar.gz
ENV app car-service.war
ENV WILDFLY_PASTA wildfly-9.0.2.Final 
ENV JDK_PASTA jdk1.8.0_65

RUN mkdir /opt/wildfly
RUN cd /opt/wildfly
ADD ["http://download.jboss.org/wildfly/9.0.2.Final/$WILDFLY_VERSION","/opt/wildfly"]
WORKDIR /opt/wildfly/
RUN tar -zxf /opt/wildfly/$WILDFLY_VERSION


RUN cd /opt/wildfly/$WILDFLY_PASTA/standalone/deployments/
ADD ["https://s3-us-west-2.amazonaws.com/elasticbeanstalk-us-west-2-665999995121/docker/car-service.war","/opt/wildfly/$WILDFLY_PASTA/standalone/deployments/$app"]


RUN mkdir /opt/java
ADD ["https://s3-us-west-2.amazonaws.com/elasticbeanstalk-us-west-2-665999995121/docker/$JDK_VERSION","/opt/java"]
WORKDIR /opt/java/
RUN tar -zxf $JDK_VERSION 


RUN update-alternatives --install /usr/bin/javac javac /opt/java/$JDK_PASTA/bin/javac 100

RUN update-alternatives --install /usr/bin/java java /opt/java/$JDK_PASTA/bin/java 100

RUN update-alternatives --display java 


RUN java -version

EXPOSE 8080 9990



CMD ["/opt/wildfly/wildfly-9.0.2.Final/bin/standalone.sh", "-c", "standalone-full.xml", "-b", "0.0.0.0"]
