# Demo app - Developing with Docker

A minimal Node.js/Express profile editor with a vanilla JS frontend that persists profile updates to MongoDB. The project is intended for practicing containerization and Compose orchestration.

## Repository layout
- `app/server.js` Express server exposing `/get-profile` and `/update-profile`
- `app/index.html` static profile editor that calls the API and shows a sample avatar from `/profile-picture`
- `app/utils.js` reusable helpers with accompanying tests
- `Dockerfile` to build the application image
- `docker-compose.yaml` to run the app with MongoDB and mongo-express

## Prerequisites
- Docker and Docker Compose
- Node.js (18+) and npm if you want to run outside containers
- A running MongoDB instance (the code defaults to `mongodb://admin:password@localhost:27017` and uses database `my-db`/collection `users`)

## Run locally (without Docker)
1) Start MongoDB locally or via Docker:

```sh
docker run -d -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=password \
  --name mongodb mongo
```

2) (Optional) Point the app at a different Mongo instance:

```sh
export MONGO_URL="mongodb://<user>:<pass>@<host>:27017"
```

3) Install and start the app:

```sh
cd app
npm install
npm start
```

4) Open the UI at http://localhost:3000 and edit the profile. The database and collection are created automatically on first update.

## Run with Docker (manual containers)
1) Create a network (optional but keeps names predictable):

```sh
docker network create mongo-network
```

2) Start MongoDB:

```sh
docker run -d -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=password \
  --name mongodb --net mongo-network mongo
```

3) Start mongo-express:

```sh
docker run -d -p 8081:8081 \
  -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \
  -e ME_CONFIG_MONGODB_ADMINPASSWORD=password \
  -e ME_CONFIG_MONGODB_SERVER=mongodb \
  --net mongo-network --name mongo-express mongo-express
```

4) (Optional) Use mongo-express at http://localhost:8081 to inspect the `my-db` database and `users` collection the app writes to.

5) Build and run the Node.js app image:

```sh
docker build -t local/my-app:1.0 .
docker run -d -p 3000:3000 --net mongo-network -e MONGO_URL="mongodb://admin:password@mongodb:27017" local/my-app:1.0
```

6) Open http://localhost:3000 to use the app.

## Run with Docker Compose
1) Set environment values used by `docker-compose.yaml`:

```sh
export MONGO_USERNAME=admin
export MONGO_PASSWORD=password
export DOCKER_REGISTRY=local
```

2) Build the app image so Compose can pull it locally:

```sh
docker build -t ${DOCKER_REGISTRY}/my-app:1.0 .
```

3) Start the stack:

```sh
docker-compose -f docker-compose.yaml up
```

- App: http://localhost:3000
- mongo-express: http://localhost:8080 (log in with the values above)

4) In mongo-express, create database `my-db` and collection `users` if you want to browse documents. The app will upsert into them automatically when you submit the form.

## Tests and linting
Run from the `app` directory:

```sh
npm test   # Jest unit + integration tests
npm run lint
```

## API endpoints
- `GET /get-profile` – fetch the stored profile (empty object if none)
- `POST /update-profile` – save profile data (upserts userid 1)
- `GET /profile-picture` – serves the demo avatar image

The server reads `MONGO_URL` for the connection string; otherwise it defaults to `mongodb://admin:password@localhost:27017`.
