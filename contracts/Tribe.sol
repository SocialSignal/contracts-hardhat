// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Tribe is ERC721, Ownable {
    mapping(address => bool) public memberAccepted;
    mapping(address => bool) public ownerAccepted;
    mapping(address => uint256) public tokenIdAddress;
    uint256 public tokenCounter;

    // Events
    event TribeMemberAccepted(address indexed member);
    event TribeOwnerAccepted(address indexed member);
    event TribeJoined(address indexed member, uint256 tokenId);
    event TribeExited(address indexed member, uint256 tokenId);

    modifier onlyOwnerOrSender(address member) {
        require(msg.sender == member || msg.sender == owner(), "msg.sender needs to be equal to member or owner");
        _;
    }

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        // TODO add more metadata to the contract
        // Events are defined but not emitted here
    }

    function _memberValue(address member, bool value) private {
        memberAccepted[member] = value;
        emit TribeMemberAccepted(member); // Emitting event
    }

    function _ownerValue(address member, bool value) private {
        ownerAccepted[member] = value;
        emit TribeOwnerAccepted(member); // Emitting event
    }

    function _isMintable(address member) private view returns (bool) {
        return memberAccepted[member] && ownerAccepted[member];
    }

    function _join(address member) private {
        require(balanceOf(member) == 0, "Max Mint per wallet reached");
        uint256 nftId = tokenCounter;
        tokenIdAddress[member] = tokenCounter;
        tokenCounter = tokenCounter + 1;
        _safeMint(member, nftId);
        emit TribeJoined(member, nftId); // Emitting event
    }

    function _exit(address member) private {
        uint256 tokenId = tokenIdAddress[member];
        _burn(tokenId);
        emit TribeExited(member, tokenId); // Emitting event
    }

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
    
    function isMember(address member) public view returns (bool) {
        return balanceOf(member) > 0;
    }
}