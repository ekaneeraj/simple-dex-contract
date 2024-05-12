// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {Script} from "forge-std/Script.sol";
import {SimpleDEX} from "../src/SimpleDEX.sol";
import {TokenA} from "../src/TokenA.sol";
import {TokenB} from "../src/TokenB.sol";

contract DeploySimpleDEX is Script {
    uint256 public deployerKey;

    struct DeployedAddresses {
        address simpleDEX;
        address tokenA;
        address tokenB;
        address admin;
    }

    DeployedAddresses public deployedAddresses;

    function run() external returns (SimpleDEX, DeployedAddresses memory) {
        if (block.chainid == 31337) {
            deployerKey = vm.envUint("ANVIL_KEY");
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
        }

        vm.startBroadcast(deployerKey);
        TokenA tokenA = new TokenA();
        TokenB tokenB = new TokenB();
        SimpleDEX simpleDEXToken = new SimpleDEX(address(tokenA), address(tokenB), 100);
        vm.stopBroadcast();
        return (
            simpleDEXToken,
            DeployedAddresses({
                simpleDEX: address(simpleDEXToken),
                tokenA: address(tokenA),
                tokenB: address(tokenB),
                admin: vm.addr(vm.envUint("ANVIL_KEY"))
            })
        );
    }
}
