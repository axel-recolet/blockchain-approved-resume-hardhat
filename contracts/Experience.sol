// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Experience {
    enum ApprovalStatus {
        APPROVED,
        UNAPPROVED,
        UNDEFINED
    }

    struct Employee {
        address ethAddress;
    }

    struct Employer {
        address ethAddress;
        ApprovalStatus approvalStatus;
        string comment;
    }

    struct Oracle {
        address ethAddress;
        string name;
    }

    string public smartContractVersion = "0.0.1";
    Oracle public oracle;
    Employee public employee;
    Employer public employer;
    uint public startedAt;
    uint public endedAt;
    string[] public skills;
    string[] public tasks;
    string public description;

    modifier onlyEmployee() {
        require(
            msg.sender == employee.ethAddress,
            "Only the employee can perform this action."
        );
        _;
    }

    modifier onlyEmployer() {
        require(
            msg.sender == employer.ethAddress,
            "Only the employer can perform this action."
        );
        _;
    }

    modifier ApprovalStatusIsUndefied() {
        require(
            employer.approvalStatus == ApprovalStatus.UNDEFINED,
            "Approval status is already set."
        );
        _;
    }

    constructor(
        string memory _oracleName,
        address _employeeEthAddress,
        address _employerEthAddress,
        uint _startedAt,
        uint _endedAt,
        string[] memory _skills,
        string[] memory _tasks,
        string memory _description
    ) {
        oracle = Oracle(msg.sender, _oracleName);
        employee = Employee(_employeeEthAddress);
        employer = Employer(_employerEthAddress, ApprovalStatus.UNAPPROVED, "");
        startedAt = _startedAt;
        endedAt = _endedAt;
        skills = _skills;
        tasks = _tasks;
        description = _description;
    }

    function approve(
        string memory _comment
    ) public onlyEmployer ApprovalStatusIsUndefied {
        employer.approvalStatus = ApprovalStatus.APPROVED;
        employer.comment = _comment;
    }

    function unapprove(
        string memory _comment
    ) public onlyEmployer ApprovalStatusIsUndefied {
        employer.approvalStatus = ApprovalStatus.UNAPPROVED;
        employer.comment = _comment;
    }
}
