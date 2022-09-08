// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract PobutProject {

    address public factory;
    address public owner;
    string public name;
    string public image;
    uint256 public date;

    modifier onlyFactory() {
        require(msg.sender == factory);
        _;
    }

    constructor(address owner_, string memory name_, string memory image_) {
        factory = msg.sender;
        owner = owner_;
        name = name_;
        image = image_;
        date = block.timestamp;
    }

    function update(string memory name_, string memory image_) public onlyFactory {
        name = name_;
        image = image_;
    }
}
