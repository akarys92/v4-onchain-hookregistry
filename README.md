# Problem
Uniswap V4 supports a new concept called a hook where any developer can create an arbitrary contract that does some functionality in the swap process. This poses a problem for integrators with Uniswap V4 in both routing and interfaces. 
- Routers need to be able to find all the hooks that a pool could use, understand what they do and if they are safe and then finally decided if they want to route through those pools. 
- Interfaces need some way to be able to display metadata about hooks to their users so they can understand if they are safe to LP into.


# Approach
To address these problems we propose HookRegistry, an ERC-721 based registry for managing hook contracts used in Uniswap V4. It allows the deployer of a hook contract to mint an NFT with metadata about the hook stored on IPFS. Additionally, it enables auditors to sign these NFTs, providing a mechanism for integrators to verify audits on chain and display metadata to users off-chain. 

# Features
- Minting Hook NFTs: Allows the deployer of a hook to mint an NFT with associated metadata.
- Updating Metadata: Enables the hook owner to update the IPFS metadata link.
- Audit Signing: Allows any user to sign an audit for a hook NFT.
- Metadata Retrieval: Provides a token URI that links to the IPFS metadata.

# Contract Details
## HookRegistry.sol
The main contract for managing hook NFTs and their metadata.

## MockHook.sol
A mock contract to simulate a hook deployment.

## HookRegistryTest.t.sol
Test contract for validating the functionality of the HookRegistry contract using Foundry's Forge framework.

# Known Gaps and Issues
## Deployer Verification
**Challenge:** Verifying the deployer of a contract in Solidity is non-trivial due to the nature of contract creation and the lack of direct support for accessing contract creation transactions.

**Current Approach:** The current implementation of isContractDeployer attempts to verify the deployer of a contract by recreating the expected address based on the deployer's address and a fixed nonce.
