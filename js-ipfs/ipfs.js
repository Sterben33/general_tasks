// For using this extention's client you need to download and run 'ipfs daemon' 
// We have the another one, but I don't clearly understand how to use it yet.
const ipfsClent = require('ipfs-http-client');
const fs = require('fs');

const ipfs = new ipfsClent.create({host: 'localhost', port: '5001', protocol: 'http'});


const addFile = async (filePath) => {
    const file = fs.readFileSync(filePath);
    const fileAdded = await ipfs.add({content: file});
    console.log(fileAdded)
    const fileHash = fileAdded.path;

    return fileHash
}


(async () => {
    const hash = await addFile('Name' ,'t.txt');
    console.log(`Your file is available on: https://ipfs.io/ipfs/${hash}`)
})()