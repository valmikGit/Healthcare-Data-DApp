// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Encryption {
    // In a real-world scenario, the data should be encrypted off-chain before storing it on-chain
    mapping(uint256 => string) private encryptedData;
    mapping(address => string) private decryptionKeys;

    event DataEncrypted(uint256 recordId, string encryptedData);
    event DataDecrypted(address actor, uint256 recordId, string decryptedData);

    function encryptData(uint256 _recordId, string memory _data) public {
        encryptedData[_recordId] = _data;  // Simulating encryption
        emit DataEncrypted(_recordId, _data);
    }

    function decryptData(uint256 _recordId) public view returns (string memory) {
        return encryptedData[_recordId];  // Simulating decryption
    }

    function setDecryptionKey(address _user, string memory _key) public {
        decryptionKeys[_user] = _key;
    }
}
