// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";

contract TDCNFT is  
  ERC721EnumerableUpgradeable, 
  OwnableUpgradeable, 
  ReentrancyGuardUpgradeable, 
  UUPSUpgradeable{
  using StringsUpgradeable for uint256;

  string baseURI;
  string public baseExtension = ".json";
  uint256 public maxSupply = 20;
  uint256 public maxMintAmount = 3;
  uint256 public price = 20000000000000000;
  bool public paused = false;
  bool public whitelisted = true;
  address[] public whitelistedUsers;

  function initialize() public initializer{
    __ERC721_init("Thirsty Dogs Club", "TDC");
    __ERC721Enumerable_init();
    __Ownable_init();
    __UUPSUpgradeable_init();
    __ReentrancyGuard_init();
  }

  // constructor(
  //   string memory _initBaseURI,
  //   address[] memory whiteUsers
  // ) ERC721("Thirsty Dogs Club", "TDC") {

  //   setBaseURI(_initBaseURI);
  //   whitelistedUsers = whiteUsers;

  // }

  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  function mint(uint256 _mintAmount) public payable nonReentrant{
    uint256 supply = totalSupply();
    require(!paused);
    require(_mintAmount > 0);
    require(_mintAmount <= maxMintAmount);
    require(supply + _mintAmount <= maxSupply);
    require(price <= msg.value, "Insufficient funds");
    if(whitelisted == true){
      require(isWhitelisted(msg.sender), "User is not whitelisted");
    }


    for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(msg.sender, supply + i);
    }
  }

  function isWhitelisted(address _user) public view returns(bool){
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

  function getTokenPrice() public view returns(uint256) {
    return price;
  }

  function setTokenPrice(uint256 _price) public onlyOwner {
    price = _price;
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
 
  function withdraw() public payable onlyOwner {
    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    require(os);
  }

  function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}
}