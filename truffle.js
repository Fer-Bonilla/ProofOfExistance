var HDWalletProvider = require("truffle-hdwallet-provider");

var mnemonic = "Place your mnemonic here";

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
    rinkeby: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/yourApiKey")
      },
      network_id: 4
    }
  }
};
