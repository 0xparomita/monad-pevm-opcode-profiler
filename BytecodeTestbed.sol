// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title BytecodeTestbed
 * @dev Explains how isolated compute loops prevent storage contention rollbacks in parallel runtimes.
 */
contract BytecodeTestbed {
    
    bytes32 public globalSystemCheckpoint;
    mapping(address => bytes32) public userPersonalData;

    event ComputeLogged(address indexed worker, bytes32 payload);

    /**
     * @notice Performs isolated mathematical modifications to prevent thread conflicts.
     */
    function executeIsolatedLoop(uint256 iterations) external {
        bytes32 rollingHash = keccak256(abi.encodePacked(msg.sender, block.timestamp));
        
        for (uint256 i = 0; i < iterations; i++) {
            rollingHash = keccak256(abi.encodePacked(rollingHash, i)); // Executes purely in worker memory
        }
        
        userPersonalData[msg.sender] = rollingHash; // Updates an isolated state slot
        emit ComputeLogged(msg.sender, rollingHash);
    }
}
