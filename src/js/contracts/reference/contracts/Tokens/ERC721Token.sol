// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import 'openzeppelin-contracts/token/ERC721/ERC721.sol';
import "openzeppelin-contracts/utils/Counters.sol";

contract ERC721Token is ERC721 {
	using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

	string private _baseTokenURI;

	constructor(
		string memory name,
		string memory symbol,
    string memory baseTokenURI
	)
	  ERC721(name, symbol)
	{
		_baseTokenURI = baseTokenURI;
	}

	function _baseURI() internal view virtual override returns (string memory) {
			return _baseTokenURI;
	}

	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
		string memory resource = super.tokenURI(tokenId);

		return bytes(resource).length > 0 ? string(abi.encodePacked(resource, ".json")) : "";
	}
	
	function getTokenCount() public view virtual returns (uint256) {
		return _tokenIds.current();
	}

	function mint(address to, uint256 tokenId) public returns (bool) {
		super._safeMint(to, tokenId);
		return true;
	}

	function mintNext(address recipient) public {
    uint256 tokenId = _tokenIds.current();
    _tokenIds.increment();

    super._safeMint(recipient, tokenId);
  }
}