FROM node:19-alpine
ENV NODE_ENV=production

WORKDIR /app

COPY ["nodejs/package.json", "nodejs/yarn.lock", "nodejs/app.js", "./"]

RUN yarn install --production

COPY nodejs/server.js .
COPY ../hello-world.json /

EXPOSE 8080

CMD [ "node", "server.js" ]
