// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.12;

// Utils
import "@thirdweb/contracts/prebuilts/account/utils/BaseAccountFactory.sol";
import "@thirdweb/contracts/prebuilts/account/utils/BaseAccount.sol";
import "@thirdweb/contracts/external-deps/openzeppelin/proxy/Clones.sol";

// Extensions
import "@thirdweb/contracts/extension/upgradeable/PermissionsEnumerable.sol";
import "@thirdweb/contracts/extension/upgradeable/ContractMetadata.sol";

// Interface
import "@thirdweb/contracts/prebuilts/account/interface/IEntrypoint.sol";

// Smart wallet implementation
import { Account } from "@thirdweb/contracts/prebuilts/account/non-upgradeable/Account.sol";

//   $$\     $$\       $$\                 $$\                         $$\
//   $$ |    $$ |      \__|                $$ |                        $$ |
// $$$$$$\   $$$$$$$\  $$\  $$$$$$\   $$$$$$$ |$$\  $$\  $$\  $$$$$$\  $$$$$$$\
// \_$$  _|  $$  __$$\ $$ |$$  __$$\ $$  __$$ |$$ | $$ | $$ |$$  __$$\ $$  __$$\
//   $$ |    $$ |  $$ |$$ |$$ |  \__|$$ /  $$ |$$ | $$ | $$ |$$$$$$$$ |$$ |  $$ |
//   $$ |$$\ $$ |  $$ |$$ |$$ |      $$ |  $$ |$$ | $$ | $$ |$$   ____|$$ |  $$ |
//   \$$$$  |$$ |  $$ |$$ |$$ |      \$$$$$$$ |\$$$$$\$$$$  |\$$$$$$$\ $$$$$$$  |
//    \____/ \__|  \__|\__|\__|       \_______| \_____\____/  \_______|\_______/

contract AccountFactory is BaseAccountFactory, ContractMetadata, PermissionsEnumerable {
    /*///////////////////////////////////////////////////////////////
                            Constructor
    //////////////////////////////////////////////////////////////*/
    address public policyCordinator;
    constructor(
        address _defaultAdmin,
        IEntryPoint _entrypoint
    ) BaseAccountFactory(address(new Account(_entrypoint, address(this))), address(_entrypoint)) {
        _setupRole(DEFAULT_ADMIN_ROLE, _defaultAdmin);
    }

    /*///////////////////////////////////////////////////////////////
                        Internal functions
    //////////////////////////////////////////////////////////////*/

    /// @dev Called in `createAccount`. Initializes the account contract created in `createAccount`.
    function _initializeAccount(address _account, address _admin, bytes calldata _data) internal override {
        require(policyCordinator != address(0), "Policy Cordinator not set");
        Account(payable(_account)).initialize(_admin, _data);
        Account(payable(_account)).setPolicyCordinator(policyCordinator);
    }

    /// @dev Returns whether contract metadata can be set in the given execution context.
    function _canSetContractURI() internal view virtual override returns (bool) {
        return hasRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /// @notice Returns the sender in the given execution context.
    function _msgSender() internal view override(Multicall, Permissions) returns (address) {
        return msg.sender;
    }

    function setPolicyCordinator(address _policyCordinator) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "AccountFactory: not admin");
        policyCordinator = _policyCordinator;
    }
}
