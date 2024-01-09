FROM azul/zulu-openjdk:17

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar supplierengagement.jar"]

COPY target/supplierengagement.jar supplierengagement.jar