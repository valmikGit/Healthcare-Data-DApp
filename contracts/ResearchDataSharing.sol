// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ResearchDataSharing {
    struct ResearchConsent {
        bool consentGiven;
        uint256 timestamp;
    }

    mapping(address => ResearchConsent) public researchConsent;
    mapping(uint256 => string) private anonymizedData;
    mapping(uint256 => address) public dataToPatient;

    event DataSharedForResearch(uint256 recordId, string anonymizedData, address researcher);
    event ResearchConsentGiven(address indexed patient, uint256 timestamp);
    event ResearchConsentRevoked(address indexed patient);

    modifier onlyPatient(address _patient) {
        require(msg.sender == _patient, "Only the patient can grant or revoke consent.");
        _;
    }

    // Allow the patient to give consent for sharing their data for research purposes
    function giveResearchConsent() public {
        researchConsent[msg.sender].consentGiven = true;
        researchConsent[msg.sender].timestamp = block.timestamp;
        emit ResearchConsentGiven(msg.sender, block.timestamp);
    }

    // Allow the patient to revoke their consent
    function revokeResearchConsent() public {
        researchConsent[msg.sender].consentGiven = false;
        emit ResearchConsentRevoked(msg.sender);
    }

    // Check if the patient has consented for sharing data
    function checkResearchConsent(address _patient) public view returns (bool) {
        return researchConsent[_patient].consentGiven;
    }

    // Share anonymized data for research (only if consent is given)
    function shareDataForResearch(uint256 _recordId, string memory _anonymizedData) public {
        require(researchConsent[msg.sender].consentGiven, "Patient has not given consent.");
        anonymizedData[_recordId] = _anonymizedData;
        dataToPatient[_recordId] = msg.sender;
        emit DataSharedForResearch(_recordId, _anonymizedData, msg.sender);
    }

    // Retrieve anonymized research data (only for researchers)
    function getAnonymizedData(uint256 _recordId) public view returns (string memory) {
        return anonymizedData[_recordId];
    }

    // Verify that the data belongs to the correct patient
    function getPatientForRecord(uint256 _recordId) public view returns (address) {
        return dataToPatient[_recordId];
    }
}
