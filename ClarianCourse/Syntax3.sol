// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

///////////////////////////////////////////////////////////////////////////////////////deca//
////////////////////////////    SYNTAX 3 (from Udemy Course)   //////////////////////////////
///////  Function Modifiers, View vs Pure, Fallback Functions, Function Overloading  ////////
////////////////////////////  Cryptographic Functions, Oracles  /////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

//FUNCTION MODIFIER = customizable logic for a function
    //e.g. check that the person calling the contract is the owner

contract Owner {
    address owner;
    constructor () {
        owner = msg.sender;
    }
    //Statically declare modifier key word and name, then write the logic
    modifier onlyOwner {
        require(msg.sender == owner);
        _; //underscore means "in that case continue with the function"
    }

    modifier costs (uint price) {
        require(msg.value >= price); //msg.value is the amount in wei being sent as a message
        _;
    }
}

contract Register is Owner {
    mapping (address => bool) registeredAddresses;
    uint price;

    constructor (uint initialPrice) {
        price = initialPrice;
    }
    function register() public payable costs(price) { //use custom modifier "costs"
        registeredAddresses[msg.sender] = true;
    }

    function changePrice(uint _price) public onlyOwner { //use custom modifier onlyOwner
        price = _price;
    }

}

contract ViewAndPure {
    uint value;
    function setValue(uint _value) external {
        value = _value;
    }
    //use view when function doesn't change anything outside, but needs to read them
    function getValue() external view returns(uint){
        return value + 8;
    }
    //use pure when function doesen't change nor even need to look at anything outside
    function getFixed() external pure returns(uint){
        return 2+3;
    }
}


//--------------------Fallback Functions--------------------
    // Don't have a name, don't take inputs, don't return outputs and are declared as external
/*contract FallBack {
    event Log(uint gas);
    fallback() external payable {
    // Fallback functions will fail if it uses too much gas, so be succint
        emit Log( gasleft() );
        //gasleft is a special function
    }
    function getBalance() public view returns(uint) {
        //return the stored balance of the contract
        return address(this).balance; //The "this" keyword refers to the contract its in
    }
}*/

contract SendToFallBack {
//To send ether to a contract, we can use send, transfer or call methods

    //Test sending ether via the transfer method (makes 2300 gas available)
    function transferToFallBack(address payable _to) public payable {
        _to.transfer(msg.value);
    }
    //Test sending ether via the call method (all gas is available)
    function callToFallBack(address payable _to) public payable {
        (bool sent,) = _to.call{value:msg.value}('');
        require(sent, 'Failed to send!');
    } 
}

contract FunctionOverloading {
//function definitions need to differ either by function name, or by type or # of arguments
    function x(bool lightSwitch) public {
    }
    function x(uint wallet) public {
    }
    function x(uint wallet, uint banana) public {
    }
    function Originality(uint a, uint b) public pure returns(uint) {
        return a + b;
    }
    function Originality(uint a, uint b, uint c) public pure returns(uint) {
        return a + b + c;
    }
    function SumOfTwo() public pure returns(uint) {
        return Originality(3, 28);
    }
    function SumOfThree() public pure returns(uint) {
        return Originality(2, 5, 17);
    }
}

//--------------------Cryptographic Hash Functions (CHF)--------------------
// Hashes are one-way functions that map inputs of arbitrary length to outputs of fixed length
//Solidity's inbuilt cryptographic functions compute the hash of an input. These are:
    // keccak256 (bytes memory), it returns (bytes32)
    // sha256 (bytes memory), it returns (bytes32)
    // ripemd160 (bytes memory), it returns (bytes20)
contract GenerateRandomNumber {
    
    Oracle oracle;
    
    constructor(address oracleAddress) {
        oracle = Oracle(oracleAddress);
    }

    function randMod(uint range) external view returns(uint) {
        //abi.encodePacked can concatenate arguments nicely
        return uint(keccak256(abi.encodePacked(oracle.rand, block.timestamp, block.difficulty, msg.sender)))
        % range;

    }
}

//The three intergers used to generate the randomness could all be easily guessed
//We can add a more secure element to the concatenation by getting live data from an oracle:
contract Oracle {

    address admin;
    uint public rand;

    constructor () {
        admin = msg.sender;
    }

    function SetInt (uint _rand) external {
        require(msg.sender == admin);
        rand = _rand;
    }

}