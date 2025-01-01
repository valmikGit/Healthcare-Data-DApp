// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProviderVerification {
    mapping(address => bool) public verifiedProviders;

    event ProviderVerified(address provider);
    event ProviderUnverified(address provider);

    modifier onlyVerifiedProvider() {
        require(verifiedProviders[msg.sender], "Provider not verified");
        _;
    }

    function verifyProvider(address _provider) public {
        verifiedProviders[_provider] = true;
        emit ProviderVerified(_provider);
    }

    function unverifyProvider(address _provider) public {
        verifiedProviders[_provider] = false;
        emit ProviderUnverified(_provider);
    }
}