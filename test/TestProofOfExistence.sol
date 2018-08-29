pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ProofOfExistence.sol";

contract TestProofOfExistence {
    /** @dev This test function is to check the initial proof length.
      * Since user is interacting with the app very first time, there
      * should not any proof (file metadata) available in the blockchain.
      */
    function testInitialProofLength() public {
        ProofOfExistence proofOfExistence = ProofOfExistence(DeployedAddresses.ProofOfExistence());

        uint expected = 0;

        Assert.equal(proofOfExistence.getProofLength(this), expected, "User should have zero proof initially");
    }

    /** @dev This test function is to check the proof length after uploading
      * one file. Blockchain should record the file metadata after uploading
      * the file to IPFS, so it should return length as 1.
      */
    function testProofLengthAfterAddingFileMetadata() public {
        ProofOfExistence proofOfExistence = ProofOfExistence(DeployedAddresses.ProofOfExistence());

        proofOfExistence.addProof("random file hash", "random file path");

        uint expected = 1;

        Assert.equal(proofOfExistence.getProofLength(this), expected, "User should have one proof after adding one record into the blockchain");
    }

    /** @dev This test function is to check the owner of uploaded file.
      * File existence proof should correctly record the file owner in
      * blockchain.
      */
    function testFileOwnerMetadata() public {
        ProofOfExistence proofOfExistence = ProofOfExistence(DeployedAddresses.ProofOfExistence());

        proofOfExistence.addProof("random file hash", "random file path");

        (string memory fileHash, string memory filePath, uint timestamp, address owner) = proofOfExistence.getProofAt(this, 0);

        address expected = this;

        Assert.equal(owner, expected, "Blockchain proof should match the file owner");
    }

    /** @dev This test function is to check the file hash. Hash of uploaded
      * file in IPFS should match with fileHash attribute in smart contract.
      */
    function testFileHashMetadata() public {
        ProofOfExistence proofOfExistence = ProofOfExistence(DeployedAddresses.ProofOfExistence());

        proofOfExistence.addProof("random file hash", "random file path");

        (string memory fileHash, string memory filePath, uint timestamp, address owner) = proofOfExistence.getProofAt(this, 0);

        string memory expected = "random file hash";

        Assert.equal(fileHash, expected, "Blockchain proof should match the file hash");
    }

    /** @dev This test function is to check the file path. IPFS url of uploaded
      * file should match with the corresponding state variable in blockchain.
      */
    function testFilePathMetadata() public {
        ProofOfExistence proofOfExistence = ProofOfExistence(DeployedAddresses.ProofOfExistence());

        proofOfExistence.addProof("random file hash", "random file path");

        (string memory fileHash, string memory filePath, uint timestamp, address owner) = proofOfExistence.getProofAt(this, 0);

        string memory expected = "random file path";

        Assert.equal(filePath, expected, "Blockchain proof should match the file path");
    }

}
