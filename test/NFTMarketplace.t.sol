// SPDX-License-Identifier: MIT

pragma solidity 0.8.35;

import "forge-std/Test.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "src/NFTMarketplace.sol";



contract MockNFT is ERC721 {

	constructor() ERC721("MockNFT", "MNFT") {}

	function mint(address to_, uint256 tokenId_) external {
		_mint(to_, tokenId_);
	}
}

contract NFTMarketplaceTest is Test {

	NFTMarketplace marketplace; 
	MockNFT nft;
	address deployer = vm.addr(1);
	address user = vm.addr(2);
	uint256 tokenId = 0;

	function setUp() public {
		vm.startPrank(deployer);
		marketplace = new NFTMarketplace();
		nft = new MockNFT();
		vm.stopPrank();	

		vm.startPrank(user);
		nft.mint(user, 0);
		vm.stopPrank();
	}

	function testMintNFT() public view {
		address ownerOf = nft.ownerOf(tokenId);
		assert(ownerOf == user);
	}

	function testShouldRevertIfPriceIsZero() public { 
		vm.startPrank(user);

		vm.expectRevert("Price can not be 0");
		marketplace.listNFT(address(nft), tokenId, 0);

		vm.stopPrank();
	}

	function testShouldRevertIfNotOwner() public {
		vm.startPrank(user);

		address user2_ = vm.addr(3);
		uint256 tokenId_ = 1;
		nft.mint(user2, tokenId_);
		vm.expectRevert("You are not the owner of this NFT");
		marketplace.listNFT(address(nft), tokenId_, 1);

		vm.stopPrank();

	}

	function testListNFTCorrectly() public {
		vm.startPrank(user);

		marketplace.listing(address(nft), tokenId);
		marketplace.listNFT(address(nft), tokenId, 0);

		vm.stopPrank();
	}
}