// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AccessControl {
    enum Role { Patient, Doctor, Nurse, Hospital, Lab }
    mapping(address => Role) public userRoles;
    mapping(address => mapping(address => bool)) private permissions;

    event AccessGranted(address indexed grantee, address indexed provider, Role role);
    event AccessRevoked(address indexed grantee, address indexed provider);

    modifier onlyPatient() {
        require(userRoles[msg.sender] == Role.Patient, "Not authorized");
        _;
    }

    modifier onlyAuthorized(address _provider) {
        require(permissions[msg.sender][_provider], "Access not granted");
        _;
    }

    function setRole(address _user, Role _role) public onlyPatient {
        userRoles[_user] = _role;
    }

    function grantAccess(address _provider, bool _canAccess) public onlyPatient {
        permissions[msg.sender][_provider] = _canAccess;
        if (_canAccess) {
            emit AccessGranted(msg.sender, _provider, userRoles[_provider]);
        } else {
            emit AccessRevoked(msg.sender, _provider);
        }
    }

    function checkAccess(address _provider) public view returns (bool) {
        return permissions[msg.sender][_provider];
    }
}