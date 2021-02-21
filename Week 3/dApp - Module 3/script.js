const axios = require('axios');

const main = async () => {
    try {
        const result = await axios.post(
            'https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v2',
            {
                query: `
                {
                    tokens(first: 5) {
                        id
                        symbol
                        name
                        decimals
                    }
                }
                `
            }
        );
        console.log(result.data.data.tokens);
    } catch(error) {
        console.error(error);
    }
}

main();