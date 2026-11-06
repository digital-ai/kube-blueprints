# Website

This website is built using [Docusaurus 3](https://docusaurus.io/), a modern static website generator.

### Installation

```
$ yarn
```

### Updating dependency lockfiles

Use the Node and Yarn versions pinned in `gradle.properties`.
After editing `documentation/package.json` or
`documentation/scripts/js/package.json`, run from the repository root:

```sh
./gradlew yarn_install yarnInstallJsScripts
```

These tasks install dependencies and update `documentation/yarn.lock` and
`documentation/scripts/js/yarn.lock`. The scripts package is in `scripts/js`,
not directly in `scripts`.

To refresh every dependency allowed by the existing semver ranges, rather than
only resolving manifest changes, run from the repository root:

```sh
(cd documentation && yarn upgrade --ignore-scripts)
(cd documentation/scripts/js && yarn upgrade --ignore-scripts)
```

Since the site also tracks an npm v2 lockfile. With Node and npm on your PATH, synchronize separately:
```sh
```
(cd documentation && npm update --package-lock-only --ignore-scripts --lockfile-verion=2 --no-audit --no-fund)
```

```
Run `yarn install` in the relevant directory first if `yarn upgrade` reports an
outdated lockfile. Yarn and npm maintain separate dependency resolutions; retain
and review all three tracked lockfiles. Do not generate an additional npm
lockfile for `scripts/js`, which uses Yarn.

Verify the updated Yarn locks and build from the repository root:

```sh
(cd documentation && yarn install --frozen-lockfile)
(cd documentation/scripts/js && yarn install --frozen-lockfile)
./gradlew yarnRunBuild
git diff -- documentation/package.json documentation/yarn.lock documentation/package-lock.json documentation/scripts/js/package.json documentation/scripts/js/yarn.lock
```

### Generate Blueprints Documentation
From the repository root, use the Gradle-managed Node and Yarn versions:

```sh
./gradlew yarnRunBuildBlueprintDocs
```

Or, with Node and Yarn on your `PATH`, run from `documentation/`:

```sh
cd scripts/js
yarn install
yarn run generate-blueprint-docs
```

These commands generate `documentation/docs/blueprint.md` from `xl-infra/blueprint.yaml`
and `xl-op/blueprint.yaml`. The existing generator discovers the repository by
looking for an ancestor directory named `kube-blueprints`, so the checkout
directory must have that name. A differently named worktree beneath a
`kube-blueprints` directory can instead select that parent and print
`No blueprint.yaml files found.` without generating documentation.

The Gradle task `yarnRunBuild` also runs blueprint documentation generation.
Generate the documentation before starting the development server.

### To format new code
```
yarn run lint
yarn run format
```

### Local Development

From the repository root:

```sh
./gradlew yarnRunStart
```

Or, from `documentation/`, after generating the blueprint documentation:

```
$ yarn start
```

This command starts a local development server and opens up a browser window. Most changes are reflected live without having to restart the server.
Use the URL printed by Docusaurus, normally
`http://localhost:3000/kube-blueprints/`. The generated parameters page is at
`http://localhost:3000/kube-blueprints/docs/blueprint`. Press Ctrl+C to stop.

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
