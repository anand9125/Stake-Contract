// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract Stake is ERC20 {
    
    uint256 public totalStaked;
    mapping(address => uint256) public stakedAmount;
    mapping(address => uint256) public stakedTime;
    
    event ETHStaked(address indexed _user, uint256 _amount);
    event ETHUnstaked(address indexed _user, uint256 _amount);
    
    uint256 rewardConstant = 1;
    uint public toke_time = 604800; //7 days in seconds

   
   constructor() ERC20("Stake Token", "STK") {
    }

    function mintTokens(uint256 _amount, address _to) internal {
        _mint(_to, _amount);
    }
    function stake(uint256 _amount) public payable{
        require(_amount > 0, "Amount should be greater than 0");
        require(msg.value == _amount, "Amount should be equal to msg.value");
        totalStaked += _amount;
        stakedAmount[msg.sender] += _amount;
        mintTokens(_amount, msg.sender);
        stakedTime[msg.sender] = block.timestamp;
        emit ETHStaked(msg.sender, _amount);

    }  
    function unstake(uint256 _amount) public payable{
        require(_amount > 0, "Amount should be greater than 0");
        require(stakedAmount[msg.sender] >= _amount, "Amount should be less than staked amount"); 
        totalStaked -= _amount;
        stakedAmount[msg.sender] -= _amount;
        _burn(msg.sender, _amount);
        payable(msg.sender).transfer(_amount);
    }

    function pingForGettingReward() public {
      require(stakedAmount[msg.sender] > 0, "You should stake first");
      require(stakedTime[msg.sender] + toke_time < block.timestamp, "You should wait for 7 days");
      uint userStakedTime = (block.timestamp - stakedTime[msg.sender]) / 86400; //calculate how many full days this user has been staked
      uint256 rewardToMint = stakedAmount[msg.sender]*rewardConstant*userStakedTime;
      mintTokens(rewardToMint, msg.sender);
      stakedTime[msg.sender] = block.timestamp;
    }
    function getTotalStaked() public view returns(uint256){
        return totalStaked;
    }
    
}