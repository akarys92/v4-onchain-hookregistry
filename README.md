# Problem
Uniswap V4 supports a new concept called a hook where any developer can create an arbitrary contract that does some functionality in the swap process. This poses a problem for integrators with Uniswap V4 in both routing and interfaces. 
- Routers need to be able to find all the hooks that a pool could use, understand what they do and if they are safe and then finally decided if they want to route through those pools. 
- Interfaces need some way to be able to display metadata about hooks to their users so they can understand if they are safe to LP into.


# Approach
To address these problems we propose HookRegistry, an ERC-721 based registry for managing hook contracts used in Uniswap V4. It allows the deployer of a hook contract to mint an NFT with metadata about the hook stored on IPFS. Additionally, it enables auditors to sign these NFTs with a known key they publish, providing a mechanism for integrators to verify audits on chain and display metadata to users off-chain. 

Ideally this protocol would be deployed as part of the v4-periphery so that it sits on every chain Uniswap V4 is deployed to. 

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
**Challenge:** The key challenge is making sure that only the deployer of the hook can create an NFT containing the metadata for it. This is critical to keeping this information secure. Doing this fully on chain though is proving difficult as it seems there isn't a way purely in Solidity to look up the deployer of a previous contract.

**Current Approach:** The current implementation of isContractDeployer attempts to verify the deployer of a contract by recreating the expected address based on the deployer's address and a fixed nonce. I think to do this correctly you'd need to know the nonce used at the time of deployment. I don't think there's a way to do that...

**Other Potential Approaches:**
- Have a HookFactory that deploys the hook AND creates the metadata in a single transaction. Then updates can be made by whoever holds the deployment key
- (Stretch) Have an "optimistic" protocol where anyone can do the initial metadata creation with some stake. Then if they weren't the original deployer, someone can submit a proof that the deployers were different, take the stake and invalidate the metadata. 
