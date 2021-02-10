// SPDX-License-Identifier: GPL-3.0
    
pragma solidity >=0.4.22 <0.8.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "../contracts/1_Storage.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {

    // Contract instance created.    
    Storage str;
    
    // Random number for testing purposes.
    uint256 randomNumber = 100;
    int times = 10;
    int itr = 0;

    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    
    function beforeAll() public {
        str = new Storage();
    }
    
    function checkPositiveNumber() public {
        Assert.greaterThan(randomNumber, int(-1), "Negative number will not be accepted !");
    }
    
    function storedOnceRetrievedOnce() public {
        str.store(randomNumber);
        Assert.equal(str.retrieve(), randomNumber, "The value which was stored earlier is supposed to be equal to the retrieved value !");
    }
    
    function storedMultipleRetreivedOnce() public {
        uint256 localNumber = randomNumber;
        for(itr = 0; itr < times; itr++) {
            str.store(localNumber);
            localNumber += 10;
            str.store(localNumber);
            localNumber += 10;
            str.store(localNumber);
            Assert.equal(str.retrieve(), localNumber, "The latest stored value should be retrieved !");
        }
    }
    
    function storedOnceRetreivedMultiple() public {
        uint256 localNumber = randomNumber;
        for(itr = 0; itr < times; itr++) {
            str.store(localNumber);
            Assert.equal(str.retrieve(), localNumber, "The latest stored value should be retrieved !");
            Assert.equal(str.retrieve(), localNumber, "The latest stored value should be retrieved !");
            Assert.equal(str.retrieve(), localNumber, "The latest stored value should be retrieved !");
        }
    }
    
    function sameValueStoredMultipleRetrievedMultiple() public {
        for(itr = 0; itr < times; itr++) {
            str.store(randomNumber);
            Assert.equal(str.retrieve(), randomNumber, "The value which was stored earlier is supposed to be equal to the retrieved value !");
        }
    }
    
    function differentValueStoredMultipleRetrievedMultiple() public {
        itr = 0;
        uint256 localNumber = randomNumber;
        while(itr < times) {
            str.store(localNumber);
            Assert.equal(str.retrieve(), localNumber, "The value which was stored earlier is supposed to be equal to the retrieved value !");
            localNumber++;
            itr++;
        }
    }

    /// Custom Transaction Context
    /// See more: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    /// #sender: account-1
    /// #value: 100
    function checkSenderAndValue() public payable {
        // account index varies 0-9, value is in wei
        Assert.equal(msg.sender, TestsAccounts.getAccount(1), "Invalid sender");
        Assert.equal(msg.value, 100, "Invalid value");
    }
}
