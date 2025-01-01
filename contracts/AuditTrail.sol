// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AuditTrail {
    struct Action {
        uint256 timestamp;
        string actionType;
        address actor;
    }

    mapping(uint256 => Action[]) public auditTrail;

    event ActionLogged(uint256 recordId, string actionType, address actor);

    function logAction(uint256 _recordId, string memory _actionType) public {
        auditTrail[_recordId].push(Action(block.timestamp, _actionType, msg.sender));
        emit ActionLogged(_recordId, _actionType, msg.sender);
    }

    function getActions(uint256 _recordId) public view returns (Action[] memory) {
        return auditTrail[_recordId];
    }
}