// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


/**
 * @title NonAtomicNFT
 * @author Stuxden, Franz
 * @notice Implementation of a mintable NFT with modifier based access controls
 * which allows transferal per tokenId only once per block
 */
contract NonAtomicNFT is ERC721, AccessControl {
    using Counters for Counters.Counter;


    mapping(uint => uint) public tokenBlocks; // tokenId => block number

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _tokenIdCounter;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
    }

    /// @notice disallow transfers of a token in the same block
    modifier nonAtomic(uint tokenId) {
        require(tokenBlocks(tokenId) != block.number, "can't transfer in the same block");
        tokenBlocks(tokenId) = block.number;
        _;
    }

    function mint(address to)
        public
        onlyRole(MINTER_ROLE)
        returns (uint256)
    {
        uint256 tokenId = _tokenIdCounter.current();
        _mint(to, tokenId);
        _tokenIdCounter.increment();
        return tokenId;
    }

    /// @notice disallow transfers of a token in the same block

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public nonAtomic(tokenId) override(ERC721) {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public nonAtomic(tokenId) override(ERC721) {
        super.safeTransferFrom(from, to, tokenId, data);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public nonAtomic(tokenId) override(ERC721) {
        super.safeTransferFrom(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
