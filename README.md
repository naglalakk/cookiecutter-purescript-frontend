cookiecutter-purescript-frontend
================================

Cookiecutter for scaffolding a fresh purecsript frontend. The structure of the project generated is borrowed directly from tomashoneyman [Real World Halogen](https://github.com/thomashoneyman/purescript-halogen-realworld) which is a really good reference for how to structure a Halogen project. 

**Version**

This is a cookiecutter for projects using Halogen version 6 with Purescript >= 0.15.4

Older branches

* [Halogen v5 branch](https://github.com/naglalakk/cookiecutter-purescript-frontend/tree/v5)
* [Halogen v4 branch](https://github.com/naglalakk/cookiecutter-purescript-frontend/tree/v4). 

Do note that these branches are stale and not being maintained anymore.

Includes

* Package management using [Spago](https://github.com/spacchetti/spago)
* [purescript-express](https://github.com/nkly/purescript-express) running a node server
* Bundling with [esbuild](https://esbuild.github.io/)
* A simple ready-to-use [Halogen](https://github.com/slamdata/purescript-halogen) component
* npm scripts for common tasks

### Other useful packages included

* [halogen-formless](https://github.com/thomashoneyman/purescript-halogen-formless)
  : Halogen Formless for dealing with forms

* [halogen-select](https://github.com/citizennet/purescript-halogen-select)
  : Halogen Select for selection interfaces

* [purescript-css](https://github.com/slamdata/purescript-css)
  : CSS library for CSS-in-Purescript


### Requirements

* [Cookiecutter](https://github.com/audreyr/cookiecutter)
* [Purescript](https://github.com/purescript/purescript)
* [Spago](https://github.com/spacchetti/spago)
* [npm](https://www.npmjs.com/)
* [esbuild](https://esbuild.github.io/)

### Usage

    cookiecutter https://github.com/naglalakk/cookiecutter-purescript-frontend

This will ask you about the name of your project and version number.

Once you have generated your project with cookiecutter you can start by running install for all dependencies with

    spago install && npm i

This will install dependencies for Purescript with Spago and then install the js dependencies needed for the server ( express and pug )

This project includes scripts with a few common tasks:

* dev     - Run a dev server on port 8080
* bundle  - Bundle js files with esbuild
* style   - Process SCSS files
* docs    - Generate docs from ./spago and ./src folders
* test    - Runs tests for Purescript code
* clean   - Clean up generated output (e.g. docs, build etc)

Once you have installed everything you can run

    npm run dev

This will run a development server on port :8080

### Environment variables

Environment variables can be included in a .env file, located
at the root of the project.

#### Environment variables included

**PORTNR**

The port number the server will be running on.  Default: 8080

**ENVIRONMENT**

Environment to run in. Default: Development

**API_URL**

Your custom API URL for backend requests

**API_TOKEN**

Custom authentication API_TOKEN. Only applies if you're using a backend API with a Bearer Authorization scheme.

**API_USERNAME**

Custom username for Basic authentication. Only applies if you're using a backend API with a Basic Authorization scheme.

**API_USERPASS**

Custom password for Basic authentication. Only applies if you're using a backend API with a Basic Authorization scheme.

### Structure

* Purescript code                  -> ./src
* Static files (html, css, images) -> ./static
* Purescript tests                 -> ./test
