FROM --platform=$BUILDPLATFORM node:alpine as adminsite_base

WORKDIR /adminwebsite

COPY react .
RUN npm ci

FROM --platform=$BUILDPLATFORM adminsite_base
RUN npm run build
CMD [ "npm", "run", "start" ]



FROM --platform=amd64 node:alpine AS final-amd64
COPY --from=adminsite_base /adminwebsite /adminwebsite

FROM --platform=arm64 node:alpine AS final-arm64
COPY --from=adminsite_base /adminwebsite /adminwebsite



FROM final-${TARGETARCH}