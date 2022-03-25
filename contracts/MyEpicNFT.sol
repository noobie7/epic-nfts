// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import {Base64} from "./libraries/base64.sol";

contract MyEpicNFT is ERC721URIStorage{

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["Big", "VeryBig", "Small", "Medium", "XtraSmall"];
    string[] secondWords = ["Spicy", "Sweet", "Salty", "OverSweet", "SugarFree", "Hot"];
    string[] thirdWords = ["Burger", "Sandwich", "Subway", "ChickenWings", "ChocolateShake", "Samosa"];

    constructor() ERC721 ("FoodMenuNFT", "FOOD"){
        console.log("This is my NFT contract.");
    }

    function random(string memory input) internal pure returns(uint256){
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pickRandomFirstWord(uint256 tokenId) public view returns(string memory){
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", tokenId)));
        rand = rand % (firstWords.length);
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns(string memory){
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", tokenId)));
        rand = rand % (secondWords.length);
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns(string memory){
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", tokenId)));
        rand = rand % (thirdWords.length);
        return thirdWords[rand];
    }

    event NewEpicNFTMinted(address sender, uint256 tokenId);


    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        string memory firstWord = pickRandomFirstWord(newItemId);
        string memory secondWord = pickRandomSecondWord(newItemId);
        string memory thirdWord = pickRandomThirdWord(newItemId);

        string memory finalSvg = string(abi.encodePacked(baseSvg, firstWord, secondWord, thirdWord, "</text></svg>"));
        console.log(finalSvg);
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        finalSvg,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );
        console.log(json);
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUri);

        console.log("New NFT minted to %s with the ID %s", msg.sender, newItemId);

        _tokenIds.increment();
        
    }
}