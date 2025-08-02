// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Stake} from "../src/StakContract.sol";

contract StakeContractTest is Stake {
     Stake c;

    function setUp() public {
        c= new Stake();
    }

    function testStack() public {
        uint value = 10 ether;
        c.stake{value: value}(value);   //msg.value and functon value
        assert(c.getTotalStaked()== value);
    }

    function testUnstake() public {
        uint value = 10 ether;
        c.stake{value: value}(value);  
        c.unstake(value);
        assert(c.getTotalStaked()== 0);
    }
 
    receive() external payable {}  //our test contract does not support transfers so unstack will fail if we dont put this recieve function that is payable.
}
