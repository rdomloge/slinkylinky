FROM --platform=$BUILDPLATFORM node:22 AS adminsite_base

WORKDIR /adminwebsite

# Copy the entire project, ignoring node_modules (which is specified in .dockerignore)
COPY react/package.json .
COPY react/package-lock.json .
# Install dependencies
RUN npm ci

FROM --platform=$BUILDPLATFORM adminsite_base AS adminsite_build
COPY react .
# Build the project
RUN npm run build



FROM nginx:alpine AS final

# Copy the built static files from the Vite build
COPY --from=adminsite_build /adminwebsite/dist /usr/share/nginx/html

# SPA routing: serve index.html for all routes not matching a static file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Entrypoint generates /usr/share/nginx/html/config.js from env vars at startup
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
