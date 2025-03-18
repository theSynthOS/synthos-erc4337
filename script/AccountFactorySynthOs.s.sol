// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {AccountFactorySynthOs} from "../src/AccountFactorySynthOs.sol";
import "@thirdweb/contracts/prebuilts/account/interface/IEntrypoint.sol";
import {TaskRegistry} from "../src/TaskRegistry.sol";

contract AccountFactorySynthOsScript is Script {
    AccountFactorySynthOs public accountFactorySynthOs;
    IEntryPoint public IentryPoint;
    TaskRegistry public taskRegistry;
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // taskRegistry = new TaskRegistry();

        address defaultAdmin = 0x34553Be327C085AfD43bbc3Fc1681FfC3CC9287A;
        address entryPoint = 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789;
        IentryPoint = IEntryPoint(entryPoint);
        accountFactorySynthOs = new AccountFactorySynthOs(defaultAdmin, IentryPoint);

        // address policyCordinator = 0xeb0d8736Cc2c47882f112507cc8A3355d37D2413;
        // accountFactorySynthOs.setPolicyCordinator(policyCordinator);

        vm.stopBroadcast();
    }
}
