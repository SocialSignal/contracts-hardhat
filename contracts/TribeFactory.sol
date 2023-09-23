// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

import "./Tribe.sol";  // Replace with your actual import if located differently

/// @title Tribe Factory
/// @dev Deploys new instances of the Tribe contract.
contract TribeFactory {
    /// @notice Event emitted when a new Tribe is created
    /// @param tribeAddress The address of the Tribe contract
    event TribeFounded(address indexed tribeAddress);

    /// @notice Creates a new Tribe
    /// @param name The name of the Tribe (for the ERC721 token)
    /// @param symbol The symbol of the Tribe (for the ERC721 token)
    /// @param owner The owner of the Tribe
    /// @param nftImageURI The base URI for the NFTs in the Tribe
    /// @param ensName The ENS name for the Tribe
    /// @return tribeAddress The address of the new Tribe
    function createTribe(
        string memory name, 
        string memory symbol, 
        address owner, 
        string memory nftImageURI, 
        string memory ensName
    ) public returns (address tribeAddress) {
        // Deploy a new Tribe contract and transfer ownership to the specified owner
        Tribe tribe = new Tribe(name, symbol, owner, nftImageURI, ensName);
        tribeAddress = address(tribe);

        // Emit an event for frontend tracking
        emit TribeFounded(tribeAddress);
        
        return tribeAddress;
    }
}