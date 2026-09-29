FROM ubuntu:latest
RUN apt update
RUN apt install default-jdk -y
ADD https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.60/bin/apache-tomcat-10.1.60.tar.gz .
RUN tar -xvzf apache-tomcat-10.1.60.tar.gz
RUN mkdir /opt/tomcat
RUN mv /apache-tomcat-10.1.60/* /opt/tomcat
COPY ./sample.war /opt/tomcat/webapps/
EXPOSE 8080
WORKDIR /opt/tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]