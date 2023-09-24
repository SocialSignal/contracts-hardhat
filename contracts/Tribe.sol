// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/// @title Tribe Membership Contract
/// @dev A smart contract that mints ERC721 tokens as proof of membership within a tribe.
contract Tribe is ERC721 {
    enum MemberState { NonMember, Invited, Requested, Member }

    mapping(address => bool) public memberAccepted;  /// Tracks the acceptance status by the member
    mapping(address => bool) public ownerAccepted;   /// Tracks the acceptance status by the owner
    mapping(address => uint256) public tokenIdAddress;  /// Maps an address to its minted token ID
    uint256 public tokenCounter = 1;  /// Keeps track of the last minted token ID. Set to 1 to enable token Id = 0, which means not minted.
    string private _nftImageURI;  /// The base URI for all minted NFTs
    string public ensName;  /// The ENS name associated with the contract
    address public owner;  /// The owner of the contract

    /// @notice Event emitted when a member's acceptance status changes
    /// @param account The address of the member
    /// @param value The new acceptance status
    event TribeMemberValue(address indexed account, bool value);

    /// @notice Event emitted when an owner's acceptance status for a member changes
    /// @param account The address of the member
    /// @param value The new acceptance status
    event TribeOwnerValue(address indexed account, bool value);

    /// @notice Event emitted when a new member joins the tribe
    /// @param account The address of the member
    /// @param tokenId The token ID that was minted
    event TribeJoined(address indexed account, uint256 tokenId);

    event TribeStatus(address indexed account, MemberState tribeStatus);

    // @notice Event emitted for opensea to hide transfer button
    /// @param tokenId The token ID that was locked
    event Locked(uint256 tokenId);

    /// @notice Event emitted when a member exits the tribe
    /// @param account The address of the member
    /// @param tokenId The token ID that was burned
    event TribeExited(address indexed account, uint256 tokenId);

    /// @dev Only allows the owner or the sender themselves to perform certain actions
    modifier onlyOwnerOrSender(address account) {
        require(msg.sender == account || msg.sender == owner, "msg.sender needs to be equal to member or owner");
        _;
    }

    /// @dev Initializes the contract
    constructor() ERC721("Tribe", "TRIBE") {}

    function initialize(address owner_, string memory nftImageURI, string memory ensName_) public {
        require(owner == address(0), "contract already initialized");
        setBaseURI(nftImageURI);
        setENSName(ensName_);
        transferOwnership(owner_);
    }

    function setENSName(string memory ensName_) public {
        if (owner != address(0)) {
            require(owner == msg.sender, "Only owner can set ENS name");
        }
        require(bytes(ensName_).length > 0, "ENS name cannot be empty");
        ensName = ensName_;
    }

    function setBaseURI(string memory nftImageURI) public {
        if (owner != address(0)) {
            require(owner == msg.sender, "Only owner can set base URI");
        }
        require(bytes(nftImageURI).length > 0, "NFT image URI cannot be empty");
        _nftImageURI = nftImageURI;
    }

    function transferOwnership(address newOwner) public {
        if (owner != address(0)) {
            require(owner == msg.sender, "Only owner can transfer ownership");
        }
        require(newOwner != address(0), "New owner cannot be empty");
        owner = newOwner;
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
    function _memberValue(address account, bool value) private {
        require(value != memberAccepted[account], "Value already set");
        memberAccepted[account] = value;
        emit TribeMemberValue(account, value); 
    }

    /// @dev Internal function to change the owner's acceptance status for a member
    function _ownerValue(address account, bool value) private {
        require(value != ownerAccepted[account], "Value already set");
        ownerAccepted[account] = value;
        emit TribeOwnerValue(account, value); 
    }

    /// @dev Internal function to check if a member can be minted an NFT
    function _isMintable(address account) private view returns (bool) {
        return memberAccepted[account] && ownerAccepted[account];
    }

    function getMemberState(address account) public view returns (MemberState){
        if (isMember(account)){
            return MemberState.Member;
        }
        else if (ownerAccepted[account]){
            return MemberState.Invited;
        }
        else if (memberAccepted[account]){
            return MemberState.Requested;
        }
        else {
            return MemberState.NonMember;
        }
    }

    /// @dev Internal function to join a member to the tribe
    function _join(address account) private {
        uint256 nftId = tokenCounter;
        tokenIdAddress[account] = tokenCounter;
        tokenCounter = tokenCounter + 1;
        _safeMint(account, nftId);
        emit TribeJoined(account, nftId); 
        emit Locked(nftId);
    }

    /// @dev Internal function to exit a member from the tribe
    function _exit(address account) private {
        uint256 tokenId = tokenIdAddress[account];
        tokenIdAddress[account] = 0;
        _burn(tokenId);
        emit TribeExited(account, tokenId); 
    }

    /// @notice Accept a account into the tribe
    /// @param account The address of the potential member
    function accept(address account) public onlyOwnerOrSender(account) {
        if (msg.sender == account) {
            _memberValue(account, true);
        }
        if (msg.sender == owner) {
            _ownerValue(account, true);
        }
        if (_isMintable(account)) {
            _join(account);
        }
        emit TribeStatus(account, getMemberState(account));
    }

    /// @notice Revoke an accept
    /// @param account The address of the current member
    function revoke(address account) public onlyOwnerOrSender(account) {
        if (isMember(account)) {
            _exit(account);
        }
        if (msg.sender == account) {
            _memberValue(account, false);
        }
        if (msg.sender == owner) {
            _ownerValue(account, false);
        }
        emit TribeStatus(account, getMemberState(account));
    }

    /// @notice Checks if an address is a member of the tribe
    /// @param account The address to check
    /// @return true if the address is a member, false otherwise
    function isMember(address account) public view returns (bool) {
        return balanceOf(account) > 0;
    }

    /// @notice Returns the metadata for a token Id - all token IDs should be the same
    /// @param tokenId The tokenId to check
    /// @return string related to where the metadata is stored
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return _baseURI();
    }
}