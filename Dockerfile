FROM rdomloge/react-build 

WORKDIR /adminwebsite

COPY react .
RUN rm -r node_modules
RUN npm i
RUN npm run build
CMD [ "npm", "run", "start" ]