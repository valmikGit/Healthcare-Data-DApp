// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DisputeResolution {
    struct Dispute {
        address complainant;
        address defendant;
        string description;
        uint256 timestamp;
        bool resolved;
        address arbiter;
        string resolution;
    }

    uint256 public disputeCounter;
    mapping(uint256 => Dispute) public disputes;

    event DisputeRaised(uint256 disputeId, address indexed complainant, address indexed defendant, string description);
    event DisputeResolved(uint256 disputeId, string resolution);

    // Raise a dispute between two parties (complainant and defendant)
    function raiseDispute(address _defendant, string memory _description) public returns (uint256) {
        disputeCounter++;
        disputes[disputeCounter] = Dispute({
            complainant: msg.sender,
            defendant: _defendant,
            description: _description,
            timestamp: block.timestamp,
            resolved: false,
            arbiter: address(0),
            resolution: ""
        });
        emit DisputeRaised(disputeCounter, msg.sender, _defendant, _description);
        return disputeCounter;
    }

    // Assign an arbiter to resolve the dispute
    function assignArbiter(uint256 _disputeId, address _arbiter) public {
        require(disputes[_disputeId].complainant == msg.sender || disputes[_disputeId].defendant == msg.sender, "Only complainant or defendant can assign an arbiter.");
        require(disputes[_disputeId].resolved == false, "Dispute already resolved.");
        disputes[_disputeId].arbiter = _arbiter;
    }

    // Resolve the dispute with a decision (arbiter's role)
    function resolveDispute(uint256 _disputeId, string memory _resolution) public {
        require(msg.sender == disputes[_disputeId].arbiter, "Only the assigned arbiter can resolve the dispute.");
        require(disputes[_disputeId].resolved == false, "Dispute already resolved.");
        
        disputes[_disputeId].resolved = true;
        disputes[_disputeId].resolution = _resolution;
        emit DisputeResolved(_disputeId, _resolution);
    }

    // Get the details of a dispute
    function getDisputeDetails(uint256 _disputeId) public view returns (
        address complainant,
        address defendant,
        string memory description,
        uint256 timestamp,
        bool resolved,
        address arbiter,
        string memory resolution
    ) {
        Dispute memory dispute = disputes[_disputeId];
        return (
            dispute.complainant,
            dispute.defendant,
            dispute.description,
            dispute.timestamp,
            dispute.resolved,
            dispute.arbiter,
            dispute.resolution
        );
    }
}
