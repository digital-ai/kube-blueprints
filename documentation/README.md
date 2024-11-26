# Website

This website is built using [Docusaurus 2](https://docusaurus.io/), a modern static website generator.

### Installation

```
$ yarn
```

### Generate Blueprints Documentation
```
cd scripts/js
yarn install
yarn run generate-blueprint-docs
```

This command generates the blueprint documentation in `documentation/docs` directory for serving static contents. And should be run before running build for documentation site. 

** Note: ** This is also incorporated in the gradle build process.

### To format new code
```
yarn run lint
yarn run format
```

### Local Development

```
$ yarn start
```

This command starts a local development server and opens up a browser window. Most changes are reflected live without having to restart the server.

### Build

```
$ yarn build
```

This command generates static content into the `build` directory and can be served using any static contents hosting service.

### Deployment

```
$ GIT_USER=<Your GitHub username> USE_SSH=true yarn deploy
```

If you are using GitHub pages for hosting, this command is a convenient way to build the website and push to the `gh-pages` branch.
