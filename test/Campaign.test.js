const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const {abi, evm} = require('../compile');

const web3 = new Web3(ganache.provider());

let accounts;
let campaign;
let admin;

beforeEach( async () => {
  accounts = await web3.eth.getAccounts();

  admin = accounts[0];
  campaign = await new web3.eth.Contract(abi)
                          .deploy({data: evm.bytecode.object, arguments: [100]})
                          .send({gas: 2000000, from: admin});

});

/*describe('Campaign Contract', () => {
  it('Deploys a contract', () => {
    assert.ok(campaign.options.address);
  });
});
*/

describe('getBalance', () => {
  it('Balance Check', async () => {
    assert.ok(campaign.options.address);
  });
});
