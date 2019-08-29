cookiecutter-purescript-frontend
================================

[![Codeship Status for naglalakk/cookiecutter-purescript-frontend](https://app.codeship.com/projects/21ebe630-ac2a-0137-40b9-3ef406672b9a/status?branch=master)](https://app.codeship.com/projects/362177)

Cookiecutter for scaffolding a fresh purecsript frontend including. The structure of the project generated is borrowed directly from tomashoneyman [Real World Halogen](https://github.com/thomashoneyman/purescript-halogen-realworld) which is a really good reference for how to structure a Halogen project. 

* Package management using [Spago](https://github.com/spacchetti/spago)
* [purescript-express](https://github.com/nkly/purescript-express) running a node server
* Bundling with [Parcel](https://parceljs.org)
* A simple ready-to-use [Halogen](https://github.com/slamdata/purescript-halogen) component
* Makefile for common tasks

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
* npm or yarn

**Optional** (Bundling/Server will not work unless you swap this out)

* [Parcel](https://parceljs.org) 

### Usage

    cookiecutter https://github.com/naglalakk/cookiecutter-purescript-frontend

Once you have generated your project with cookiecutter you can start by running install for all dependencies with

    make install

This will install dependencies for Purescript with Spago and then install the js dependencies needed for the server (express and pug )

This project includes a Makefile with a few common tasks:

* build   - Builds code from src
* bundle  - Bundle code from src to commonjs format
* browser - Make a browser compatible js bundle
* clean   - Clean up generated output (e.g. docs)
* docs    - Generate docs from ./spago and ./src folders
* install - Install all dependencies
* server  - Starts development server on port 8080
* test    - Runs tests for Purescript code

The default package manager set for this project is yarn.
You can change this by editing the PCK_MANAGER variable in the Makefile

Feel free to edit the Makefile or simply drop it. It's mostly there for demonstration purpose on how to use spago with Purescript

Once you have installed everything you can run

    make bundle && make server

This will build the purescript code, create a bundle in commonjs and start the development server on localhost port 8080
Now you should be able to navigate to localhost:8080 in your browser and see a button which says "Off". If you click it will turn On.

### Environment variables

Environment variables can be included in a .env file .e.g

    echo "PORTNR=8081" > .env

**PORTNR**

Sets the port for the server (defaults to 8080)

### Structure

* Purescript code              -> ./src
* Static files (html/pug, css) -> ./static
* Purescript tests             -> ./test
