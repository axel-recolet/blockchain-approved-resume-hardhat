// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Experience {
    address payable public employee;
    address public employer;
    uint public startedAt;
    uint public endedAt;
    string[] public skills;
    string public description;
    bool public isApproved;

    constructor(
        address _employer,
        uint _startedAt,
        uint _endedAt,
        string[] memory _skills,
        string memory _description
    ) {
        employee = payable(msg.sender);
        employer = _employer;
        startedAt = _startedAt;
        endedAt = _endedAt;
        skills = _skills;
        description = _description;
        isApproved = false;
    }

    function approve() public {
        require(msg.sender == employer, "You aren't the employer.");
        isApproved = true;
    }
}
