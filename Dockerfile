FROM --platform=$BUILDPLATFORM node:alpine as adminsite_base

WORKDIR /adminwebsite

COPY react .
RUN npm ci

FROM --platform=$BUILDPLATFORM adminsite_base as adminsite_build
RUN npm run build




FROM --platform=amd64 node:alpine AS final-amd64
COPY --from=adminsite_build /adminwebsite /adminwebsite

FROM --platform=arm64 node:alpine AS final-arm64
COPY --from=adminsite_build /adminwebsite /adminwebsite



FROM final-${TARGETARCH}
WORKDIR /adminwebsite
CMD [ "npm", "run", "start" ]