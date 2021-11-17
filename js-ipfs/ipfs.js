// For using 'ipfs-http-client's client you need to download and run 'ipfs daemon' 
const ipfsClent = require('ipfs-http-client');
const IPFS = require('ipfs-core');
const fs = require('fs');

// Implementation for 'ipfs-http-client'
const ipfs = new ipfsClent.create({host: 'localhost', port: '5001', protocol: 'http'});
const addFileHttpClient = async (filePath) => {
    const file = fs.readFileSync(filePath);
    const fileAdded = await ipfs.add({content: file});
    console.log(fileAdded)
    const fileHash = fileAdded.path;

    return fileHash
}
(async () => {
    const hash = await addFileHttpClient('t.txt');
    console.log(`('ipfs-http-client') Your file is available on: https://ipfs.io/ipfs/${hash}`)
})()


// Implementation for 'ipfs-core'
// const addFileCore = async (filePath) => {
//     const file = fs.readFileSync(filePath);
//     const client = await IPFS.create();
//     const { path } = await client.add(file);
//     console.log(`('ipfs-core') Your file if awailable on: https://ipfs.io/ipfs/${path}`);
//     process.exit(); // Need a better way
// }
// addFileCore('t.txt');