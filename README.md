# ProofOfExistence

## About
This project demonstrates a basic proof of file existence DApp. This application store user's files in IPFS and corresponding file metadata in blockchain. This application allows users to prove existence of some information by showing a time stamped picture/video.

This application retrieves all the previously uploaded files by a user along with time stamped file metadata to allow other people to verify data authenticity.

User can also add new files to IPFS along with existence proof in blockchain by using simple drag and drop feature.

## Installation
Make sure you have node.js and npm installed.

Clone the repository and install the dependencies
```bash
git clone https://github.com/rajeshsubhankar/ProofOfExistance.git
cd ProofOfExistance
npm install
```

Install and run `ganache-cli`.
```bash
npm install -g ganache-cli
ganache-cli
```
Import the _mnemonic_ returned in above command into the **Metamask** browser extension to interact with the DApp.

Configure metamask to connect to `http://localhost:8545` network.

Install and run truffle to compile and migrate smart contracts
```
npm install truffle -g
truffle compile
truffle migrate
```

Now, run the application using
```npm run start```

see the interface at [http://localhost:3000](http://localhost:3000/)


