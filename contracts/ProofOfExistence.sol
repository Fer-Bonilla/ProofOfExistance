pragma solidity ^0.4.18;

import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";

contract ProofOfExistence is Pausable {

    struct proof{
        string fileHash;
        string filePath;
        uint timestamp;
        address fileOwner;
    }

    /*User address to list of file proofs mapping */
    mapping(address => proof[]) userProofs;

    constructor() public {

    }

    //events
    event LogProof(string fileHash, string filePath, uint timestamp, address indexed fileOwner);

    //functions
    function kill() public onlyOwner {
        selfdestruct(owner);
    }

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

    function getProofAt(address _user, uint _index) public view returns(string, string, uint, address) {
        return(userProofs[_user][_index].fileHash,
        userProofs[_user][_index].filePath,
        userProofs[_user][_index].timestamp,
        userProofs[_user][_index].fileOwner);
    }

    function getProofLength(address _user) public view returns(uint) {
        return(userProofs[_user].length);
    }

}