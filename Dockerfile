FROM node:23


WORKDIR /var/task

ENV UV_THREADPOOL_SIZE 64
ENV NODE_ENV production

RUN npm -g install pm2

COPY ./src/package.json ./
RUN npm install
RUN npm cache clean --force

COPY ./src ./

CMD ["pm2-runtime","ecosystem.config.js"]
