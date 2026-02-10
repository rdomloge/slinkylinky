FROM azul/zulu-openjdk:17

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar stats.jar"]

COPY target/stats.jar stats.jar