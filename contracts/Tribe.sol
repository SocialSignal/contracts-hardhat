// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import {ITribe} from "./ITribe.sol";

error UnauthorizedAddress(address caller);
error NewOwnerCanNotAddressZero();
error AccountAlreadyIsMember();

/**
 * @title Tribe Membership Contract
 * @dev A smart contract that mints ERC721 tokens as proof of membership within a tribe.
 */
contract Tribe is ITribe, ERC721 {
    mapping(address => bool) public userAccepted; // Tracks the acceptance status by the member
    mapping(address => bool) public ownerAccepted; // Tracks the acceptance status by the owner
    mapping(address => uint256) public tokenIdAddress; // Maps an address to its minted token ID
    uint256 public tokenCounter = 1; // Keeps track of the last minted token ID. Set to 1 to enable token Id = 0, which means not minted.
    string public baseURI; // The base URI for all minted NFTs
    string public ensName; // The ENS name associated with the contract
    address public owner; // The owner of the contract

    constructor(
        address _owner,
        string memory _baseURI,
        string memory _ensName,
        string memory tribeName,
        string memory tribeSymbol
    ) ERC721(tribeName, tribeSymbol) {
        owner = _owner;
        baseURI = _baseURI;
        ensName = _ensName;
    }

    // Modifiers

    /**
     * @dev Only allows the owner or the sender themselves to perform certain actions
     */
    modifier onlyOwnerOrSender(address account) {
        if (msg.sender != account && msg.sender != owner) revert UnauthorizedAddress(msg.sender);
        _;
    }

    // Public functions

    /**
     * @notice Accept an account into the tribe
     * @param account The address of the potential member
     */
    function accept(address account) public onlyOwnerOrSender(account) {
        if (isMember(account)) revert AccountAlreadyIsMember();
        if (msg.sender == account) {
            userAccepted[account] = true;
        }
        if (msg.sender == owner) {
            ownerAccepted[account] = true;
        }
        if (_isElegibleToJoin(account)) {
            _join(account);
        }
        emit UserStatusUpdate(account, getUserStatus(account));
    }

    /**
     * @notice Revoke an accept
     * @param account The address of the current member
     */
    function revoke(address account) public onlyOwnerOrSender(account) {
        if (isMember(account)) {
            _burn(tokenIdAddress[account]);
            delete tokenIdAddress[account];
        }
        userAccepted[account] = false;
        ownerAccepted[account] = false;
        emit UserStatusUpdate(account, getUserStatus(account));
    }

    function transferOwnership(address newOwner) public {
        if (owner != msg.sender) {
            revert UnauthorizedAddress(msg.sender);
        }
        if (newOwner == address(0)) {
            revert NewOwnerCanNotAddressZero();
        }
        owner = newOwner;
    }

    /**
     * @notice Checks if an address is a member of the tribe
     * @param account The address to check
     * @return true if the address is a member, false otherwise
     */
    function isMember(address account) public view returns (bool) {
        return balanceOf(account) > 0;
    }

    function getUserStatus(address account) public view returns (UserStatus) {
        if (isMember(account)) {
            return UserStatus.Member;
        } else if (ownerAccepted[account]) {
            return UserStatus.Invited;
        } else if (userAccepted[account]) {
            return UserStatus.Requested;
        } else {
            return UserStatus.NonMember;
        }
    }

    /**
     * @notice Returns the metadata for a token Id - all token IDs should be the same
     * @param tokenId The tokenId to check
     * @return string related to where the metadata is stored
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return _baseURI();
    }

    // Private functions

    /**
     * @dev Overrides the `_transfer` function of the ERC721 standard
     */
    function _transfer(address from, address to, uint256 tokenId) internal virtual override {}

    /**
     * @dev Internal function to check if a member can be minted an NFT
     */
    function _isElegibleToJoin(address account) private view returns (bool) {
        return userAccepted[account] && ownerAccepted[account];
    }

    /**
     * @dev Internal function to join a member to the tribe
     */
    function _join(address account) private {
        tokenIdAddress[account] = tokenCounter;
        _safeMint(account, tokenCounter);
        emit Locked(tokenCounter);
        tokenCounter++;
    }
}
