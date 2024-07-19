// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {HookRegistry} from "../src/HookRegistry.sol";

contract MockHook {
    constructor() {}
}

contract HookRegistryTest is Test {
    HookRegistry public hookRegistry;
    MockHook public mockHook;
    address public deployer;
    address public otherUser;

    function setUp() public {
        deployer = address(this);
        otherUser = address(0x2);

        hookRegistry = new HookRegistry();
        mockHook = new MockHook();
    }

    function testMintHookNFT() public {
        string memory ipfsMetadataHash = "QmSomeHash";

        hookRegistry.mintHookNFT(address(mockHook), ipfsMetadataHash);

        uint256 tokenId = 0;
        string memory tokenURI = hookRegistry.tokenURI(tokenId);
        assertEq(tokenURI, string(abi.encodePacked("ipfs://", ipfsMetadataHash)));
    }

    function testMintHookNFT_NotDeployer() public {
        string memory ipfsMetadataHash = "QmSomeHash";

        vm.prank(otherUser);
        vm.expectRevert("Not the deployer of the hook");
        hookRegistry.mintHookNFT(address(mockHook), ipfsMetadataHash);
    }

    function testUpdateMetadataLink() public {
        string memory ipfsMetadataHash = "QmSomeHash";

        hookRegistry.mintHookNFT(address(mockHook), ipfsMetadataHash);

        string memory newIpfsMetadataHash = "QmNewHash";
        hookRegistry.updateMetadataLink(0, newIpfsMetadataHash);

        uint256 tokenId = 0;
        string memory tokenURI = hookRegistry.tokenURI(tokenId);
        assertEq(tokenURI, string(abi.encodePacked("ipfs://", newIpfsMetadataHash)));
    }

    function testUpdateMetadataLink_NotOwner() public {
        string memory ipfsMetadataHash = "QmSomeHash";

        hookRegistry.mintHookNFT(address(mockHook), ipfsMetadataHash);

        vm.prank(otherUser);
        vm.expectRevert("Not the owner");
        hookRegistry.updateMetadataLink(0, "QmNewHash");
    }

    function testSignAudit() public {
        string memory ipfsMetadataHash = "QmSomeHash";

        hookRegistry.mintHookNFT(address(mockHook), ipfsMetadataHash);

        vm.prank(otherUser);
        hookRegistry.signAudit(0);

        bool isAudited = hookRegistry.isAuditedBy(0, otherUser);
        assertTrue(isAudited);
    }

    function testTokenURI() public {
        string memory ipfsMetadataHash = "QmSomeHash";

        hookRegistry.mintHookNFT(address(mockHook), ipfsMetadataHash);

        uint256 tokenId = 0;
        string memory tokenURI = hookRegistry.tokenURI(tokenId);
        assertEq(tokenURI, string(abi.encodePacked("ipfs://", ipfsMetadataHash)));
    }
}
