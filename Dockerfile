FROM node:22-alpine

# set default dir so that next commands executes in /home/app dir
WORKDIR /home/app

# copy package files first for better layer caching
COPY ./app/package*.json ./

# will execute npm install in /home/app because of WORKDIR
# this layer is cached unless package.json changes
RUN npm install

# copy the rest of the application code
COPY ./app ./

# no need for /home/app/server.js because of WORKDIR
CMD ["node", "server.js"]
