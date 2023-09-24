// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

import "./Tribe.sol"; // Replace with your actual import if located differently

/// @title Tribe Factory
/// @dev Deploys new instances of the Tribe contract.
contract TribeFactory {
    /// @notice Event emitted when a new Tribe is created
    /// @param tribeAddress The address of the Tribe contract
    event TribeFounded(address indexed tribeAddress);
    address public implementationAddress;


    function createTribe(
        address owner,
        string memory baseURI,
        string memory ensName,
        string memory tribeName,
        string memory tribeSymbol
    ) public returns (address tribeAddress) {
        // Deploy a new Tribe contract and transfer ownership to the specified owner
        Tribe tribe = new Tribe(owner, baseURI, ensName, tribeName, tribeSymbol);
        // Emit an event for frontend tracking
        emit TribeFounded(address(tribe));

        return tribeAddress;
    }
}
