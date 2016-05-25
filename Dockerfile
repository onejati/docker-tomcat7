FROM java:8u92-jre-alpine

RUN apk add --update curl ca-certificates

#Change number below to install different versions
ENV TOMCAT_VERSION=7.0.69

RUN curl \
  --silent \
  --location \
  --retry 3 \
  --cacert /etc/ssl/certs/ca-certificates.crt \
  "https://archive.apache.org/dist/tomcat/tomcat-7/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" \
    | gunzip \
    | tar x -C /usr/ \
    && mv /usr/apache-tomcat* /usr/tomcat \
    && rm -rf /usr/tomcat/webapps/examples /usr/tomcat/webapps/docs

# SET CATALINA_HOME and PATH
ENV CATALINA_HOME /usr/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

#Expose port
EXPOSE 8080

# override ENTRYPOINT defined in alpine/openjdk7.
ENTRYPOINT [ "/bin/sh", "-c" ]
CMD ["/bin/sh -e /usr/tomcat/bin/catalina.sh run"]
