# kuzu-ui
Browser-based user interface for Kùzu graph database.

## Get start
To start the web application from the deployed Docker image, run the following command:
```bash
docker run -p 8000:8000 \
           -v {database path}:/database \
           --rm kuzudb/kuzu-ui:latest
```
Note that the `-v` flag is optional. If no database path is specified, the server will be started with an empty database. 
There is an option to load the database with bundled datasets to explore the basic functionalities of Kùzu.

Additionally, a directory containing data files, such as parquet, csv, and npy files can be mounted to the `/data` directory
in the container via `-v {path to additional data files}:/data`, so that the data files can be accessed inside the web application.



## Development (with Kùzu compiled from source)
### Stack
- Server
  - [Node.js](https://nodejs.org)
  - [Express.js](https://expressjs.com/)
  - [Kùzu](https://kuzudb.com)
- Client
  - [Vue 3](https://vuejs.org/)
  - [Bootstrap 5](https://getbootstrap.com/docs/5.0/)
  - [Monaco Editor](https://microsoft.github.io/monaco-editor/)
  - [G6](https://github.com/antvis/G6)

### Prerequisite
- [Node.js v20](https://nodejs.org/dist/latest-v20.x/)
- [JDK 11+](https://jdk.java.net/11/)
- [Toolchain for building Kùzu](https://kuzudb.com/docusaurus/development/building-kuzu)

### Environment setup
#### Download and compile Kùzu
```bash
git submodule update --init --recursive
npm run build-kuzu 
```

#### Install Node.js dependencies
```bash
npm i
```

#### Generate grammar files
```bash
npm run generate-grammar
```

### Run development server (with hot-reloading)
```
env KUZU_PATH={path to database file} npm run serve
```

## Build and serve for production
### Run production server locally
```bash
npm run build
env KUZU_PATH={path to database file} npm run serve-prod
```

### Run production server with Docker
```
docker build -t kuzudb/kuzu-ui:latest .
docker run -p 8000:8000 \
           -v {database path}:/database \
           --rm kuzudb/kuzu-ui:latest
```

## Deployment
A [GitHub actions pipeline](.github/workflows/build-and-deploy.yml) has been configured to automatically build and deploy 
the Docker image to [Docker Hub](https://hub.docker.com/) upon pushing to the master branch. The pipeline will build images
for both `amd64` and `arm64` platforms.

## Contributing
We welcome contributions to kuzu-ui. By contributing to kuzu-ui, you agree that your contributions will be licensed under the [MIT License](LICENSE).
