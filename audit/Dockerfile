FROM azul/zulu-openjdk:17

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar audit.jar"]

COPY target/audit.jar audit.jar