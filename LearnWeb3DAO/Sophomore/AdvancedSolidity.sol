// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/************************************************
1)  Mappings
2)  Memory vs Storage
3)  Enums
4)  Structs
5)  View and Pure Functions
6)  Constructurs
7)  Modifiers
8)  Inheritance
9)  How to transfer ETH from a smart contract
10) Import statements
11) Libraries
12) Calling external smart contracts
13) Events
**************************************************/

contract Mapping {
    // Mapping is like a python dictionary or a javascript object
    // Set mood like in the Freshman track, but here each address records a different mood
    mapping(address => string) public moods;
    //access someone's mood like this:
    // moods[0xABCDEF....] => string;
    function getMood(address user) public view returns (string memory) { return moods[user];}
    function setMood(string memory mood) public { moods[msg.sender] = mood; }
}

contract MemoryAndStorage {

    /* Solidity has three types of 'storing' locations for variables: Memory/Storage/Calldata

    Where is info stored in a computer?
    a) The CPU Cache: A CPU has a small but very fast storage directly on the processor
        Modern processors tend to have L1, L2, L3 Cache...
        Used for info being used very frequently by processor right now
    b) RAM: average amount of storage (far more than CPU), average speed
        Slower than CPU Cache, as electricity has to flow through circuitboard and back
        Used when we want to run things decently fast, like web browser data
    c) Hard Disk / SSD: much more storage, much slower than RAM
        Used for longterm storage, like documents and files
    
    What are the lower level differences between variable types?
    a) uint - fixed size
    b) address - fixed size
    c) string - arbitrary size (dynamic)
    
    Where do things get stored?
    a) Local unit or address variables (declared in a function)
        ...are saved to the stack (inside the Cache)
    b) Local string variables (declared in a function)
        ...are saved to the heap (inside the RAM) aka MEMORY
    c) Global variables of any kind (declared in a contract)
        ...are saved to the hard disk
    */
}

contract Enums {

    /* Short for Enumerator, they are human readable types for a set of values
        It's just a redability thing - solidity will see them as numbers.
        e.g. Build a To Do app that keeps statuses: 0)ToDo, 1)Inprogress, 2)Done, 3)Canceled
    */

    // First create a Status enum 
    enum Status {
        ToDo, //0 Behind the scenes, solidity sees enums as numbers
        InProgress, //1
        Done, //2
        Canceled //3
    }

    // Then make a map ID to Status
    mapping(uint256 => Status) todos;

    function addTask (uint256 id) public {
        todos[id] = Status.ToDo;
    }

    function updateStatus(uint256 id, Status newStatus) public {
        todos[id] = newStatus;
    }

    function getStatus(uint256 id) public view returns (Status) {
        return todos[id];
    }

}

contract Structs {
    /*
    Structs are data structures
        They are like python dataclasses,
        or like javascript classes but without methods defined on them
    AND THEY ARE MORE GAS EFFICIENT

    Let's use same e.g. as above: ToDo app. What data do we need?
        - Task description
        - Task status
        - Task ID
        - Task title
    */
    
    // First let's define an enum for the possible types of statuses
    enum Status { ToDo, InProgress, Done, Canceled }

    //Second, we create a struct for each of the datapoints we want for each task
    struct Task {
        string title;
        string description;
        Status status;
        bool existing; //without this there would be a risk:
        //...If people search a random id, they will get default values for all mappings
        //...which is empty strings, 0 uints, and the first element in enums
        //...so it would appear as though that random inexistent id was in the list of to dos
        //...since ToDo is the first option in our Status enum
    }

    //Third, we can do a single mapping to the struct, instead of three separate mappings
    mapping(uint256 => Task) tasks;

    function addTask (uint _id, string memory _title, string memory _description) public {
        // There are 3 ways to initialise a struct variable:

        // METHOD 1 - works only if you specify variables in order
        // tasks[_id] = Task(_title, _description, Status.ToDo);

        // METHOD 2 (best one)
        tasks[_id] = Task({
            title: _title,
            description: _description,
            status: Status.ToDo,
            existing: true //chacks the boolean set in the struct
        });

        // METHOD 3 - define and empty struct, then set values individually
        // Task memory singleTask;
        // singleTask.title = _title;
        // singleTask.description = _description;
        // singleTask.status = Status.ToDo;

        // tasks[_id] = singleTask;
    }

    function deleteTask(uint256 _id) public {
        delete tasks[_id];
    }

    function editTaskTitle (uint256 _id, string memory _title) public {
        tasks[_id].title = _title;
    }
    /* Difference between Enums and Structs:
    Struct is a user-defined data type that is a collection of dissimilar data types.
    Enum is to define a collection of options available.
    A struct can contain both data variables and methods. Enum can only contain data types. */
}

contract ViewAndPureFunctions {

    /* What are Side Effects in computer science?
    ...they're things that change the value of a variable beyond the current scope */
    uint y;
    function someFunction() public {
        uint x;
        x = 5; //NOT a side effect
        y = 5; //IS a side effect - it changes the value of a state variable
    }

    /* There are keywords to specify the allowed side effects of a function:
        1) 'view' function - reads from state, but does not write to state. Free (no gas)
        2) 'pure' function - Does not read from or write to state. Free (no gas)
        3) No keyword - can read from and write to state

    */

}

contract Constructors {
    /* A constructor is a function that only runs once when a contract gets deployed
        In it, you can do things like declare the owner or admin (see below)
        N.B. msg.sender refers to the wallet who called a function,
            ...so it can only be called inside a function (or constructor in this case)
    */
}

contract Modifiers {
    /* Modifiers are pieces of code that can be run before or after any other function call
        A function CAN use multiple modifiers
        Modifiers CAN have arguements

        Typical uses:
            a) restricting access to functions (e.g. onlyOwner)
            b) validating the input of certain paramters
                (e.g. does an id exist? e.g. is an address in whitelist?)
            c) preventing certain types of attacks (e.g. reentrancy attack)
    */
    address owner;
    constructor() { owner = msg.sender; }
    modifier onlyOwner() { require(msg.sender==owner, "Unauthorised"); _;}
    // The Underscore keyword can only be used in the case of a modifier
    //  ...it means 'run the rest of the code here'

    function someFunction1() public onlyOwner {}
    function someFunction2() public onlyOwner {}
    function someFunction3() public onlyOwner {}

    // Without the modifier, the require line would be written within each of the 3 functions
    // ...which is gas inefficient.

    //The modifier can be set so the function runs after it, before it, or in the middle
    modifier funcBeforeMod() {
        _;
        // write the modifier's code here - it will run after the function
    }
    modifier funcBetweenMod() {
        // first block of code;
        _;
        // second block of code;
    }

}

contract Inheritance {
    //To keep things clean, the inheritance notes were saved in Inheritance.sol
}

contract ETHSender {
    /* The .call Method
        There are 3 ways to send ETH from a contract, due to Solidity upgrades.
        ...2 of the 3 methods are no longer recommended. We'll only look at the .call method

        (payable address).call{ value: amount }("");
        .call() will return 2 variables:
        a boolean indicating success or failure AND the second is some bytes that have data
        ...the latter is written 'bytes memory data'
        ...we can ignore the second value, but keep the comma
    */
    function mirror() public payable {
        //receives some ETH
        address payable target = payable(msg.sender);
        //sends the ETH back
        uint256 amount = msg.value;
        (bool success, ) = target.call{value: amount}("");
        require (success, "FAILURE");

    } //N.B. Both functions and addresses have to be marked payable to receive ETH
}

contract ImportStatements {
    // There are 2 kinds of imports:
        // Local Import (your own solidity file): e.g. import "./Inheritance.sol";
        // External Import (e.g. from a github URL): e.g. import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

    // When using Hardhat, we use OpenZeppelin contracts, but we don't import them externally.
    // We download OpenZeppelin contracts as a node package through npm, then import them locally.
    // e.g. import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
}

contract Libraries {
    /* There are 3 top-level constructs in  Solidity
        1) Contracts
        2) Interfaces
        3) Libraries
    
        What is a Library?
        - Used to add some helper functions to your contracts
        - All it does is have some functions that take some input and return some output
        - Limitation - you can't have any state
            ...so no state variables, no mappings/arrays/structs
            ...all functions are pure
        
        Before Solidity 0.8, a common library was called 'Safemath'
            -it ensured all mathematical operations were 'valid'
                ...and there was no interger underflow/overflow
        From Solidity 0.8 onwards, Safemath is built in, so we don't use the library anymore

        Why do we need protection from overflows?
            Imagine we have a uint8, which holds values from 0 to (2^8)-1 or 255. So for example:
                uint8 a = 254;
                uint8 b = 5;
                uint c = a + b;
                Pre Solidity v0.8, c would be equal to 4, not 259, due to an overflow
                Now these checks are built-in

        
        We recreate a simplified version of Safemath below and call it from this function here
    */

    function testAdd (uint x, uint y) public pure returns (uint) {
        return Safemath.add(x, y);
    }
}
library Safemath {
    function add(uint x, uint y) internal pure returns (uint) {
        uint z = x + y;
        require(z >= x, "overflow happened");
        require(z >= y, "overflow happened");
        return z;
    }
}

contract ExternalCaller {
    /* Contracts can call another contract's functions on an instance of that contract
    Contract B can call function foo() on contract like so A.foo() but you need an interface

    What is an interface? - It's like an ABI to a contract
    - It defines function declarations
        1) What is the name of the function present in this contract
        2) What are the input values
        3) What is the return value
        4) What is the visibility (public, private, external)
        5) What is the mutability (view, pure, neither)

    e.g. If we want to see our balance:
    1) ERC20 contracts have a function called balanceOf. To call it, we need an interface (below)
    2) The constructor let's the user insert what contract we're looking at
    */

    MinimalERC20 externalContract; // State variable of the type MinimalERC20:

    constructor (address someERC20Contract) {externalContract = MinimalERC20(someERC20Contract);}
    
    function doIHaveBalance() public view {
        uint balance = externalContract.balanceOf(msg.sender);
        require(balance > 0, "You don't have tokens.");
    }
}
interface MinimalERC20 {
    // Only include function definitions for the functions we care about
    function balanceOf (address account) external view returns (uint256);
}

contract Events {
    /* What are Events? - Logs on the Ethereum Blockcahin
        - Can be used to log info as a proof of history that something happened at that time
        - They have a name and arguments that you want to log
        - They are better (in terms of gas costs) than storing infinitely growing arrays
            ...saving to contract storage is expensive
            ...events get stored on the blockchain, but outside of contracts

        e.g. History of a token changing hands over time
    */
    event Transfer (address from, address to);

    address ownerOfNFT;

    function transfer(address newOwner) public {
        require (msg.sender == ownerOfNFT, "You cannot transfer this token.");
        ownerOfNFT = newOwner;
        emit Transfer(msg.sender, newOwner);
    }
}