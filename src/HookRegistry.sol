pragma solidity ^0.8.10;

import "solmate/tokens/ERC721.sol";
import "forge-std/console.sol";

contract HookRegistry is ERC721 {
    uint256 private _tokenIdCounter;

    struct HookMetadata {
        address hookAddress;
        string ipfsMetadataHash;
        address[] auditors;
    }

    mapping(uint256 => HookMetadata) public hookMetadata;
    mapping(uint256 => address) private hookOwners;

    event HookMinted(uint256 tokenId, address owner, string ipfsMetadataHash);
    event MetadataUpdated(uint256 tokenId, string newIpfsMetadataHash);
    event AuditorAdded(uint256 tokenId, address auditor);

    constructor() ERC721("HookRegistry", "HOOK") {}

    modifier onlyHookOwner(uint256 tokenId) {
        require(msg.sender == hookOwners[tokenId], "Not the owner");
        _;
    }

    function mintHookNFT(
        address hookAddress,
        string memory ipfsMetadataHash
    ) external {
        require(isContractDeployer(msg.sender, hookAddress), "Not the deployer of the hook");

        uint256 tokenId = _tokenIdCounter++;
        _mint(msg.sender, tokenId);
        hookOwners[tokenId] = msg.sender;
        
        hookMetadata[tokenId] = HookMetadata({
            hookAddress: hookAddress,
            ipfsMetadataHash: ipfsMetadataHash,
            auditors: new address[](0) 
        });

        emit HookMinted(tokenId, msg.sender, ipfsMetadataHash);
    }

    function updateMetadataLink(uint256 tokenId, string memory newIpfsMetadataHash) external onlyHookOwner(tokenId) {
        hookMetadata[tokenId].ipfsMetadataHash = newIpfsMetadataHash;
        emit MetadataUpdated(tokenId, newIpfsMetadataHash);
    }

    function signAudit(uint256 tokenId) external {
        HookMetadata storage metadata = hookMetadata[tokenId];
        metadata.auditors.push(msg.sender);
        emit AuditorAdded(tokenId, msg.sender);
    }

    function isAuditedBy(uint256 tokenId, address auditor) external view returns (bool) {
        HookMetadata storage metadata = hookMetadata[tokenId];
        for (uint256 i = 0; i < metadata.auditors.length; i++) {
            if (metadata.auditors[i] == auditor) {
                return true;
            }
        }
        return false;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        HookMetadata storage metadata = hookMetadata[tokenId];
        return string(abi.encodePacked("ipfs://", metadata.ipfsMetadataHash));
    }

    function isContractDeployer(address deployer, address contractAddress) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(contractAddress) }

        if (size == 0) {
            // Contract doesn't exist, cannot verify deployer
            revert("Contract doesn't exist");
            // return false;
        }
        bytes memory code;
        assembly {
            code := mload(0x40)
            mstore(0x40, add(code, size))
            extcodecopy(contractAddress, add(code, 0x20), 0, size)
        }
        // bytes32 codeHash = keccak256(code);

        // Recreate the address based on deployer and nonce
        address expectedAddress;
        bytes32 dataHash = keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), deployer, bytes1(0x80)));
        assembly {
            mstore(0x0, dataHash)
            expectedAddress := mload(0x0)
        }
        console.log(expectedAddress); 

        return expectedAddress == contractAddress;
    }
}
