FROM node:19-alpine
ENV NODE_ENV=production

WORKDIR /app

COPY ["package.json", "yarn.lock", "app.js", "./"]

RUN yarn install --production

COPY server.js .

EXPOSE 8080

CMD [ "node", "server.js" ]
