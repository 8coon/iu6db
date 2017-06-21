'use strict';


const execSync = require('child_process').execSync;
const fs = require('fs');


process.chdir('./frontend');


execSync('rm -rf ./dist');
execSync('node ./node_modules/typescript/bin/tsc', {stdio: [0, 1, 2]});
execSync('node ./node_modules/webpack/bin/webpack.js', {stdio: [0, 1, 2]});


