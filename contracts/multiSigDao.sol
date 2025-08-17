// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract MultiSigDAO {
    address private _admin1;
    address private _admin2;
    address private _admin3;
    struct User {
        uint id;
        string name;
    }
    uint counter = 10001;
    mapping(address => User) private users;

    constructor(address admin1, address admin2, address admin3) {
        _admin1 = admin1;
        _admin2 = admin2;
        _admin3 = admin3;
    }

    function addUser(string memory name, address userAddress) external {
        User memory user = User(counter, name);
        users[userAddress] = user;
        counter++;
    }

    enum Status {
        DEFAULT,
        PENDING,
        ACCEPTED,
        REJECTED
    }
    struct Proposal {
        Status status;
        address user;
        address[] approvals;
        string description;
        uint id;
        address[] rejections;
    }
    Proposal[] private allProposals;
    mapping(uint => Proposal) private proposals;

    function createProposal(string memory description) external onlyAdmin {
        counter += 1;
        Proposal memory proposal;
         proposal.status= Status.PENDING;
         proposal.description= description;
         proposal.id= counter;
         proposal.user= msg.sender;
        allProposals.push(proposal);
        proposals[counter]= proposal;
    }

    error UNAUTHORIZED(address);

    modifier onlyAdmin() {
        require(
            msg.sender == _admin1 ||
                msg.sender == _admin2 ||
                msg.sender == _admin3,
            UNAUTHORIZED(msg.sender)
        );
        _;
    }

    modifier hasNotApprovedYet(uint proposalId) {
        Proposal storage proposal = allProposals[proposalId];
        for (uint i = 0; i < proposal.approvals.length; i++) {
            require(proposal.approvals[i] != msg.sender, "Already approved");
        }
        _;
    }

    modifier hasNotRejectedYet(uint proposalId) {
        Proposal storage proposal = allProposals[proposalId];
        for (uint i = 0; i < proposal.approvals.length; i++) {
            require(proposal.rejections[i] != msg.sender, "Already rejected");
        }
        _;
    }
    mapping(uint => Proposal) private approvedProposals;
    mapping(uint => Proposal) private rejectedProposals;

    function approveProposals(uint proposalId) external onlyAdmin hasNotApprovedYet(proposalId) {
        for (uint i = 10000; i < allProposals.length; i++) {
            if (allProposals[i].id == proposalId) {
                allProposals[i].approvals.push(msg.sender);
                if(allProposals[i].approvals.length>=2){
                    allProposals[i].status= Status.ACCEPTED;
                    approvedProposals[proposalId] = allProposals[proposalId];
                }
                return;
            }
        }
    }

    function rejectProposals(uint proposalId) external onlyAdmin hasNotRejectedYet(proposalId) {
        for (uint i = 10000; i < allProposals.length; i++) {
            if (allProposals[i].id == proposalId) {
                allProposals[i].approvals.push(msg.sender);
                 if(allProposals[i].approvals.length>=2){
                    allProposals[i].status= Status.REJECTED;
                    rejectedProposals[proposalId]= allProposals[i];
                }
                return;
            }
        }
    }
    

}

// in a Passed Proposals list, and failed proposals should be stored in a Failed Proposals list.
//Your task:
//👉 Write a smart contract in Solidity that implements this DAO system.
//👉 Include functions for joining the DAO, creating a proposal, and admin voting.
//👉 Test your contract with different scenarios using hardha
