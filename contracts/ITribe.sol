// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

/// @title Tribe Membership Contract
/// @dev A smart contract that mints ERC721 tokens as proof of membership within a tribe.
interface ITribe {
    enum UserStatus {
        NonMember,
        Invited,
        Requested,
        Member
    }

    event UserStatusUpdate(address indexed account, UserStatus userStatus);

    /// @notice Event emitted for opensea to hide transfer button
    /// @param tokenId The token ID that was locked
    event Locked(uint256 tokenId);

    function accept(address account) external;

    function revoke(address account) external;
}
