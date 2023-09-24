// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

import {Tribe} from "./Tribe.sol"; // Replace with your actual import if located differently
import {ITribeFactory} from "./ITribeFactory.sol"; // Replace with your actual import if located differently

/// @title Tribe Factory
/// @dev Deploys new instances of the Tribe contract.
contract TribeFactory is ITribeFactory {
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
        emit TribeFounded(address(tribe), tribeName, ensName, owner, baseURI);

        return tribeAddress;
    }
}
