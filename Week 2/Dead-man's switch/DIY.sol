// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.4.0 < 0.8.0;

contract DeadMansSwitch {
    uint256 previousBlock = 0;
    uint256 currentBlock = 0;
    uint maxDifference = 10;
    address owner;
    address payable presetAddress;
    bool statusOfContract = true;
    
    event ContractCreated(address Owner, address payable PresetAddress);
    event FundsReceived(address Sender, uint256 Amount);
    
    constructor(address payable _addr) {
        owner = msg.sender;
        presetAddress = _addr;
        previousBlock = block.number;
        emit ContractCreated(owner, presetAddress);
    }
    
    modifier onlyOwner {
        require(msg.sender == owner,"This function can only be called by the owner.");
        require(statusOfContract, "The contract is no longer functioning.");
        _;
    }
    
    fallback() external payable {
        emit FundsReceived(msg.sender, msg.value);
    }
    
    receive() external payable onlyOwner {
        emit FundsReceived(msg.sender, msg.value);
    }

    function isTheContractActive() public view returns (bool) {
        return statusOfContract;
    }
    
    function getOwner() public view returns (address) {
        return msg.sender;
    }
    
    function lastCalledStillAlive() public view returns (uint256) {
        return previousBlock;
    }
    
    function currentBlockNumber() public view returns (uint256) {
        return block.number;
    }
    
    function still_alive() external onlyOwner{
        previousBlock = block.number;
    }
    
    function sendAllToPresetAddress() internal {
        (bool sent, bytes memory data) = presetAddress.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
        statusOfContract = false;
    }
    
    function checkIfStillAlive() public onlyOwner returns (bool) {
        currentBlock = block.number;
        if((currentBlock - previousBlock) > maxDifference && block.number >= maxDifference) {
            sendAllToPresetAddress();
            return false;
        } else {
            return true ;
        }
    }   
}
