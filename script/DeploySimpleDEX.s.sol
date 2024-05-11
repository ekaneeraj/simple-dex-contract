// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import { Script } from "forge-std/Script.sol";
import { ISimpleDEX } from "../src/interfaces/ISimpleDEX.sol";

contract DeploySimpleDEX is Script {
    uint256 public constant INITIAL_SUPPLY = 1_000_000 ether;
    uint256 public constant DEFAULT_ANVIL_PRIVATE_KEY =  vm.envUint("ANVIL_PRIVATE_KEY");
    uint256 public deployerKey;

    function run() external returns (ISimpleDEX) {
        if (block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
        }

        vm.startBroadcast(deployerKey);
        ISimpleDEX simpleDEXToken = new ISimpleDEX(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return simpleDEXToken;
    }
}