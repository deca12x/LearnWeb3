// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// PART OF THE NOTES FROM THE AdvancedSolidity.sol
// Copied here to keep things clean in main file

    /* Takes all attributes (variables) and methods (functions) from a contract to another
        A child contract can inherit from multiple parent contracts
        A child contract can override a function from the parent contract
        ...ONLY IF the function is marked as 'virtual'
    */

contract A {
//Top level parent contract
    function foo() public pure virtual returns (string memory) {
        return "contract A";
    }
}

contract B is A {
//Override A.foo();
    function foo() public pure override returns (string memory) {
        return "contract B";
    }
}

contract C is A {
//Override A.foo() but C.foo() can also be later overwritten
    function foo() public pure virtual override returns (string memory) {
        return "contract C";
    }
}

contract D is A, C {
//Inherit from both A and C
    function foo() public pure override (A, C) returns (string memory) {
        // Use special keyword 'super' to call your parent's functions
        return super.foo(); //This will return C because of the order
    }
}