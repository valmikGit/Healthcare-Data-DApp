// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// We are using inter planetary file system to store the large files. We will use IPFS CID (content identifier) to uniquely
// identify a large file stored in the IPFS. The IPFS stores the documents off-chain. Only the CID is stored on-chain.
contract HealthRecord {
    struct Record {
        uint256 recordId;
        string ipfsCid; // IPFS CID for the data
        uint256 timestamp;
        address lastModifiedBy;
    }

    mapping(uint256 => Record) private records;
    uint256 private recordCounter;

    event RecordAdded(uint256 recordId, string ipfsCid, address addedBy);
    event RecordUpdated(uint256 recordId, string ipfsCid, address updatedBy);
    event RecordDeleted(uint256 recordId, address deletedBy);

    // Add a new record by storing the IPFS CID
    function addRecord(string memory _ipfsCid) public returns (uint256) {
        require(bytes(_ipfsCid).length > 0, "IPFS CID cannot be empty.");

        recordCounter++;
        records[recordCounter] = Record(recordCounter, _ipfsCid, block.timestamp, msg.sender);

        emit RecordAdded(recordCounter, _ipfsCid, msg.sender);
        return recordCounter;
    }

    // Update an existing record with a new IPFS CID
    function updateRecord(uint256 _recordId, string memory _ipfsCid) public {
        require(records[_recordId].recordId != 0, "Record does not exist.");
        require(bytes(_ipfsCid).length > 0, "IPFS CID cannot be empty.");

        records[_recordId].ipfsCid = _ipfsCid;
        records[_recordId].timestamp = block.timestamp;
        records[_recordId].lastModifiedBy = msg.sender;

        emit RecordUpdated(_recordId, _ipfsCid, msg.sender);
    }

    // Retrieve a record by its ID
    function getRecord(uint256 _recordId) public view returns (Record memory) {
        require(records[_recordId].recordId != 0, "Record does not exist.");
        return records[_recordId];
    }

    // Delete a record by its ID
    function deleteRecord(uint256 _recordId) public {
        require(records[_recordId].recordId != 0, "Record does not exist.");

        delete records[_recordId];

        emit RecordDeleted(_recordId, msg.sender);
    }
}
