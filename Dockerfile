FROM azul/zulu-openjdk:21-jre

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar linkservice.jar"]

COPY target/linkservice.jar linkservice.jar