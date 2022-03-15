// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.12;

contract Campaign {

  struct Request {
    string description;
    uint value;
    address recipient;
    bool complete;
    uint approvalCount;
    mapping(address => bool) approvals;

  }
  uint requestIndex = 0;
  address public manager;
  uint public minimumContribution;
  //Due to having the track of approvers execution, shifting data type from array to mapping
  //address[] public approvers;
  mapping(address => bool) public approvers;
  uint approversCount;
  Request[] public requests;

  modifier onlyOnManager() {
    require(msg.sender == manager, 'Only Manager can ');
    _;
  }

  constructor(uint minimumAmount) {
    manager = msg.sender;
    minimumContribution = minimumAmount;
  }

  function contribute() public payable {
    require(msg.value > minimumContribution, 'The given WEI should be greater than ${minimumContribution}');
    approvers[msg.sender] = true;
    approversCount++;
    //payable(manager).transfer(msg.value);
  }

  function createRequest(string memory description, uint value, address recipient) public  onlyOnManager {
    Request storage request = requests[requestIndex++];
      request.description = description;
      request.value = value;
      request.recipient = recipient;
      request.complete = false;
      request.approvalCount = 0;
  }

  function approveRequest(uint index) public {
    Request storage indexedReq = requests[index];
    require(approvers[msg.sender], 'First contribute some amount to become a member');
    require(!indexedReq.approvals[msg.sender], 'You have already approved for this claim');

    indexedReq.approvals[msg.sender] = true;
    indexedReq.approvalCount++;
  }

  function finalizeRequest(uint index) public payable onlyOnManager {
    Request storage indexedReq = requests[index];
    require(indexedReq.approvalCount > (approversCount / 2), 'Minimum approval count has not reached. Please try again later');
    require(!indexedReq.complete, 'The request has already finalized');
    payable(indexedReq.recipient).transfer(indexedReq.value);
    indexedReq.complete = true;
  }
}
