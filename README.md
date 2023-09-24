# Tribe Contract
The Tribe contract is an Ethereum-based smart contract that serves as a membership token using ERC721 standards. The contract allows an owner and other members to accept or revoke membership for a particular address. Once a member is accepted by both the owner and themselves, a unique NFT is minted to represent their membership in the Tribe.

# Features
- ERC721 Compatibility: Inherits the ERC721 standard to create unique tokens for each member.
- Owner Control: Contract owner can accept or revoke memberships.
- Member Control: Members can also accept or revoke their own memberships.
- Unique IDs: Each membership has a unique token ID stored in a mapping.
- ENS Integration: Each contract instance may have an associated ENS name.

# Usage
## Constructor
The constructor accepts five parameters:

- name: The name of the ERC721 token.
- symbol: The symbol of the ERC721 token.
- owner: The address of the initial owner.
- nftImageURI: The base URI for the NFT image.
- ensName_: The ENS name associated with the contract (must not be empty).

## Methods
- accept(address member): Accepts a member, either by the member themselves or the owner.
- revoke(address member): Revokes a membership, either by the member themselves or the owner.

## Events
- TribeMemberValue(address indexed member, bool value): Emitted when a member's acceptance status changes.
- TribeOwnerValue(address indexed member, bool value): Emitted when an owner's acceptance status for a member changes.
- TribeJoined(address indexed member, uint256 tokenId): Emitted when a new member joins.
- TribeExited(address indexed member, uint256 tokenId): Emitted when a member exits.