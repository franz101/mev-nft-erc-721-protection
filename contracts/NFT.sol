// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "./ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MEVNFTMintContract is ERC721, Ownable {

    uint256 public mintPrice = 0.01 ether;
    uint256 public totalSupply;
    uint256 public maxSupply;
    mapping(address => uint256) public mintedWallet;

    constructor() payable ERC721("MEV-NFT", "MEVNFT") {
        maxSupply   = 1000;
        totalSupply = 0;
        
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function mint() external payable {
        require(mintedWallet[msg.sender] < 1, "exceeds max per wallet");
        require(msg.value < mintPrice, "wrong value");
        require(maxSupply > totalSupply, "sold out");

        mintedWallet[msg.sender]++;
        totalSupply++;
        uint256 tokenId = totalSupply;
        _safeMint(msg.sender, tokenId);


    }



    
}