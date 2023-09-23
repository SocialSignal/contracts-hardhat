// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Tribe is ERC721, Ownable {
    mapping(address => bool) public memberAccepted;
    mapping(address => bool) public ownerAccepted;

    modifier onlySender(address member) {
        require(msg.sender == member, "msg.sender needs to be equal to member");
        _;
    }

    modifier onlyOwnerOrSender(address member) {
        require(msg.sender == member || msg.sender == owner(), "msg.sender needs to be equal to member or owner");
        _;
    }

    constructor(string memory name, string  memory symbol) ERC721(name, symbol) {
    }

    function _memberAccept(address member) onlySender(member) private {
        memberAccepted[msg.sender] = true;
    }

    function _ownerAccept(address member) onlyOwner private {
        ownerAccepted[member] = true;
    }

    function _memberRevoke(address member) onlySender(member) private {
        memberAccepted[msg.sender] = false;
    }

    function _ownerRevoke(address member) onlyOwner private {
        ownerAccepted[member] = false;
    }

    function accept(address member) public {
        if (msg.sender == member) {
            _memberAccept(member);
        }
        if (msg.sender == owner()) {
            _ownerAccept(member);
        }
    }

    function revoke(address member) public {
        if (msg.sender == member) {
            _memberRevoke(member);
        }
        if (msg.sender == owner()) {
            _ownerRevoke(member);
        }
    }

    function _isMintable(address member) private view returns (bool) {
        return memberAccepted[member] && ownerAccepted[member];
    }

    function join(address member) onlyOwnerOrSender(member) public {
        accept(member);
        require(_isMintable(member), "You are not allowed to mint this token");
        require(balanceOf(msg.sender) == 0, "Max Mint per wallet reached");
        _safeMint(member, 1);
    }

    function exit(address member, uint256 tokenId) onlyOwnerOrSender(member) public {
        revoke(member);
        _burn(tokenId);
    }
}
