// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ToDoList{
    address user;
    constructor(){
         user=msg.sender ;
    }

    struct Task{
        string description;
        bool status;
        uint taskID;
        uint priority;
    }

    mapping (uint256 => Task) private ID_to_Task; //mapping taskID to Task
    mapping (bool => string[]) private status_to_task_desc; //mapping status of task to task description
    mapping (string => string[]) private category_to_task_desc; //mapping category to task description
    mapping (string => string) public task_desc_to_due_date; //mapping task description to due dates

    function generate_TaskID(string memory _desc) private pure returns (uint) {
        return uint(keccak256(abi.encodePacked(_desc)));
    }

    function add_Task (string memory _desc) public{
        require (msg.sender == user, "User is not authorized");
        Task memory newTask = Task({description: _desc, status: false, taskID: generate_TaskID(_desc), priority: 0});
        ID_to_Task[newTask.taskID] = newTask;
        status_to_task_desc[false].push(newTask.description);
        
    } 



    function mark_as_complete(string memory _desc) public {
        require (msg.sender == user, "User is not authorized");
        ID_to_Task[generate_TaskID(_desc)].status= true;
        status_to_task_desc[true].push(_desc);
    }

    function remove_Tasks(string memory _desc) public{
    require (msg.sender == user, "User is not authorized");
    delete ID_to_Task[generate_TaskID(_desc)];
    delete status_to_task_desc[ID_to_Task[generate_TaskID(_desc)].status][generate_TaskID(_desc)];
    }

    function prioritize_Task(string memory _desc, uint level) public{
        require (msg.sender == user, "User is not authorized");
        ID_to_Task[generate_TaskID(_desc)].priority=level;

    }

    function edit_Task(string memory _desc, string memory new_desc)public{
        require (msg.sender == user, "User is not authorized");
        ID_to_Task[generate_TaskID(_desc)].description=new_desc;
        ID_to_Task[generate_TaskID(new_desc)].taskID=generate_TaskID(new_desc);
    }

    function view_Task_by_status(bool _status) public view returns (string[] memory) {
        require (msg.sender == user, "User is not authorized");
        return status_to_task_desc[_status];
    }

    function categorize_Task(string memory _desc, string memory category) public {
        require (msg.sender == user, "User is not authorized");
        category_to_task_desc[category].push(_desc);

    }

    function assign_due_dates (string memory _taskDesc, string memory dueDate) public {
        require (msg.sender == user, "User is not authorized");
        task_desc_to_due_date[(_taskDesc)]=dueDate;
    }

    function view_tasks_by_category(string memory _category) public view returns (string[] memory){
        require (msg.sender == user, "User is not authorized");
        return category_to_task_desc[_category];
    }

    
}