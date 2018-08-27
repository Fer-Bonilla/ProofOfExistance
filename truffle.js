module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*", // match any network
      gas: 6300000
    },
    live: {
      host: "13.95.8.151", // Azure public IP
      port: 8540,
      network_id: "*",        // PowerToShare Consortium Network
      // optional config values:
       gas: 4700000,
      //gasPrice: 25000000000,
       from: "0x004ec07d2329997267Ec62b4166639513386F32E", //default address to use for any transaction Truffle makes during migrations
      // provider - web3 provider instance Truffle should use to talk to the Ethereum network.
      //          - function that returns a web3 provider instance (see below.)
      //          - if specified, host and port are ignored.
    }
  }
};
