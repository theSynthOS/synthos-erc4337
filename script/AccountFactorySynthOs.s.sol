// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {AccountFactorySynthOs} from "../src/AccountFactorySynthOs.sol";

contract AccountFactorySynthOsScript is Script {
    AccountFactorySynthOs public accountFactorySynthOs;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address defaultAdmin = 0x34553Be327C085AfD43bbc3Fc1681FfC3CC9287A;
        address entryPoint = 0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789;

        accountFactorySynthOs = new AccountFactorySynthOs(defaultAdmin, entryPoint);

        address policyCordinator = 0x0000000000000000000000000000000000000000;
        accountFactorySynthOs.setPolicyCordinator(policyCordinator);

        vm.stopBroadcast();
    }
}
