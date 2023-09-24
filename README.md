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

## Deployed Contracts
- Goerli: [0x50a28a0d610733d261fce2e315c8a58e30b0a9ac](https://goerli.etherscan.io/address/0x50a28a0d610733d261fce2e315c8a58e30b0a9ac#code)
- Scroll: [0x843C1Cf1DAfB56857b698DB3fA84C1f63bf89EA6](https://sepolia.scrollscan.dev/address/0x843C1Cf1DAfB56857b698DB3fA84C1f63bf89EA6#code)
- Linea: [0x843C1Cf1DAfB56857b698DB3fA84C1f63bf89EA6](https://goerli.lineascan.build/address/0x843C1Cf1DAfB56857b698DB3fA84C1f63bf89EA6#code)
- Celo: [0x843C1Cf1DAfB56857b698DB3fA84C1f63bf89EA6](https://alfajores.celoscan.io/address/0x843C1Cf1DAfB56857b698DB3fA84C1f63bf89EA6#code)
- Base: [0x039cf813f8F1E4A1Ab4F8896c9D8FD1f3E420733](https://goerli.basescan.org/address/0x039cf813f8F1E4A1Ab4F8896c9D8FD1f3E420733#code)
- Gnosis: [0x843C1Cf1DAfB56857b698DB3fA84C1f63bf89EA6](https://gnosisscan.io/address/0x843C1Cf1DAfB56857b698DB3fA84C1f63bf89EA6#code) (waiting for block explorer to sync)