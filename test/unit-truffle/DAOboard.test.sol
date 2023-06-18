pragma solidity ^0.8.0;

import "@truffle/Assert.sol";
import "../contracts/DAOboard.sol";

contract TestDAOboard {
    DAOboard dao;

    function beforeEach() public {
        dao = new DAOboard();
    }

    function testAddMember() public {
        dao.addMember("John Doe", "john@example.com", "1234");
        uint256 expected = 1;
        uint256 actual = dao.getLength();
        Assert.equal(actual, expected, "Member count should be 1");
    }

    function testDeleteUser() public {
        dao.addMember("John Doe", "john@example.com", "1234");
        dao.deleteUser(address(this));
        bool expected = false;
        bool actual = dao.isRegistered(address(this));
        Assert.equal(actual, expected, "User should be deleted");
    }

    function testAddPoints() public {
        dao.addMember("John Doe", "john@example.com", "1234");
        dao.addPoints(address(this), 100);
        uint256 expected = 100;
        uint256 actual = dao.getMemberDetails("1234").point;
        Assert.equal(actual, expected, "Points should be added");
    }

    function testMinusPoints() public {
        dao.addMember("John Doe", "john@example.com", "1234");
        dao.addPoints(address(this), 100);
        dao.minusPoints(address(this), 50);
        uint256 expected = 50;
        uint256 actual = dao.getMemberDetails("1234").point;
        Assert.equal(actual, expected, "Points should be subtracted");
    }

    function testPointsToToken() public {
        dao.addMember("John Doe", "john@example.com", "1234");
        dao.addPoints(address(this), 100);
        dao.pointsToToken(50);
        uint256 expected = 50 * 10 ** 18;
        uint256 actual = dao.balanceOf(address(this));
        Assert.equal(actual, expected, "Tokens should be transferred");
    }

    function testAddTask() public {
        dao.addMember("John Doe", "john@example.com", "1234");
        dao.addTask("Task 1", "Description 1", 100);
        uint256 expected = 1;
        uint256 actual = dao.taskArray.length;
        Assert.equal(actual, expected, "Task count should be 1");
    }

    function testRegisterForTask() public {
        dao.addMember("John Doe", "john@example.com", "1234");
        dao.addTask("Task 1", "Description 1", 100);
        dao.registerForTask(0, "Comments");
        uint256 expected = 0;
        uint256 actual = dao.taskRegistrations[address(this)];
        Assert.equal(actual, expected, "Task registration should be successful");
    }

    function testDeleteTask() public {
        dao.addMember("John Doe", "john@example.com", "1234");
        dao.addTask("Task 1", "Description 1", 100);
        dao.deleteTask(0);
        uint256 expected = 0;
        uint256 actual = dao.taskArray.length;
        Assert.equal(actual, expected, "Task should be deleted");
    }

    function testCloseTask() public {
        dao.addMember("John Doe", "john@example.com", "1234");
        dao.addTask("Task 1", "Description 1", 100);
        dao.closeTask(0);
        bool expected = false;
        bool actual = dao.taskArray[0].status;
        Assert.equal(actual, expected, "Task should be closed");
    }

    function testReopenTask() public {
        dao.addMember("John Doe", "john@example.com", "1234");
        dao.addTask("Task 1", "Description 1", 100);
        dao.closeTask(0);
        dao.reopenTask(0);
        bool expected = true;
        bool actual = dao.taskArray[0].status;
        Assert.equal(actual, expected, "Task should be reopened");
    }

    function testTaskCompleted() public {
        dao.addMember("John Doe", "john@example.com", "1234");
        dao.addTask("Task 1", "Description 1", 100);
        dao.registerForTask(0, "Comments");
        dao.taskCompleted(0);
        bool expected = true;
        bool actual = dao.taskDone[0][address(this)];
        Assert.equal(actual, expected, "Task should be marked as completed");
    }

    function testUndoTaskCompleted() public {
        dao.addMember("John Doe", "john@example.com", "1234");
        dao.addTask("Task 1", "Description 1", 100);
        dao.registerForTask(0, "Comments");
        dao.taskCompleted(0);
        dao.undoTaskCompleted(0);
        bool expected = false;
        bool actual = dao.taskDone[0][address(this)];
        Assert.equal(actual, expected, "Task should be marked as not completed");
    }

    function testIsTaskCompleted() public {
        dao.addMember("John Doe", "john@example.com", "1234");
        dao.addTask("Task 1", "Description 1", 100);
        dao.registerForTask(0, "Comments");
        dao.taskCompleted(0);
        bool expected = true;
        bool actual = dao.istaskCompleted(0, address(this));
        Assert.equal(actual, expected, "Task should be marked as completed");
    }
}