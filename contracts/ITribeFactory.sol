// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

/// @title Tribe Membership Contract
/// @dev A smart contract that mints ERC721 tokens as proof of membership within a tribe.
interface ITribeFactory {
    event TribeFounded(address indexed tribeAddress, string tribeName, string ensName, address owner, string baseURI);

    function createTribe(
        address owner,
        string memory baseURI,
        string memory ensName,
        string memory tribeName,
        string memory tribeSymbol
    ) external returns (address tribeAddress);
}
