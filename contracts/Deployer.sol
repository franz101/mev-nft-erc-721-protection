// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/utils/Create2.sol";
import "./MEVNFT.sol";

contract MEVNFTFactory {
    event MEVNFTCreated(address mevnft);
    
    constructor(){
        deployMEVNFT("mev",payable(msg.sender));
    }
    function deployMEVNFT(bytes32 salt, address payable owner) public {
        address mevnftAddress;

        mevnftAddress = Create2.deploy(0,salt, type(MEVNFT).creationCode);
        MEVNFT(mevnftAddress).initialize(owner);
        
        emit MEVNFTCreated(mevnftAddress);
    }

    function computeAddress(bytes32 salt) public view returns (address) {
        return Create2.computeAddress(salt, keccak256(type(MEVNFT).creationCode));
    }

    
    function sendValue(bytes32 salt) external payable {
        address mevnftAddress;
        
        mevnftAddress = Create2.computeAddress(salt, keccak256(type(MEVNFT).creationCode));
        
        Address.sendValue(payable(mevnftAddress), msg.value); 
    }
}