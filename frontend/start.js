'use strict';


const _execSync = require('child_process').execSync;
const fs = require('fs');

const execSync = (cmd, a) => {
    try {
        return _execSync(cmd, a);
    } catch (e) {
        if (e.status !== 0) {
            process.exit(0);
        }
    }
};


process.chdir('./frontend');


if (!fs.existsSync('./node_modules/')) {
    execSync('npm install');
}

execSync('rm -rf ./dist');
execSync('node ./node_modules/typescript/bin/tsc', {stdio: [0, 1, 2]});
execSync('node ./node_modules/webpack/bin/webpack.js', {stdio: [0, 1, 2]});


