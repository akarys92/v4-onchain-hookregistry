# Overview
The HookRegistry is an ERC-721 based registry for managing hook contracts used in Uniswap V4. It allows the deployer of a hook contract to mint an NFT with metadata stored on IPFS. Additionally, it enables auditors to sign these NFTs, providing a mechanism for integrators to verify audits and display metadata to users.

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
