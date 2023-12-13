FROM node:current-slim

WORKDIR /adminwebsite

COPY react .
RUN npm i
RUN npm run build
CMD [ "npm", "run", "start" ]