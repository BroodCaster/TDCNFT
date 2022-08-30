// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TDCNFT is ERC721Enumerable, Ownable {
  using Strings for uint256;

  string baseURI;
  string public baseExtension = ".json";
  uint256 public maxSupply = 20;
  uint256 public maxMintAmount = 3;
  bool public paused = false;
  bool public whitelisted = true;
  address[] public whitelistedUsers;

  constructor(
    string memory _initBaseURI
  ) ERC721("Thirsty Dogs Club", "TDC") {
    setBaseURI(_initBaseURI);
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  function mint(uint256 _mintAmount) public payable {
    uint256 supply = totalSupply();
    require(!paused);
    require(_mintAmount > 0);
    require(_mintAmount <= maxMintAmount);
    require(supply + _mintAmount <= maxSupply);
    if(whitelisted == true){
      require(isWhitelisted(msg.sender), "User is not whitelisted");
    }


    for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(msg.sender, supply + i);
    }
  }

  function isWhitelisted(address _user) public returns(bool){
    for(uint256 i = 0; i < whitelistedUsers.length; i++){
      if(whitelistedUsers[i] == _user){
        return true;
      }
    }
    return false; 
  }

  function walletOfOwner(address _owner)
    public
    view
    returns (uint256[] memory)
  {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](ownerTokenCount);
    for (uint256 i; i < ownerTokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokenIds;
  }

  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        : "";
  }

  function createWhitelist(address[] calldata _users) public onlyOwner{
    delete whitelistedUsers;
    whitelistedUsers = _users;
  }

  function setWhitelisted(bool _state) public onlyOwner{
    whitelisted = _state;
  }

  function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
    maxMintAmount = _newmaxMintAmount;
  }

  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }

  function pause(bool _state) public onlyOwner {
    paused = _state;
  }
 
//   function withdraw() public payable onlyOwner {
//     // This will payout the owner 100% of the contract balance.
//     // Do not remove this otherwise you will not be able to withdraw the funds.
//     // =============================================================================
//     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
//     require(os);
//     // =============================================================================
//   }
}