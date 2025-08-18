// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {MultiSigDAO} from "./multiSigDao.sol";
import {Test} from "forge-std/Test.sol";



contract MultiSigDaoTest is Test {
  MultiSigDAO dao;
  function setup()public{
    address user1 = address(1);
    address user2 = address(2);
    address user3 = address(3);
    dao = new MultiSigDAO(user1, user2, user3);
  }
  function testsUserCanCreateProposals()public{
    // address user101 = address(101);
    // vm.startPrank(user101);
    // dao.createProposal("proposal 101 is not free");
    // assert(dao.allUserProposals(user101).length,1);
    // // assert();
  }
}