FROM azul/zulu-openjdk:17

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar woocommerce.jar"]

COPY target/woocommerce.jar woocommerce.jar