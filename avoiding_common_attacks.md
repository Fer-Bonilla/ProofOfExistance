## Avoiding Common Attacks

Several safety measures have been taken to avoid common attack vectors in this application.

### Reentrancy

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

No external contract call in the whole application. The problem of reentrancy have been solved by not allowing any external contract to call any method repeatedly before the first invocation of the method was finished.

### Cross-function race condition

```js
struct proof{
        string fileHash;
        string filePath;
        uint timestamp;
        address fileOwner;
    }

    /*User address to list of file proofs mapping */
    mapping(address => proof[]) userProofs;
```

No two functions are sharing the same state. The scope of state variables are kept as isolate as possible to remove cross-function race conditions.

### Timestamp dependency

> If the contract function can tolerate a 30-second drift in time, it is safe to use block.timestamp

```js
userProofs[msg.sender].push(proof({
            fileHash: _fileHash,
            filePath: _filePath,
            timestamp: now,
            fileOwner: msg.sender
        }));
```

In this application the time-stamping of pictures/videos is done by `block.timestamp` or `now` as it can tolerate the 30-second drift in time probably caused by a miner. In this application context `block.timestamp` is more secure than expecting time object from insecure (can be manipulated by end user) frontend app.

### Integer overflow and underflow

There is absolutely no integer manipulation in the application which can trigger integer overflow or underflow attack.

### DoS with (unexpected) revert
