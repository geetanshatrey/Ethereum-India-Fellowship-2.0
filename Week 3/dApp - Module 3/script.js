const axios = require('axios');
const prompt = require('prompt-sync')();

var ethID;
var protocolName;
function main() {
    ethID = prompt('Enter your ETH address : ');
    protocolName = prompt('Enter protocol (1 for MakerDAO, 2 for Compound) : ');
    if (protocolName != '1' && protocolName != '2') {
        protocolName = '1';
    }
    if(protocolName == '1') {
        maker();
    }
    if(protocolName == '2') {
        compound();
    }
}

const compound = async () => {
    try {
        const result = await axios.post(
            'https://api.thegraph.com/subgraphs/name/graphprotocol/compound-v2',
            {
                query: `
                {
                    accounts (
                        where: {
                            id:"${ethID}"
                        }
                      ) {
                        tokens {
                            symbol
                            cTokenBalance
                        }
                    }
                }
                `
            }
        );
        for(i = 0; i < result.data.data.accounts.length; i++)
            console.log(result.data.data.accounts[i]);
    } catch(error) {
        console.error(error);
    }
}

const maker = async () => {
    try {
        const newResult = await axios.post(
            'https://api.thegraph.com/subgraphs/name/protofire/makerdao-governance',
            {
                query: `
                {
                    snxholders(orderBy: block, orderDirection: desc) {
                        id
                        balanceOf
                        collateral
                        transferable
                        initialDebtOwnership
                        debtEntryAtIndex
                        block
                    }
                }
                `
            }
        );
        console.log(newResult.data.snxholders);
    } catch(error) {
        console.error(error);
    }
}

main();
