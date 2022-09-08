// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/Pobut.sol";

contract PobutTest is Test {
    Pobut public pobut;
    function setUp() public {
        pobut = new Pobut();
        pobut.createProject("pobut", "https://bafybeiepxoh3tvpuugj2yckyg5avapoldby5ossvstnvwfgs4fxvtotzlm.ipfs.nftstorage.link/");
    }

    function testUpdate() public {
        pobut.updateProject(1, "pobut.me", "ipfs://bafybeiepxoh3tvpuugj2yckyg5avapoldby5ossvstnvwfgs4fxvtotzlm");
        (, , string memory name, ,) = pobut.getProject(1, false);
        assertEq(name, "pobut.me");
    }
}
