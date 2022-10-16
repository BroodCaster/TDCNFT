# TDCNFT
AdminUpgradeabilityProxy and NFT collection smart contracts. 

In the contracts folder stores Proxy and NFT smart contracts:

Proxy:
  - contracts/proxy/AdminUpgradeabilityProxy.sol - That is our main contract of proxy with which all operations will take place. That contract 
                                                   will store all NFT smart contract data. Which will allow us to change the logic of 
                                                   smart contract without losing any data.
                                                   
NFT collection contract:
  - contracts/TDCNFT.sol                         - This contract contains NFT logic, all major functions(minting, whitelist, tokenURI metadata storage, 
                                                   pause abilitiy, etc.). The proxy contract will delegate transactions to NFT smart contract and then 
                                                   he will store all data from NFT smart contracts.
                                                   
- In build/contracts/... stores contract ABI data that is needed to verify smart contracts on etherscan.io and for work with web3 API.

- truffle-config.js - is a configuration of deployment script. 
