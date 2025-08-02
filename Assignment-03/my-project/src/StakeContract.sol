// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract Stake is ERC20 {
      
     uint256 public totalStaked;
     mapping(address => mapping(address => uint256)) public userStakes;
     
     event Staked(address indexed userAddress ,address indexed address , uint256 amount);
     event Unstaked(address indexed userAddress , address indexed address , uint256 amount);


     function stake(address _tokenAddress,uint256 _amount) public {
         require(_amount > 0, "Amount should be greater than 0");
         
         IERC20 token = IERC20(_tokenAddress); // create an interface reference to an already deployed ERC20 token contract.
         require(token.allowance(address(token), msg.sender, _amount) >= _amount, "You don't have enough allowance");
         bool success = token.transferFrom(msg.sender, address(this), _amount);
         require(success, "Transfer failed");
         totalStaked += _amount;
         userStakes[msg.sender][_tokenAddress] += _amount;

         emit Staked(msg.sender, _tokenAddress, _amount);

     }
     function unstake(address _tokenAddress,uint256 _amount) public {
      require(_amount > 0, "Amount should be greater than 0");
      require(userStakes[msg.sender][_tokenAddress] >= _amount, "You don't have enough staked tokens");
      IERC20 token = IERC20(_tokenAddress);
      bool success = token.transfer(msg.sender, _amount);
      require(success, "Transfer failed");
      totalStaked -= _amount;
      userStakes[msg.sender][_tokenAddress] -= _amount;
      emit Unstaked(msg.sender, _tokenAddress, _amount);
     }
    
    
}