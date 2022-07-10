#!/usr/bin/env node

require('dotenv').config()

var envVars = {}

Object.keys(process.env).forEach(function(key) {
  envVars[`process.env.${key}`] = JSON.stringify(process.env[key])
});

require('esbuild').build({
    entryPoints: ['static/build/index.js'],
    bundle: true,
    minify: true,
    sourcemap: true,
    outfile: 'static/dist/index.js',
    define: envVars
});
