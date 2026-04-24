FROM --platform=$BUILDPLATFORM azul/zulu-openjdk:17 AS extract
COPY target/supplierengagement.jar app.jar
RUN java -Djarmode=layertools -jar app.jar extract --destination extracted

FROM azul/zulu-openjdk:17-jre
# Install system dependencies for Playwright headless scraping (Playwright manages browser download)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libglib2.0-0 libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 \
    libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 \
    libxfixes3 libxrandr2 libgbm1 libasound2 libpango-1.0-0 \
    libpangocairo-1.0-0 libx11-6 libx11-xcb1 libxcb1 libxext6 \
    fonts-liberation libxcursor1 libgtk-3-0 libcairo-gobject2 libgdk-pixbuf-2.0-0 \
    && rm -rf /var/lib/apt/lists/*
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=0
EXPOSE 8080
WORKDIR /app
COPY --from=extract extracted/dependencies/ ./
COPY --from=extract extracted/spring-boot-loader/ ./
COPY --from=extract extracted/snapshot-dependencies/ ./
COPY --from=extract extracted/application/ ./
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS org.springframework.boot.loader.launch.JarLauncher"]
