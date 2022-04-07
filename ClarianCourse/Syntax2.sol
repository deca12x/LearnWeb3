// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

/////////////////////////////////////////////////////////////////////////////////////////deca//
/////////////////////////////    SYNTAX 2 (from Udemy Course)   ///////////////////////////////
////    constructors, inheritance, arrays, enums, structs, mapping, conversions, assert    ////
///////////////////////////////////////////////////////////////////////////////////////////////


//----------CONSTRUCTORS----------
    //They are a special function. There can only be one per contract.
        //It's executed once when the contract is created, then the final code is deployed to the blockchain
        //Constructor code or any internal method used only by the constructor are not included in final code
        //It's used to initialize the contract state
        //A constructor can be public or internal (the latter makes the contract abstract)
    //In case no constructor is defined, the contract will execute a default constructor

/*contract Base {
    //stores fully accessible data upon deployment
    uint OutputNumber;
    constructor(uint Five) public {
        OutputNumber = Five;
    }
}

//You can call the constructor with INHERITANCE:
contract Derive1 is Base (5) {
    //output data to number 5
    function ReturnNumber() public view returns (uint) {
        return OutputNumber;
    }
}

contract Derive2 is Base {
    //constructor (uint a) Base(a) public {}
    function ReturnNumber() public view returns (uint) {
        return OutputNumber;
    }
}*/

//----------------Follow the steps happening above----------------//
// 1) We inherit Base to Derive2
// 2) In our Derive2 contract's constructor we have an argument where we insert an interger
// 3) ...we are also setting it to our Base contract
// 4) ...which passes it to the Base contract's constructor as the argument
// 5) So, when we deploy the Derive2 contract, we set the interger into the Base contract's state variables
// 6) ...so returning the function OutputNumber will return the interger we assigned


contract LearnArrays {
    uint[] public Array1;
    function TestArrayElements() public {
        Array1 = [1, 2, 3, 4];
    }
    
    //The .push() method adds elements to the end of an array and returns the new length of the array
    function Pusher(uint InsertNumber) public {
        Array1.push(InsertNumber);
    }
    
    //The .pop() method removes the last element from an array and returns that value
    function Popper() public {
        Array1.pop();
    }
    
    //The .length() method determines the length of a string or array. N.B. length starts at 1
    function GetLength() public view returns (uint) {
        return Array1.length;
    }
    
    //The delete operator selects an element in an array, by selecting its index. N.B. indices start at 0
    //...and replaces its value with 0. The array's length stays the same
    function ElementToZero(uint i) public {
        delete Array1[i];
    }
    
    //Use the function below to fully remove an item from an array - i.e. remain compact OR have a compact array
    //N.B. this will change the array's order
    function RemoveElement(uint i) public {
        uint iLast = (Array1.length) - 1;
        Array1[i] = Array1[iLast];
        Array1.pop();
    }
    
    //If you want to view the array
    function ReturnArray1() public view returns(uint[] memory) {
        return Array1;
    }
}

//enums restrict a variable to have one of only a few predefined values - restrict potential bugs in your code
contract LearnEnums {
    enum ShirtColour {Red, White, Blue}
    ShirtColour constant DefaultChoice = ShirtColour.Blue;
    ShirtColour Choice;
    
    function SetWhite() public {
        Choice = ShirtColour.White;
    }
    
    function ReturnChoice() public view returns (ShirtColour) {
        return Choice;
    }
    function ReturnDefaultChoice() public pure returns (uint) {
        return uint (DefaultChoice);
    }

}

// A struct is a type that is used to represent a record. e.g. movies in a library and attributes about each movies
contract LearnStructs {
    
    struct movie {
        uint MovieID;
        string MovieName;
        string MovieDirector;
    }
    
    // Just creating a string or uint variable, with the new movie data type, we can create a movie variable
    movie FirstMovie;
    movie Comedy;
    
    function AddFixedMovies() public {
        FirstMovie = movie (1, "Blade Runner", "Ridley Scott");
        Comedy = movie (2, "Anchorman", "Adam McKay");
    }
    
    function ReturnFirstID() public view returns(uint) {
        return FirstMovie.MovieID;
    }
    
        function ReturnComedyID() public view returns(uint) {
        return Comedy.MovieID;
    }
}

// Mapping is a data type like arrays and structs
//Create a library that has values and keys (used to retreive values)
    // Limitation is we can't loop with mapping
    
contract LearnMapping {
    
    mapping(address => uint) public MyMap;
    //We can tell our map that our keys will be Ethereum wallet addresses (could also be uint, string, bool...)
        //and set to interger values as shown above
        
    function ReturnKey(address MyAddress) public view returns(uint) {
        return MyMap[MyAddress];
        //N.B. if an address is undfined, Solidity will give a key anyway (no error)
    }
    
    function SetAddress(address MyAddress, uint i) public {
        MyMap [MyAddress] = i;
    }
        
    function RemoveAddress(address MyAddress) public {
        delete MyMap [MyAddress];
    }
    
    //JOIN STRUCTS AND MAPPING CONCEPTS
        
    mapping(uint => movie) StructMap;
    
    struct movie {
        string MovieName;
        string MovieDirector;
        
/*    function AddMovies(uint ID, string memory Title, string memory Director) public {
        StructMap [ID] = movie(Title, Director);*/
    }

}

//--------------------CONVERSIONS--------------------
    // INTERGER VARIABLE TYPES uint256, uint128, uint64, uint32, uint16, uint8
    //uint256 is default = just write uint
    //max interger for uint32 is 2^32 -1. Be efficient by using smaller variable types
contract Conversions {

    uint32 a = 0x12345678;
    uint16 b = uint16(a); //b = 0x5678 i.e. loose higher order bits

    uint16 c = 0x1234;
    //uint32 d = uint(c); //d=0x00001234

    bytes2 e = 0x1234;
    bytes1 f = bytes1(e); //f=0x12

    bytes2 g = 0x1234;
    bytes4 h = bytes4(g); //h=0x00001234
}
//--------------------ASSERTIONS--------------------
    //if statement is true, the function will run successfully

contract learnEtherUnits {
    function test() public pure {
        assert(1 wei == 1);
        assert(1 ether == 1e18); // 1 ether = 10^18 wei
        assert(2 ether == 2000000000000000000 wei);
    }
}

//GLOBAL VARIABLES (& SPECIAL VARIABLES)
    //msg.sender msg.value block.timestamp block.number
