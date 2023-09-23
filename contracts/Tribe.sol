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

    modifier onlyOwnerOrSender(address member) {
        require(msg.sender == member || msg.sender == owner(), "msg.sender needs to be equal to member or owner");
        _;
    }

    constructor(string memory name, string  memory symbol) ERC721(name, symbol) {

        // TODO add more metadata to the contract
        // TODO add events
    }

    function _memberValue(address member, bool value) private {
        memberAccepted[member] = value;
    }

    function _ownerValue(address member, bool value) private {
        ownerAccepted[member] = value;
    }

    function _isMintable(address member) private view returns (bool) {
        return memberAccepted[member] && ownerAccepted[member];
    }

    function accept(address member) onlyOwnerOrSender(member) public {
        if (msg.sender == member) {
            _memberValue(member, true);
        }
        if (msg.sender == owner()) {
            _ownerValue(member, true);
        }
    }

    function revoke(address member) onlyOwnerOrSender(member) public {
        if (msg.sender == member) {
            _memberValue(member, false);
        }
        if (msg.sender == owner()) {
            _ownerValue(member, false);
        }
    }

    function join(address member) onlyOwnerOrSender(member) public {
        accept(member);
        require(_isMintable(member), "You are not allowed to mint this token");
        require(balanceOf(member) == 0, "Max Mint per wallet reached");
        uint256 nftId = tokenCounter;
        tokenIdAddress[member] = tokenCounter;
        tokenCounter = tokenCounter + 1;
        _safeMint(member, nftId);
    }

    function exit(address member) onlyOwnerOrSender(member) public {
        uint256 tokenId = tokenIdAddress[member];
        revoke(member);
        _burn(tokenId);
    }
    
    function isMember(address member) public view returns (bool) {
        return balanceOf(member) > 0;
    }
}
