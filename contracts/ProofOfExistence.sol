pragma solidity ^0.4.18;

import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";

/** @title Proof Of Existence. */
contract ProofOfExistence is Pausable {

    struct proof{
        string fileHash;
        string filePath;
        uint timestamp;
        address fileOwner;
    }

    /* User address to list of file proofs mapping */
    mapping(address => proof[]) userProofs;

    /* Empty constructer */
    constructor() public {

    }

    /** @dev Log event to trigger new proof.
      * @param fileHash File hash.
      * @param filePath File path.
      * @param timestamp File upload time.
      * @param fileOwner Owner of file.
      */
    event LogProof(string fileHash, string filePath, uint timestamp, address indexed fileOwner);

    /** @dev Will kill the smart contract.
      * @modifier onlyOwner only contract owner can call this function.
      */
    function kill() public onlyOwner {
        selfdestruct(owner);
    }

    /** @dev Add new file existence proof to the blockchain.
      * @param _fileHash IPFS hash of uploaded file.
      * @param _filePath IPFS url of uploaded file.
      * @modifier whenNotPaused will execute only when the contract is active.
      */
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

    /** @dev Return the file existence proof from specific index.
      * @param _user user's ethereum address.
      * @param _index proof index.
      * @return fileHash The hash of uploaded file.
      * @return filePath The path of uploaded file.
      * @return timestamp File upload timestamp.
      * @return fileOwner Owner of file.
      */
    function getProofAt(address _user, uint _index) public view returns(string, string, uint, address) {
        require(_user != address(0), "Invalid user address");

        return(userProofs[_user][_index].fileHash,
        userProofs[_user][_index].filePath,
        userProofs[_user][_index].timestamp,
        userProofs[_user][_index].fileOwner);
    }

    /** @dev Return the length of user's file existence list.
      * @param _user User's ethereum address.
      * @return length Length of user's proof list.
      */
    function getProofLength(address _user) public view returns(uint) {
        require(_user != address(0), "Invalid user address");

        return(userProofs[_user].length);
    }

}
