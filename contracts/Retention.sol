// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Retention {
    mapping(uint256 => uint256) public dataRetentionPeriod;
    mapping(uint256 => uint256) public dataCreatedAt;

    event DataRetentionSet(uint256 recordId, uint256 retentionPeriod);
    event DataDeleted(uint256 recordId);

    function setRetentionPeriod(uint256 _recordId, uint256 _days) public {
        dataRetentionPeriod[_recordId] = _days;
        dataCreatedAt[_recordId] = block.timestamp;
        emit DataRetentionSet(_recordId, _days);
    }

    function checkRetentionPeriod(uint256 _recordId) public view returns (uint256) {
        return dataRetentionPeriod[_recordId];
    }

    function deleteExpiredData(uint256 _recordId) public {
        require(block.timestamp >= dataCreatedAt[_recordId] + (dataRetentionPeriod[_recordId] * 1 days), "Retention period not expired");
        delete dataRetentionPeriod[_recordId];
        delete dataCreatedAt[_recordId];
        emit DataDeleted(_recordId);
    }
}