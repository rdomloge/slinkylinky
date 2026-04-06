FROM --platform=$BUILDPLATFORM azul/zulu-openjdk:17 AS extract
COPY target/audit.jar app.jar
RUN java -Djarmode=layertools -jar app.jar extract --destination extracted

FROM azul/zulu-openjdk:17
EXPOSE 8080
WORKDIR /app
COPY --from=extract extracted/dependencies/ ./
COPY --from=extract extracted/spring-boot-loader/ ./
COPY --from=extract extracted/snapshot-dependencies/ ./
COPY --from=extract extracted/application/ ./
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS org.springframework.boot.loader.launch.JarLauncher"]
