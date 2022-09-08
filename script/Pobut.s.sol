// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Script.sol";
import "../src/Pobut.sol";

contract PobutScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        new Pobut();
    }
}
