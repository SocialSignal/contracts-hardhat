// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

import "./Tribe.sol";  // Replace with your actual import if located differently
import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Tribe Factory
/// @dev Deploys new instances of the Tribe contract.
contract TribeFactory {
    /// @notice Event emitted when a new Tribe is created
    /// @param tribeAddress The address of the Tribe contract
    event TribeFounded(address indexed tribeAddress);
    address public implementationAddress;

    /// @notice Creates a new Tribe
    /// @param owner The owner of the Tribe
    /// @param nftImageURI The base URI for the NFTs in the Tribe
    /// @param ensName The ENS name for the Tribe
    /// @return tribeAddress The address of the new Tribe
    function createTribe(
        address owner, 
        string memory nftImageURI, 
        string memory ensName
    ) public returns (address tribeAddress) {
        // Deploy a new Tribe contract and transfer ownership to the specified owner
        Tribe tribe = Tribe(Clones.clone(implementationAddress));
        tribe.initialize(owner, nftImageURI, ensName);

        // Emit an event for frontend tracking
        emit TribeFounded(address(tribe));
        
        return tribeAddress;
    }

    function initialize(address implementationAddress_) public { 
        require(implementationAddress == address(0), "contract already initialized");
        implementationAddress = implementationAddress_;
    }
}