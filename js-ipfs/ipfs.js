const IPFS = require('ipfs-core');
const fs = require('fs');


async function addToIPFS(path) {
    const file = fs.readFileSync(path)
    const ipfs = await IPFS.create()
    const result = await ipfs.add(file)

    console.log(result);
    return result
}


addToIPFS('t.txt')