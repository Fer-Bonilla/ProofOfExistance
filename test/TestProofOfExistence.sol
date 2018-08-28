pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ProofOfExistence.sol";

contract TestProofOfExistence {
    function testInitialProofLength() public {
        ProofOfExistence proofOfExistence = ProofOfExistence(DeployedAddresses.ProofOfExistence());

        uint expected = 0;

        Assert.equal(proofOfExistence.getProofLength(this), expected, "User should have zero proof initially");
    }

    function testProofLengthAfterAddingFileMetadata() public {
        ProofOfExistence proofOfExistence = ProofOfExistence(DeployedAddresses.ProofOfExistence());

        proofOfExistence.addProof("random file hash", "random file path");
        
        uint expected = 1;

        Assert.equal(proofOfExistence.getProofLength(this), expected, "User should have one proof after adding one record into the blockchain");
    }

    function testFileOwnerMetadata() public {
        ProofOfExistence proofOfExistence = ProofOfExistence(DeployedAddresses.ProofOfExistence());

        proofOfExistence.addProof("random file hash", "random file path");

        (string memory fileHash, string memory filePath, uint timestamp, address owner) = proofOfExistence.getProofAt(this, 0);
        
        address expected = this;

        Assert.equal(owner, expected, "Blockchain proof should match the file owner");
    }

    function testFileHashMetadata() public {
        ProofOfExistence proofOfExistence = ProofOfExistence(DeployedAddresses.ProofOfExistence());

        proofOfExistence.addProof("random file hash", "random file path");

        (string memory fileHash, string memory filePath, uint timestamp, address owner) = proofOfExistence.getProofAt(this, 0);
        
        string memory expected = "random file hash";

        Assert.equal(fileHash, expected, "Blockchain proof should match the file hash");
    }
    
    function testFilePathMetadata() public {
        ProofOfExistence proofOfExistence = ProofOfExistence(DeployedAddresses.ProofOfExistence());

        proofOfExistence.addProof("random file hash", "random file path");

        (string memory fileHash, string memory filePath, uint timestamp, address owner) = proofOfExistence.getProofAt(this, 0);
        
        string memory expected = "random file path";

        Assert.equal(filePath, expected, "Blockchain proof should match the file path");
    }

}