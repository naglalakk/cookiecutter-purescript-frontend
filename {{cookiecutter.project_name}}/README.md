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

* dev     - Run a dev server on port 8080
* bundle  - Bundle js files with esbuild
* style   - Process SCSS files
* docs    - Generate docs from ./spago and ./src folders
* test    - Runs tests for Purescript code
* clean   - Clean up generated output (e.g. docs, build etc)

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
