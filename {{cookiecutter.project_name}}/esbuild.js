#!/usr/bin/env node

import {config} from 'dotenv'
import {build} from 'esbuild'

config()
var envVars = {}

Object.keys(process.env).forEach(function(key) {
  envVars[`process.env.${key}`] = JSON.stringify(process.env[key])
});

build({
    entryPoints: ['static/build/index.js'],
    bundle: true,
    minify: true,
    sourcemap: true,
    outfile: 'static/dist/index.js',
    define: envVars
});
