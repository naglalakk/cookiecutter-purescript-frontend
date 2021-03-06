cookiecutter-purescript-frontend
================================

Cookiecutter for scaffolding a fresh purecsript frontend including. The structure of the project generated is borrowed directly from tomashoneyman [Real World Halogen](https://github.com/thomashoneyman/purescript-halogen-realworld) which is a really good reference for how to structure a Halogen project. 

*Note*

This is a cookiecutter for projects using Halogen version 5 with Purescript >= 0.13
If you are looking for Halogen-4 check out the [v4 branch](https://github.com/naglalakk/cookiecutter-purescript-frontend/tree/v4). Do note that this
branch is stale and not being maintained anymore.

Including

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
* [Parcel](https://parceljs.org) 

### Usage

    cookiecutter https://github.com/naglalakk/cookiecutter-purescript-frontend

This will ask you a couple of question like the name of your project, the
version and if you want to include a user authentication setup (on by
default).

Once you have generated your project with cookiecutter you can start by running install for all dependencies with

    make install

This will install dependencies for Purescript with Spago and then install the js dependencies needed for the server ( express and pug )

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

**API_URL**

The URL of the API service being used with your generated frontend

**API_KEY**

Only applies if user == "y" in your cookiecutter settings. This is a base64
encoded string ( base64(username:password) )

### Structure

* Purescript code                  -> ./src
* Static files (html, css, images) -> ./static
* Purescript tests                 -> ./test
