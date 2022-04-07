// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

/////////////////////////////////////////////////////////////////////////////////////////deca//
/////////////////////////////    SYNTAX 5 (from Udemy Course)   ///////////////////////////////
/////////////////    Abstractions, Interfaces, Uniswap exercise, Libraries    /////////////////
/////////////////////////    Assembly & EVM OpCodes, Error handling    ////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////



//--------------------ABSTRACT CONTRACTS--------------------
    //An abstract contract is one that contains at least one function without any implementation
        //It's usually a base contract (not a derived contract)
        //A derived contract will then implement the abstract function
        //...and use any other functions from the base contract as needed

abstract contract X {
    function y() public view virtual returns (string memory);
}

contract Z is X {
    function y() public override pure returns (string memory) {return 'hello';}
}

//Contract X won't deploy. If we want to deploy it, remove "abstract" and replace ; with {}
/*contract X {
    function y() public view virtual returns (string memory){}
}*/

contract Member {
    string name;
    uint age = 38;
    function setName() public  virtual returns(string memory) {}
    function returnAge() public view returns(uint) {return age;}
}

contract Teacher is Member {
    function setName() public pure override returns(string memory) {return 'Gordon';}
}

//--------------------INTERFACES--------------------
    //Used to connect info (interface two contracts to eachother) - no need to copy/paste code
    //Interfaces are created with the interface keyword & they are similar to abstract contracts
        //They can't have state variables, nor constructors
        //They can have enums or structs, which are accessed through interface name dot notation
        //They can't have virtual functions (with no implementation)
        //Their functions can only be external

contract Counter {
    uint public count;
    function increment() external {count += 1;}
}
interface ICounter {
    function count() external view returns(uint);
    function increment() external;
}
contract MyContract {
    function incrementCounter(address _counter) external {
        //Here we interface: use the increment function without inheriting it
        ICounter(_counter).increment();
    }
    function getCount(address _counter) external view returns(uint) {
        return ICounter(_counter).count();
    }
}


//--------------------UNISWAP EXERCISE--------------------
    // Create 2 interfaces holding separate FUNCTION SIGNATURES (found in Uniswap V2 docs)
    // ...one interface will get pairs and the other will get reserve values
interface UniswapV2Factory {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}
interface UniswapV2Pair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}
    // Create a contract containing token addresses, and the factory address
    // ...(find all addresses on etherscan.io)
contract ReturnResVal {
    address private factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    // Within the contract, make a function to get the TOKEN PAIRS and set to an ADDRESS
    function getReserveTokens() external view returns(uint, uint) {
        address pair = UniswapV2Factory(factory).getPair(dai, weth);
    // Use that address to get and return the RESERVE VALUES
        (uint reserve0, uint reserve1,) = UniswapV2Pair(pair).getReserves();
        // The getReserves function has 3 arguments, so we put a comma after "reserve1"
        // ...which defaults to fill the third argument
        return (reserve0, reserve1);
    }
}
    // Switch to Injected Web3 and go to Mainnet on Metamask
    // Open contract UniswapV2Factory & paste the factory address in "At Address" (DON'T DEPLOY)
    // Paste dai and weth addresses into the getPair function
    // Open contract UniswapV2Pair & paste the pair address in "At Address" (DON'T DEPLOY)
    //Run getReserves function



//--------------------LIBRARIES--------------------
    // They are used to store functions that other contracts can use
    // Restrictions:
        // Library functions can be called directly ONLY IF they don't modify the state
            // ... i.e. pure and view functions can only be called from outside the library
        // Libraries are assumed to be stateless
            // ... so can't be destroyed, can't have state variables
        // Libraries can't inherit any element AND they can't be inherited

//create a library that can search through a database
library Search {
    //Create a loop that returns the index of an interger we're looking for
    function indexOf(uint[] storage self, uint value) public view returns(uint index) {
        for(uint i=0; i<self.length; i++) if(self[i] == value) return i;
    }
}

contract LibTest {
    uint[] data;
    constructor() {
        data.push(1);
        data.push(2);
        data.push(3);
        data.push(4);
        data.push(5);
    }
    function indexOfValue(uint val) external view returns(uint) {
        uint value = val;
        uint index = Search.indexOf(data, value);
        return index;
    }
}

// A for B Pattern - i.e. Attach functions from a library A to a type B
    // No need to call the library itself anymore

library Search2 {
    function indexOf(uint[] storage self, uint value) public view returns(uint Index2) {
        for(uint i=0; i<self.length; i++) if(self[i] == value) return i;
    }
}

contract LibTest2 {
    using Search2 for uint[];
    uint[] data;
    constructor() {
        data.push(1);
        data.push(2);
        data.push(3);
        data.push(4);
        data.push(5);
    }
    function IndexOf4() external view returns(uint) {
        uint a = 4;
        return data.indexOf(a);
    }
}


//--------------------ASSEMBLY & EVM OPCODES--------------------
    // Solidity gets compiled down to Assembly, which is a lower level language
    // Find OpCodes at https://ethervm.io
    // In EVM, everything is stored in 256 bit slots ...e.g. an array will take up several slots

contract LearnAssembly {
    function addToEVM () external {
        uint x;
        uint y;
        //uint z = x + y;

        assembly {
        //Declared an assembly block, interpreted in the assembly language

            let z := add(x,y)
            //There's no semicolons. We can use Op Codes. Syntax for equals is :=

            let a := mload(0x40)
            //Load up data using temporary memory slot, with special address 0x40

            //Store something temporarily to memory (value, payload)
            mstore(a,4)

            //Persistant storage
            sstore(a,7)
        }
    }
    function addToEVM2(address addr) public view returns(bool success) {
        uint size;
        addr;
        // Check whether an address contains any bytes of code
        // ...good way to tell apart wallet addresses or contract addresses
        // ...unless hackers are disguising this by hiding info in constructors
        assembly {
            size := extcodesize(addr)
        }
        if(size > 0) {return true;
        } else {
            return false;
        }
    }

    function addToEVM3() external pure {
    // Convert data type from bytes memory to bytes32

        //bytes memory data = new bytes(10);  
        // This is how you'd do it in Solidity, but it won't allow explicit type conversions:
        // bytes32 dataB32 = bytes32(data);

        assembly {
            // Bytes in memory size start at second slot
            // ...so "add 32" to start in correct position
            // ...i.e. for mload to read from correct memory location
            //dataB32 := mload(add(data, 32))
        }
    }
}


//--------------------ERROR HANDLING--------------------
    // Important methods for error handling:
        // assert(bool condition) ...used for internal errors
            // If boolean is false, we get an opcode that reverts changes to the state
        // require(bool condition)
            // Like assert but less extreme
        // require(bool condition, string memory message)
            // Includes a custom message for the user
        // revert()
            // Aborts execution
        // revert(string memory reason) 
            // Includes a custom message for the user


contract ErrorHandling {
    bool public sunny = true;
    bool umbrella = false;
    uint finalCalc = 0;
    function weatherChanger() public view {sunny != sunny;}
    function getCalc() public view returns (uint) { return finalCalc; }

    function solarCalc() public {
        require(sunny, 'It is not sunny today');
        finalCalc += 3;
        //e.g. we want to assert that finalCalc can never be 6
        assert(finalCalc != 6);
    }
    function bringUmbrella() public {
        if (!sunny) { umbrella = true; }
        else { revert('No need to bring an umbrella today'); }
    }
}

contract Vendor {
    address seller;
    modifier onlySeller { require(msg.sender == seller); _; }

    function becomeSeller() public { seller = msg.sender; }

    function sell(uint amount) public payable onlySeller {
        if (amount > msg.value) { revert('There is not enough ether provided'); }
    }

}


