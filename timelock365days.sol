//SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract Timelock365Days {
    constructor() {}

    //create a mapping for balance
    mapping(address => uint256) private balances;
    //creating a mapping for locktime
    mapping(address => uint256) private LOCKTIME;

    function deposit() external payable {
        require(msg.value != 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
        LOCKTIME[msg.sender] = block.timestamp + 365 days;
    }

    function depositTo(address account) external payable {
        require(msg.value != 0, "Deposit amount must be greater than 0");
        balances[account] += msg.value;
        LOCKTIME[msg.sender] = block.timestamp + 365 days;
    }

    //Lets verify that the balance has been updated into contract
    function getBalances(address account) external view returns (uint256) {
        return balances[account];
    }

    function getTimeLock(address account) external view returns (uint256) {
        return LOCKTIME[account];
    }

    function withdraw() external {
        require(balances[msg.sender] != 0, "No Funds Availabe");
        require(
            block.timestamp > LOCKTIME[msg.sender],
            "Dude!!! The time hasn't expired yet"
        );
        uint256 amount = balances[msg.sender];

        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed To Send Ether");
    }

    function withdrawTo(address account) external {
        require(balances[account] != 0, "No Funds Availabe");
        require(
            block.timestamp > LOCKTIME[account],
            "Dude!!! The time hasn't expired yet"
        );
        uint256 amount = balances[account];

        balances[account] = 0;

        (bool sent, ) = account.call{value: amount}("");
        require(sent, "Failed To Send Ether");
    }

    function returnThisContract() external view returns (uint256) {
        return address(this).balance;
    }
}
