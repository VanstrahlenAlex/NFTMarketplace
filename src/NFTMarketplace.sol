// SPDX-License-Identifier: MIT

pragma solidity 0.8.35;

import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";


contract NTFMarketplace is Ownable{


	struct Listing {
		address seller;
		address nftAddress;
		uint256 tokenId;
		uint256 price;
	}

	mapping(address => mapping(uint256 => Listing) ) listing;

	event NFTListed(address indexed seller, address indexed nftAddress, uint256 indexed tokenId, uint256 price);
	event NFTCancelled(address indexed seller, address indexed nftAddress, uint256 indexed tokenId);


	constructor() Ownable(msg.sender) {
		

	}


	// Listar NFTs
	function listNFT(address nftAddress_, uint256 tokenId_, uint256 price_) external { 

		require(price_ > 0, "Price can not be 0");

		address owner_ = IERC721(nftAddress_).ownerOf(tokenId_);
		require(owner_ == msg.sender, "You are not the owner of this NFT");
		

		Listing memory listing_ = Listing({
			seller: msg.sender,
			nftAddress: nftAddress_,
			tokenId: tokenId_,
			price: price_
		});

		listing[nftAddress_][tokenId_] = listing_;

		emit NFTListed(msg.sender, nftAddress_, tokenId_, price_);
		
		
	}


	//Buy NFTs


	//Cancel List 
	function cancelList(address nftAddress_, uint256 tokenId_) external { 
		Listing memory listing_ = listing[nftAddress_][tokenId_];
		require(listing_.seller == msg.sender, "You are not the listing owner");

		delete listing[nftAddress_][tokenId_];

		emit NFTCancelled(msg.sender, nftAddress_, tokenId_);
	}
}