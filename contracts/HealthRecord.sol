// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HealthRecord {
    struct Record {
        uint256 recordId;
        string data;
        uint256 timestamp;
        address lastModifiedBy;
    }

    mapping(uint256 => Record) private records;
    uint256 private recordCounter;

    event RecordAdded(uint256 recordId, address addedBy);
    event RecordUpdated(uint256 recordId, address updatedBy);
    event RecordDeleted(uint256 recordId, address deletedBy);

    function addRecord(string memory _data) public returns (uint256) {
        recordCounter++;
        records[recordCounter] = Record(recordCounter, _data, block.timestamp, msg.sender);
        emit RecordAdded(recordCounter, msg.sender);
        return recordCounter;
    }

    function updateRecord(uint256 _recordId, string memory _data) public {
        require(records[_recordId].recordId != 0, "Record does not exist.");
        records[_recordId].data = _data;
        records[_recordId].timestamp = block.timestamp;
        records[_recordId].lastModifiedBy = msg.sender;
        emit RecordUpdated(_recordId, msg.sender);
    }

    function getRecord(uint256 _recordId) public view returns (Record memory) {
        require(records[_recordId].recordId != 0, "Record does not exist.");
        return records[_recordId];
    }

    function deleteRecord(uint256 _recordId) public {
        require(records[_recordId].recordId != 0, "Record does not exist.");
        delete records[_recordId];
        emit RecordDeleted(_recordId, msg.sender);
    }
}
