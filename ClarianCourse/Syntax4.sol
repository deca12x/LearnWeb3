// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

///////////////////////////////////////////////////////////////////////////////////////deca//
////////////////////////////    SYNTAX 4 (from Udemy Course)   //////////////////////////////
//  Cybersecurity, return funds, loopholes, withdrawal pattern, restricted access pattern  //
////////////////////////  Contract visibility, Inheritance, Events  /////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

/*contract CyberSecurity {
    modifier onlyOwner {
        require(true);
        _;
    function returnFunds() public onlyOwner returns (bool success) {
        for(uint i = 0; funders.length; i++) {
            funders[i].transfer(contributedAmount);
        }
        return true;
    }
}*/

contract Victim {
    //Check if an address is a contract or a wallet
    function isItAContract() public view returns (bool) {
        //Check the size: if there are bytes of code, then it's a contract
        uint32 size;
        address a = msg.sender;
        //Go into the EVM (generally not recommended)
        assembly {
            size := extcodesize(a)
        }
        return(size > 0);
    }
}

contract Attacker {
    //Trick the victim into thinking it's a contract
    //Loophole: if you call the address from a constructor, there are no bytes of code
    bool public trickedYou;
    //Inherit the Victim contract into a victim variable
    Victim victim;
    //Executing the victim address in the attacker's constructor
    constructor(address _v) {
        victim = Victim(_v);
        trickedYou = !victim.isItAContract();
    }
}

//To avoid loopholes like the one above, we use established patterns

//--------------------THE WITHDRAWAL PATTERN--------------------
    //Let the investor withdraw themselves (eliminate outside interference)
    //Make transactions one at a time (not safe to interact with multiple customers at a time)
    //Make sure that only the owner can send funds

/* contract withdrawalPattern {

    function claimRefund () public {
        require(balance[msg.sender] > 0);
        msg.sender.transfer(balance[msg.sender]);
    }

    function withdrawFunds (uint amount) public returns (bool success){
        require(balance[msg.sender] >= amount);
        balance[msg.sender] -= amount;
        msg.sender.transfer(amount);
        return true;
    }

}*/

//--------------------THE RESTRICTED ACCESS PATTERN--------------------
    //A contract state is read-only by default (unless specified as public)
    //Modifiers restrict who can modify the contract's state or call the contract's functions


contract RestrictedAccess {
    address public owner = msg.sender;
    uint public creationTime = block.timestamp;

    //onlyBy modifier = restricted caller
    modifier onlyBy (address _account) {
        require(msg.sender == _account, 'Sender not authorised.');
        _; 
    }
    //onlyAfter modifier = restricted time
    modifier onlyAfter (uint _time) {
        require(block.timestamp >= _time, 'The function was called too early.');
        _;
    }
    //costs modifier = restrict function only if certain value is provided
    modifier costs (uint _amount) {
        require(msg.value >= _amount, 'Not enough ETH provided.');
        _;
    }

    //Use these modifiers in some example functions...

    function changeOwnerAddress (address _newAddress) onlyBy(owner) public {
        owner = _newAddress;
    }

    function disown () onlyBy(owner) onlyAfter(creationTime + 5 seconds) public {
        delete owner;
    }

    function forceOwnerChange (address _newOwner) payable public costs (200 ether) {
        owner = _newOwner;
    }

}

//CONTRACT VISIBILITY (public, private, external and internal)
    //Change visibility of variables and functions in contracts C, D and E below
    //...then redeploy to see what happens

contract C {
    uint private data;
    uint public info;
    constructor() {info = 10;}
    function increment(uint a) private pure returns (uint) {return a + 1;} 
    function updateData(uint a) public {data = a;} 
    function getData() public view returns (uint) {return data;} 
    function compute(uint a, uint b) pure internal returns (uint) {return a + b;} 
}

contract D {
    C c = new C();
    function readInfo() public view returns (uint) {return c.info();}
}

//Inheritance using 'is'
contract E is C {
    uint private result;
    C private c;
    constructor() {c = new C();}
    function getComputedResult() public {result = compute(23, 5);}
    function getResult() public view returns (uint) {return result;}
    function getInfo() public view returns (uint) {return info;}
}

contract A {
    uint public innerVal = 100;
    function innerAddTen(uint _a) public pure returns(uint) {return _a + 10;}
}

contract B is A {
    function outerAddTen(uint _a) public pure returns(uint) {return innerAddTen(_a);}
    function outerVal() public view returns(uint) {return innerVal;}
}

//--------------------EVENTS--------------------

contract LearnEvents {
//Events have lower gas than storage, becaue they're not stored as memory
//Events can't be accessed from the blockchain, only from outside
    //First declare the event, then emit the event

    event NewTrade(uint indexed date, address from, address indexed to, uint indexed amount);
    //Indexed costs more gas. Can use up to 3 indexed per event

    function trade(address to, uint amount) external {
        emit NewTrade(block.timestamp, msg.sender, to, amount);
        //outside user can see the event through web3js and can sort through with 'indexed'
    }
}

