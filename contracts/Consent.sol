// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Consent {
    mapping(address => bool) public consentGiven;
    mapping(address => uint256) public consentTimestamp;

    event ConsentGranted(address indexed patient);
    event ConsentRevoked(address indexed patient);

    function grantConsent() public {
        consentGiven[msg.sender] = true;
        consentTimestamp[msg.sender] = block.timestamp;
        emit ConsentGranted(msg.sender);
    }

    function revokeConsent() public {
        consentGiven[msg.sender] = false;
        emit ConsentRevoked(msg.sender);
    }

    function checkConsent(address _patient) public view returns (bool) {
        return consentGiven[_patient];
    }

    function getConsentTimestamp(address _patient) public view returns (uint256) {
        return consentTimestamp[_patient];
    }
}
