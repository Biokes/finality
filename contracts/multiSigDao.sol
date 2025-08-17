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
    // struct Vote{
    //     uint voteCount;
    //     bool isSupporting;
    // }
    uint private counter = 10001;
    
    // mapping(uint => mapping(address=>Vote)) votes;
    mapping(address => User) private users;
    mapping(uint => Proposal) private approvedProposals;
    mapping(uint => Proposal) private rejectedProposals;

    constructor(address admin1, address admin2, address admin3) {
        require(admin1 != address(0) && admin2 != address(0) && admin3 != address(0),"Zero address not allowed");
        require(admin1 != admin2, "admin1 and admin2 must be different");
        require(admin1 != admin3, "admin1 and admin3 must be different");
        require(admin2 != admin3, "admin2 and admin3 must be different");
        _admin1 = admin1;
        _admin2 = admin2;
        _admin3 = admin3;
    }

    modifier isNotExisitingAddress(address userAddress) {
        User memory newUser = users[userAddress];
        require(newUser.id == 0, "user already exist");
        _;
    }

    function addUser(
        string memory name,
        address userAddress
    ) external isNotExisitingAddress(userAddress) {
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
        Proposal memory proposal = allProposals[proposalId];
        for (uint i = 0; i < proposal.approvals.length; i++) {
            require(proposal.approvals[i] != msg.sender, "Already approved");
        }
        _;
    }

    modifier hasNotRejectedYet(uint proposalId) {
        Proposal memory proposal = allProposals[proposalId];
        for (uint i = 0; i < proposal.approvals.length; i++) {
            require(proposal.rejections[i] != msg.sender, "Already rejected");
        }
        _;
    }

    modifier isRejectedDS(uint proposalId) {
        Proposal memory proposal = allProposals[proposalId];
        for (uint i = 0; i < proposal.rejections.length; i++) {
            require(
                proposal.rejections[i] != msg.sender,
                "Already Disapproved"
            );
        }
        _;
    }

    modifier isApprovingDS(uint proposalId) {
        Proposal memory proposal = allProposals[proposalId];
        for (uint i = 0; i < proposal.approvals.length; i++) {
            require(proposal.approvals[i] != msg.sender, "Already Disapproved");
        }
        _;
    }

    function createProposal(string memory description) external onlyAdmin {
        counter += 1;
        Proposal memory proposal;
        proposal.status = Status.PENDING;
        proposal.description = description;
        proposal.id = counter;
        proposal.user = msg.sender;
        allProposals.push(proposal);
        proposals[counter] = proposal;
    }

    function approveProposals(uint proposalId) external onlyAdmin hasNotApprovedYet(proposalId) isRejectedDS(proposalId) {
        for (uint i = 10000; i < allProposals.length; i++) {
            if (allProposals[i].id == proposalId) {
                allProposals[i].approvals.push(msg.sender);
                if (allProposals[i].approvals.length >= 2) {
                    allProposals[i].status = Status.ACCEPTED;
                    approvedProposals[proposalId] = allProposals[proposalId];
                }
                return;
            }
        }
    }

    function rejectProposals(uint proposalId) external onlyAdmin hasNotRejectedYet(proposalId) isApprovingDS(proposalId) {
        for (uint i = 10000; i < allProposals.length; i++) {
            if (allProposals[i].id == proposalId) {
                allProposals[i].approvals.push(msg.sender);
                if (allProposals[i].rejections.length >= 2) {
                    allProposals[i].status = Status.REJECTED;
                    rejectedProposals[proposalId] = allProposals[i];
                }
                return;
            }
        }
    }

    // function vote(uint proposalId, bool isFor) external {
    //     require(votes[proposalId][msg.sender].voteCount!=1, "Already voted for");
    //     votes[proposalId][msg.sender].isSupporting= isFor;
    // }
}
