// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;
//Another way to specify the version is:
//pragma solidity ^0.7.0; (which means higher than)

/////////////////////////////////////////////////////////////////////////////////////////deca//
///////////////////////////////    SYNTAX 1 (from Udemy Course)   /////////////////////////////
////////    variables, arithmetic, if statement, require method, assignment, modulo    ////////
//////////////////////////////    arrays, for loops, strings    ///////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////


contract NameOfTheContract {
    uint WalletBalance = 500;
    uint x = 4;
    bool TransactionCompleted = false;
    string NotifyTransactionCompleted = "The transaction was successful.";

//----------VARIABLES----------
    //bool, string, bytes, uint (no fractions in solidity)

    
    function SimpleOperation() public view returns(uint) {
        //Input (aurguments or parameters in the parentheses after the function's name) and output (returns)
        uint PurchaseCost = 20;
        uint NewBalance = WalletBalance - PurchaseCost;
        return NewBalance;
    }
    
    function MultiplyCalculator(uint a, uint b) public pure returns(uint) {
        uint Multiply = a * b;
        return Multiply;
    }
    
    uint StakingWallet = 9;
    uint Airdrop;
    function ConditionalStatement() public returns(uint) {
        // = assings, == equivalates
        if(StakingWallet >= 10){
            Airdrop = 10;
        } else {
            Airdrop = 1;
        }
        uint NewWalletBalance = StakingWallet + Airdrop;
        return NewWalletBalance;
    }
    
//----------SCOPE----------

    //local vs state variable
        //A local variable is inside a function and a state variable is outside
        //A local change to a variable will update the state variable also

    //public vs private vs external vs internal function or variable
        //Set to public: you can call on state variables in the function
        //Set to private: the variable or function won't show, but you can call it from other functions or variables
        //Set to external: you can only access it from outside the contract
        //Set to internal: you can only access it from within the contract

    //view vs pure function
        //Set function to view = it will not modify the State (return functions)
        //Set function to pure = it will not read or modify the State (return calculations)
        

        
//----------OPERATORS----------
    //Arithmetic: + - * / % (remainder) ++ (+1) -- (-1)
    //Comparison: == != < > <= >=
    //Logical: && (and) || (or) ! (not)
    //Assignment: = += *= /=
        // e.g. x = 7   # assigns the value, 7, to x
        //      x += 4  # adds 4 to 7, and assigns the result, 11, to 
    
    function Logic() public view returns(uint){
        uint Result;
        if (x < WalletBalance && x == 4) {
            return Result = x + WalletBalance;
        } else {
            return WalletBalance;
        }
        
    }
    
//----------METHODS----------
    //require: the function will only run if the conditional is correct
    
    function Methonds() public view {
        require(x > WalletBalance, "That is false.");
    }

    function Assign() public pure returns(uint) {
        uint c = 3;
        return c = c + 1;
    }
    
    function CheckMultipleValidity(uint Small, uint Large) public pure returns(bool) {
        if(Large % Small == 0) {
            return true;
        } else {
            return false;
        }
    }//end of function
    
//----------ARRAYS----------
    //a list, uses square brackets

    uint [] public NumbersList = [1,2,3,4,5,6,7,8,9,10];
    function ForLoop(uint SomeNumber) public view returns(uint) {
        uint Count = 0;
        //for loops have 3 part statements:
        //First initialise start of loop, Second determine length of loop, Direct index after each turn
        for(uint i = 1; i < NumbersList.length; i++) {
            if (CheckMultipleValidity(NumbersList[i], SomeNumber)) {
                Count++;
            }
        }
        return Count;
    }//end of function
    
    uint [] BingoList = [4, 25, 34, 56];
    function BingoLoop(uint Play) public view returns(bool) {
        bool ItsABingo = false;
        for(uint i = 0; i < BingoList.length; i++){
            if(BingoList[i] == Play) {
                ItsABingo = true;
            }//end if statement
        }//end for loop
        return ItsABingo;
    }//end of function
    
    uint [] LongList = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
    function EvenCount() public view returns(uint) {
        uint Count = 0;
        for(uint i = 0; i < LongList.length; i++) {
            if((LongList[i] % 2) == 0) {
                Count++;
            }//end of if statement
        }//end for loop
        return Count;
    }//end of function
    
//----------MEMORY & STORAGE (like RAM)----------
    //Memory =  saves something for the duration of a contract 
    //Storage = saves something only for the duration of the function call

    string Message = "Hello!";
    function ReturnMessage() public view returns(string memory) {
        return Message;
    }
    function ChangeMessage(string memory UserInput) public {
        Message = UserInput;
    }
//----------STRINGS----------
    //Strings in Solidity are too computationally expensive to get length... so convert strings to bytes first
        //Watch out for weird characters when converting strings to bytes as they might not register
    //Quotations or apostrophe in strings: Use \ to skip a character. Use \n to skip a line.
        //e.g.1. "Hello, you\'re here now"
        //e.g.2. "She said \"Hello!\""
        //e.g.3. "She said \nHello" (check this works?)

    function StringLength() public view returns(uint) {
        bytes memory StringToBytes = bytes (Message);
        return StringToBytes.length;
    }
    
}



