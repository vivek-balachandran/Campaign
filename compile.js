const path = require('path');
const fs = require('fs');
const solc = require('solc');

const campaignPath = path.resolve(__dirname, 'contracts', 'Campaign.sol');
const source = fs.readFileSync(campaignPath, 'utf8');

const input = {
  language: 'Solidity',
  sources: {
    'Campaign.sol': {
      content: source
    }
  },
  settings: {
    outputSelection: {
      '*': {
        '*': ['*']
      }
    }
  }
};

const compiledCode = solc.compile(JSON.stringify(input));
module.exports = JSON.parse(compiledCode).contracts['Campaign.sol'].Campaign;
