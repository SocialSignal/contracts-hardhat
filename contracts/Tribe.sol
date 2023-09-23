// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Tribe Membership Contract
/// @dev A smart contract that mints ERC721 tokens as proof of membership within a tribe.
contract Tribe is ERC721, Ownable {
    mapping(address => bool) public memberAccepted;  /// Tracks the acceptance status by the member
    mapping(address => bool) public ownerAccepted;   /// Tracks the acceptance status by the owner
    mapping(address => uint256) public tokenIdAddress;  /// Maps an address to its minted token ID
    uint256 public tokenCounter = 1;  /// Keeps track of the last minted token ID. Set to 1 to enable token Id = 0, which means not minted.
    string private _nftImageURI;  /// The base URI for all minted NFTs
    string public ensName;  /// The ENS name associated with the contract

    /// @notice Event emitted when a member's acceptance status changes
    /// @param member The address of the member
    /// @param value The new acceptance status
    event TribeMemberValue(address indexed member, bool value);

    /// @notice Event emitted when an owner's acceptance status for a member changes
    /// @param member The address of the member
    /// @param value The new acceptance status
    event TribeOwnerValue(address indexed member, bool value);

    /// @notice Event emitted when a new member joins the tribe
    /// @param member The address of the member
    /// @param tokenId The token ID that was minted
    event TribeJoined(address indexed member, uint256 tokenId);

    // @notice Event emitted for opensea to hide transfer button
    /// @param tokenId The token ID that was locked
    event Locked(uint256 tokenId);

    /// @notice Event emitted when a member exits the tribe
    /// @param member The address of the member
    /// @param tokenId The token ID that was burned
    event TribeExited(address indexed member, uint256 tokenId);

    /// @dev Only allows the owner or the sender themselves to perform certain actions
    modifier onlyOwnerOrSender(address member) {
        require(msg.sender == member || msg.sender == owner(), "msg.sender needs to be equal to member or owner");
        _;
    }

    /// @dev Initializes the contract
    constructor(
        string memory name, 
        string memory symbol, 
        address owner, 
        string memory nftImageURI, 
        string memory ensName_
    ) ERC721(name, symbol) {
        transferOwnership(owner);
        _nftImageURI = nftImageURI;
        require(bytes(ensName_).length > 0, "ENS name cannot be empty");
        ensName = ensName_;
    }

    /// @dev Overrides the `_transfer` function of the ERC721 standard
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        // disable transfers
    }

    /// @dev Returns the base URI for the NFT image
    function _baseURI() internal view override returns (string memory) {
        return _nftImageURI;
    }

    /// @dev Internal function to change the acceptance status of a member
    function _memberValue(address member, bool value) private {
        require(value != memberAccepted[member], "Value already set");
        memberAccepted[member] = value;
        emit TribeMemberValue(member, value); 
    }

    /// @dev Internal function to change the owner's acceptance status for a member
    function _ownerValue(address member, bool value) private {
        require(value != ownerAccepted[member], "Value already set");
        ownerAccepted[member] = value;
        emit TribeOwnerValue(member, value); 
    }

    /// @dev Internal function to check if a member can be minted an NFT
    function _isMintable(address member) private view returns (bool) {
        return memberAccepted[member] && ownerAccepted[member];
    }

    /// @dev Internal function to join a member to the tribe
    function _join(address member) private {
        uint256 nftId = tokenCounter;
        tokenIdAddress[member] = tokenCounter;
        tokenCounter = tokenCounter + 1;
        _safeMint(member, nftId);
        emit TribeJoined(member, nftId); 
        emit Locked(nftId);
    }

    /// @dev Internal function to exit a member from the tribe
    function _exit(address member) private {
        uint256 tokenId = tokenIdAddress[member];
        tokenIdAddress[member] = 0;
        _burn(tokenId);
        emit TribeExited(member, tokenId); 
    }

    /// @notice Accept a member into the tribe
    /// @param member The address of the potential member
    function accept(address member) public onlyOwnerOrSender(member) {
        if (msg.sender == member) {
            _memberValue(member, true);
        }
        if (msg.sender == owner()) {
            _ownerValue(member, true);
        }
        if (_isMintable(member)) {
            _join(member);
        }
    }

    /// @notice Revoke a membership from the tribe
    /// @param member The address of the current member
    function revoke(address member) public onlyOwnerOrSender(member) {
        if (msg.sender == member) {
            _memberValue(member, false);
        }
        if (msg.sender == owner()) {
            _ownerValue(member, false);
        }
        if (isMember(member)) {
            _exit(member);
        }
    }

    /// @notice Checks if an address is a member of the tribe
    /// @param member The address to check
    /// @return true if the address is a member, false otherwise
    function isMember(address member) public view returns (bool) {
        return balanceOf(member) > 0;
    }

    /// @notice Sets the base URI for the NFT images
    /// @param nftImageURI The new base URI
    function setBaseURI(string memory nftImageURI) external onlyOwner {
        _nftImageURI = nftImageURI;
    } 
}