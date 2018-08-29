import React, { Component } from 'react'
import ProofOfExistenceContract from '../build/contracts/ProofOfExistence.json'
import getWeb3 from './utils/getWeb3'

import './css/oswald.css'
import './css/open-sans.css'
import './css/pure-min.css'
import './App.css'

import Dropzone from 'react-dropzone'
import IPFS from 'ipfs-api'
import moment from 'moment';
import { css } from 'react-emotion';
import ClipLoader from 'react-spinners/ClipLoader';

const node = IPFS('ipfs.infura.io', '5001', {protocol: 'https'})

const override = css`
    display: block;
    margin: 0 auto;
    border-color: red;
`;

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      storageValue: 0,
      web3: null,
      numFiles: 0,
      data: [],
      loading: false
    }
    //this.onDrop = this.onDrop.bind(this);
    //this.instantiateContract = this.instantiateContract.bind(this);
  }

  componentWillMount() {
    this.setState({loading: true});
    // Get network provider and web3 instance.
    // See utils/getWeb3 for more info.

    getWeb3
    .then(results => {
      this.setState({
        web3: results.web3
      })

      // Instantiate contract once web3 provided.
      this.instantiateContract()
    })
    .catch(() => {
      console.log('Error finding web3.')
    })

    this.setState({loading: false});
  }

  instantiateContract() {
    /*
     * SMART CONTRACT EXAMPLE
     *
     * Normally these functions would be called in the context of a
     * state management library, but for convenience I've placed them here.
     */
   
    const contract = require('truffle-contract')
    const ProofOfExistence = contract(ProofOfExistenceContract)
    ProofOfExistence.setProvider(this.state.web3.currentProvider)

    // Declaring this for later so we can chain functions on SimpleStorage.
    var ProofOfExistenceInstance

    // Get accounts.
    this.state.web3.eth.getAccounts((error, accounts) => {
      ProofOfExistence.deployed().then((instance) => {
        ProofOfExistenceInstance = instance
        //console.log('instance: ', instance)
        // Get the number of uploaded files by the user
        return ProofOfExistenceInstance.getProofLength.call(accounts[0])
      }).then((result) => {
        // Update state with the result.
        this.setState({ numFiles: result.c[0] })
        console.log('total files: ', this.state.numFiles);

        for(var i=0; i< this.state.numFiles; i++){
          ProofOfExistenceInstance.getProofAt(accounts[0], i)
          .then((result) => {
            //console.log('results: ', result);
            var tempData = this.state.data;
            tempData.push({
              fileHash: result[0],
              filePath: result[1],
              timestamp: result[2].c[0],
              fileOwner: result[3]
            })
            //console.log('tempData: ', tempData)
            this.setState({data: tempData})
            //console.log('Data: ', this.state.data)
          })
        }

      });
    });
  }


  onDrop(acceptedFiles, rejectedFiles) {
    acceptedFiles.forEach(file => {
      console.log('file: ', file.name, file);
      const reader = new FileReader();
        reader.onload = () => {
            const fileAsArrayBuffer = reader.result;

            this.setState({loading: true});
            node.files.add({
              path: file.name,
              content: Buffer.from(fileAsArrayBuffer)
            }, (err, filesAdded) => {
              this.setState({loading: false});
              if (err) {console.log('ipfs error: ', err); return err}
      
              console.log('Added file: ', filesAdded[0].path, filesAdded[0].hash)

              const contract = require('truffle-contract')
              const ProofOfExistence = contract(ProofOfExistenceContract)
              ProofOfExistence.setProvider(this.state.web3.currentProvider)

              // Declaring this for later so we can chain functions on SimpleStorage.
              var ProofOfExistenceInstance
              // Get accounts.
              this.state.web3.eth.getAccounts((error, accounts) => {
              ProofOfExistence.deployed().then((instance) => {
                ProofOfExistenceInstance = instance
                //console.log('instance: ', instance)
                // Get the number of uploaded files by the user
                return ProofOfExistenceInstance.addProof(filesAdded[0].hash, "https://ipfs.io/ipfs/" + filesAdded[0].hash, {from: accounts[0]})
                }).then((result) => {
                  console.log('addProof: ', result);
                  //this.forceUpdate();
                  this.setState({loading: true});

                  setTimeout(
                  ()=>{
                    ProofOfExistenceInstance.getProofLength.call(accounts[0])
                    .then((result) => {
                      this.setState({ numFiles: result.c[0] })
                      console.log('total files after adding: ', this.state.numFiles);
                      
                      var tempData = [];
                      var i = 0;
                      for( i=0; i< this.state.numFiles; i++){
                        ProofOfExistenceInstance.getProofAt(accounts[0], i)
                        .then((result) => {
                          //console.log('results: ', result);
                         
                          tempData.push({
                            fileHash: result[0],
                            filePath: result[1],
                            timestamp: result[2].c[0],
                            fileOwner: result[3]
                          })
                          //console.log('tempData: ', tempData)
                          this.setState({data: tempData})
                          //console.log('Data: ', this.state.data)
                          
                        })
                      };
                      if(i === this.state.numFiles ) {this.setState({loading: false})};
                    
                  });

                  

                }
                  ,7000);
                  /*
                  return ProofOfExistenceInstance.getProofLength.call(accounts[0])
                  .then((result) => {
                    this.setState({ numFiles: result.c[0] + 1 })
                    console.log('total files after adding: ', this.state.numFiles);
                    
                  })*/

              })
            })
              
            })
        };
        reader.onabort = () => console.log('file reading was aborted');
        reader.onerror = () => console.log('file reading has failed');

        reader.readAsArrayBuffer(file);
      
      
    });
  } 


  render() {
    var listItems = this.state.data.map(function(item,index) {
      return (
        <div className="file-metadata" key={index}>
          <h3><u>File Metadata</u></h3>
          <p>IPFS Hash: {item.fileHash} </p>
          <p>File Path: <a href={item.filePath}>{item.filePath}</a>  </p>
          <p>Timestamp: {moment.unix(item.timestamp).format('dddd, MMMM Do, YYYY h:mm:ss A')}</p>
          <p>File Owner: {item.fileOwner} </p>
        </div>
      );
    });

    return (
      <div className="App">
        <nav className="navbar pure-menu pure-menu-horizontal">
            <a href="#" className="pure-menu-heading pure-menu-link">Proof Of Existence</a>
        </nav>

        <main className="container">
          <div className="pure-g">
            <div className="pure-u-1-1">
              <h1>Upload any file for existence certification</h1>
              <h2>Number of files uploaded by you is: {this.state.numFiles}</h2>
               <ClipLoader
                className={override}
                sizeUnit={"px"}
                size={150}
                color={'#123abc'}
                loading={this.state.loading}
              />
              <div className="dropzone">
                <Dropzone onDrop={this.onDrop.bind(this)}>
                  <p>Try dropping some files here, or click to select files to upload.</p>
                </Dropzone>
              </div>

              <ul>
                {listItems}
              </ul>
            </div>
          </div>
        </main>
      </div>
    );
  }
}

export default App
