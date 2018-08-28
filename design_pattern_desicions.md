## Design Patterns
There are several design patterns implemented for the smart contract development of this application. Details about them are follows.

### Fail early and fail loud

```js
function getProofAt(address _user, uint _index) public view returns(string, string, uint, address) {
        require(_user != address(0), "Invalid user address");

        return(userProofs[_user][_index].fileHash,
        userProofs[_user][_index].filePath,
        userProofs[_user][_index].timestamp,
        userProofs[_user][_index].fileOwner);
    }
```

This function checks the condition required for execution as early as possible in the function body and throws an exception if the condition is not met. This is a good practice to reduce unnecessary code execution in the event that an exception will be thrown.

### Restricting Access

```js
function kill() public onlyOwner {
        selfdestruct(owner);
    }
```

Here, killing of contract is only restricted to contract owner so that no other individual can destroy the contract. 

### Mortal

```js
function kill() public onlyOwner {
        selfdestruct(owner);
    }
```

The ability to destroy the contract and remove it from the Blockchain is achieved using this design pattern.

### Circuit Breaker

```js
function addProof(string _fileHash, string _filePath) public whenNotPaused {
        //string memory ipfsURL = "http://ipfs.io/ipfs/" + _fileHash; //Oraclize can be used

        userProofs[msg.sender].push(proof({
            fileHash: _fileHash,
            filePath: _filePath,
            timestamp: now,
            fileOwner: msg.sender
        }));

        emit LogProof(_fileHash, _filePath, now, msg.sender);

    }
```

The ability to stop contract execution (adding new proofs) is achieved by `whenNotPaused` circuit breaker. This design pattern will help in a situation where there is a live contract where a bug has been detected.