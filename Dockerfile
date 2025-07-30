FROM --platform=$BUILDPLATFORM node:22 as adminsite_base

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



FROM --platform=amd64 node:alpine AS final-amd64
COPY --from=adminsite_build /adminwebsite /adminwebsite

FROM --platform=arm64 node:alpine AS final-arm64
COPY --from=adminsite_build /adminwebsite /adminwebsite



FROM final-${TARGETARCH}
WORKDIR /adminwebsite
CMD [ "npm", "run", "start" ]