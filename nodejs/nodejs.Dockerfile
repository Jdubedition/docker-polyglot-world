FROM node:19-alpine
ENV NODE_ENV=production

WORKDIR /app

COPY ["package.json", "package-lock.json*", "./"]

RUN npm ci --production

COPY server.js .

EXPOSE 8080

CMD [ "node", "server.js" ]
