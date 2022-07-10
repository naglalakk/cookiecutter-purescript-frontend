cookiecutter-purescript-frontend
================================

Cookiecutter for scaffolding a fresh purecsript frontend including. The structure of the project generated is borrowed directly from tomashoneyman [Real World Halogen](https://github.com/thomashoneyman/purescript-halogen-realworld) which is a really good reference for how to structure a Halogen project. 

*Note*

This is a cookiecutter for projects using Halogen version 6 with Purescript >= 0.14.7

If you are looking for Halogen-5, check out the [v5
branch](https://github.com/naglalakk/cookiecutter-purescript-frontend/tree/v5)

If you are looking for Halogen-4 check out the [v4 branch](https://github.com/naglalakk/cookiecutter-purescript-frontend/tree/v4). 

Do note that these branches are stale and not being maintained anymore.

Including

* Package management using [Spago](https://github.com/spacchetti/spago)
* [purescript-express](https://github.com/nkly/purescript-express) running a node server
* Bundling with [esbuild](https://esbuild.github.io/)
* A simple ready-to-use [Halogen](https://github.com/slamdata/purescript-halogen) component
* npm scripts for common tasks

### Other useful packages included

**Halogen Formless for dealing with forms**
[halogen-formless](https://github.com/thomashoneyman/purescript-halogen-formless)

**Halogen Select for selection interfaces**
[halogen-select](https://github.com/citizennet/purescript-halogen-select)

**CSS library for CSS-in-Purescript**
[purescript-css](https://github.com/slamdata/purescript-css)


### Requirements

**Required**

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

* build   - Builds code from src
* dev     - Run a dev server on port 8080
* clean   - Clean up generated output (e.g. docs, build etc)
* docs    - Generate docs from ./spago and ./src folders
* test    - Runs tests for Purescript code

Once you have installed everything you can run

    npm run dev

This will run a development server on port :8080

### Environment variables

Environment variables can be included in a .env file .e.g

    echo "PORTNR=8081" > .env

A .env.example is located at the root of this project. You can start using it
by running 

    cp .env.example .env

**PORTNR**

The port number the server will be running on. The default port is 8080

**API_URL**

The API URL for the backend service

**API_KEY**

A base64 encoded authentication string

### Structure

* Purescript code                  -> ./src
* Static files (html, css, images) -> ./static
* Purescript tests                 -> ./test
