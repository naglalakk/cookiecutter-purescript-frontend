{{ cookiecutter.project_name }}
===

### Requirements

* [Purescript](https://github.com/purescript/purescript)
* [Spago](https://github.com/spacchetti/spago)
* [npm](https://www.npmjs.com/)
* [esbuild](https://esbuild.github.io/) 

### Installation

Once all the requirements are installed run

    spago install && npm i

### Commands

This project includes a few script commands located in package.json

* build   - Builds code from src
* dev     - Run a dev server on port 8080
* clean   - Clean up generated output (e.g. docs, build etc)
* docs    - Generate docs from ./spago and ./src folders
* test    - Runs tests for Purescript code

### Environment variables

Environment variables can be included in a .env file.

A .env.example is located at the root of this project. You can start using it
by running 

    cp .env.example .env

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


