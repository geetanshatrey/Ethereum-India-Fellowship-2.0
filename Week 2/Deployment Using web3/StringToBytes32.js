const ethers = require('ethers')
const utils = ethers.utils
const inBytes = utils.formatBytes32String("I am the one who knocks");
console.log(inBytes);
