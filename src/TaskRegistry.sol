//SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract TaskRegistry {
    // Struct to store task information
    struct Task {
        address from;      // Address that created the task
        address to;        // Target address for the task execution
        bytes callData;    // Calldata to be executed
        uint256 timestamp; // When the task was created
    }

    // Mapping from UUID (bytes32) to Task
    mapping(string => Task) public tasks;
    
    // Event emitted when a new task is registered
    event TaskRegistered(string indexed uuid, address indexed from, address indexed to);

    //TODO: Add a validation check from the resgistry that only registered agent is allowed to register a task
    /**
     * @notice Register a new task with a UUID
     * @param uuid Unique identifier for the task
     * @param to Target address for the task execution
     * @param callData Calldata to be executed
     */
    function registerTask(string memory uuid, address to, bytes calldata callData) external {
        require(tasks[uuid].timestamp == 0, "Task with this UUID already exists");
        
        tasks[uuid] = Task({
            from: msg.sender,
            to: to,
            callData: callData,
            timestamp: block.timestamp
        });
        
        emit TaskRegistered(uuid, msg.sender, to);
    }
    
    /**
     * @notice Get task details by UUID
     * @param uuid Unique identifier for the task
     * @return Task struct containing task details
     */
    function getTask(string memory uuid) external view returns (Task memory) {
        return tasks[uuid];
    }

}