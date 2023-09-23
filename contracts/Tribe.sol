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
    uint256 public tokenCounter = 1; // tokenId = 0 means that it is empty
    string private _nftImageURI;
    string public ensName;

    // Events
    event TribeMemberValue(address indexed member, bool value);
    event TribeOwnerValue(address indexed member, bool value);
    event TribeJoined(address indexed member, uint256 tokenId);
    event TribeExited(address indexed member, uint256 tokenId);

    modifier onlyOwnerOrSender(address member) {
        require(msg.sender == member || msg.sender == owner(), "msg.sender needs to be equal to member or owner");
        _;
    }

    constructor(string memory name, string memory symbol, address owner, string memory nftImageURI, string memory ensName_) ERC721(name, symbol) {
        transferOwnership(owner);
        _nftImageURI = nftImageURI;
        require(bytes(ensName_).length > 0, "ENS name cannot be empty");
        ensName = ensName_;
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        // nothing happens on transfers
    }

    function _baseURI() internal view override returns (string memory) {
        return _nftImageURI;
    }   

    function _memberValue(address member, bool value) private {
        memberAccepted[member] = value;
        emit TribeMemberValue(member, value); // Emitting event
    }

    function _ownerValue(address member, bool value) private {
        ownerAccepted[member] = value;
        emit TribeOwnerValue(member, value); // Emitting event
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
        tokenIdAddress[member] = 0;
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

    function setBaseURI(string memory nftImageURI) external onlyOwner {
        _nftImageURI = nftImageURI;
    } 
}