FROM node:24.15.0-alpine3.22 AS build

WORKDIR /usr/src/app

COPY  package.json yarn.lock ./
RUN yarn

COPY . .

RUN yarn run build
RUN yarn --production && yarn cache clean

FROM node:24.15.0-alpine3.22

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

EXPOSE 3000

CMD ["yarn", "run", "start:prod"]