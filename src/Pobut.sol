// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import { IPool } from "@aave/core-v3/contracts/interfaces/IPool.sol";
import { IPoolAddressesProvider } from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import { IAToken } from "@aave/core-v3/contracts/interfaces/IAToken.sol";

import { PobutProject } from "./PobutProject.sol";

interface IERC20 {
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

contract Pobut {
    
    uint256 id;
    mapping(uint256 => address) projects; // ID => Project

    constructor() {}

    function createProject(string calldata name_, string calldata image_) public {
        PobutProject pp = new PobutProject(msg.sender, name_, image_);
        id++;
        projects[id] = address(pp);
    }

    function updateProject(uint256 id_, string calldata name_, string calldata image_) public {
        PobutProject project = PobutProject(projects[id_]);
        require(project.owner() == msg.sender, "Only Owner");
        project.update(name_, image_);
    }

    function getProject(uint256 id_, bool desc) view public returns(address wallet, address owner, string memory name, string memory image, uint256 date) {
        if (desc) {
            id_ = id > 0 && id_ > 0 && id >= id_ ? id - id_ + 1 : 0;
        }
        PobutProject project = PobutProject(projects[id_]);
        wallet = address(project);
        owner = project.owner();
        name = project.name();
        image = project.image();
        date = project.date();
    }

    function getPool(uint256 id_, address asset_, uint256 amount_) public returns(address) {
        IPoolAddressesProvider provider = IPoolAddressesProvider(address(0xc4dCB5126a3AfEd129BC3668Ea19285A9f56D15D));
        return provider.getPool();
    }

    function deposit(uint256 id_, address asset_, uint256 amount_) public {
        require(projects[id_] != address(0), "Project Not Found");

        PobutProject project = PobutProject(projects[id_]);

        IPoolAddressesProvider provider = IPoolAddressesProvider(address(0xc4dCB5126a3AfEd129BC3668Ea19285A9f56D15D));
        IPool pool = IPool(provider.getPool());

        IERC20(asset_).transferFrom(msg.sender, address(this), amount_);

        if (IERC20(asset_).allowance(address(this), address(pool)) == 0) {
            IERC20(asset_).approve(address(pool), type(uint256).max);
        }

        pool.deposit(asset_, amount_, address(project), 0);
    }

    function withdraw(uint256 id_, address asset_) public {
        PobutProject project = PobutProject(projects[id_]);

        require(projects[id_] != address(0), "Project Not Found");
        require(projects[id_].owner == msg.sender, "Only Owner");

        IPoolAddressesProvider provider = IPoolAddressesProvider(address(0xc4dCB5126a3AfEd129BC3668Ea19285A9f56D15D));
        IPool pool = IPool(provider.getPool());

        pool.withdraw(asset_, type(uint256).max, msg.sender);
    }
}
