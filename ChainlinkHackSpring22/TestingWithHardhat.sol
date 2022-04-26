// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

/*
Testing with Hardhat codealong 25th April 2022
https://www.youtube.com/watch?v=dDr7glOjtvI&ab_channel=Chainlink

OUR FLOW, Test Driven Development (TDD):
    1) Write your tests for each usecase (types of tests described below)
    2) Deployed functionality in smart contract - all tests will fail because there is no implementation in our smart contract
    3) Write the implementation until it satisfies all tests.

TYPES OF TESTS
    1) Unit Tests:
        Within a local blockcahin (Hardhat node), test one deployed contract and the rest as mocks
    2) Integration Tests:
        Local blockchain, but this time all contracts are deployed
    3) End-to-end tests:
        All contracts deployed, but this time on a Mainnet Fork
        ...i.e. copy whole state of the mainnet in a specific block
        Why? Locally there aren't other protocols affecting mainnet state, so it sin't a faithful replica
    4) Property-based tests:
        aka "fuzz tests" look at edge cases
        ...the fuzzer generates random inputs for our smart contracts to stress test it

FIXTURES
    They are testing scenarios that are executed once and then remembered by making snapshots of the blockchain
    Why? Make testing faster by avoiding repetition
    e.g. deploy token or mint NFT before doing all other tests. With fixtures, you can mint only once

TOOLS FOR TESTING WITH HARDHAT
    1) Waffle: library for writing and testing smart contracts
    2) Mocha: Javascript/Typescript testing framework for browser or node.js
    3) Chai: assertion library for browser or node.js - i.e. used to assert conditions (==)

CODE COVERAGE
    Check % of source code executed during a test - aim hor more than 90%

*/

contract abc {

}