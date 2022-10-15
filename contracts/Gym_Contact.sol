// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract gym {
    struct Class {
        string name;
        uint value;
    }

    //Events:
    event ClassCreated (
        string name,
        uint value
    );

    event Register (
        address user,
        uint credits
    );

    //Immutable;
    address immutable public ADMIN;

    constructor() {
        ADMIN = msg.sender;
    }

    //Users:
    mapping(address => uint) public users; //users[wallet] => uint credits

    Class[] public class;

    //Funcs admin: 
    function createClass(string memory _name, uint _value) public {
        require(ADMIN == msg.sender, "Only the gym administrator can create classes");
        class.push(Class(_name, _value));
        emit ClassCreated(_name, _value);
    }

    function updateClass(uint _index, string memory _name, uint _value) public {
        require(ADMIN == msg.sender, "Only the gym administrator modify classes");
        Class storage clase = class[_index];
        clase.name = _name;
        clase.value = _value;
    }

    function removeClass(uint _index) public {
        require(ADMIN == msg.sender, "Only the gym administrator can eliminate classes");
        delete class[_index];
    }

    //Funcs User:
    function register(address _address, uint _credits) public {
        require(msg.sender != ADMIN, "You are the administrator");
        require(users[msg.sender] == 0, "You are already registered in the gym");
        users[msg.sender] = _credits;
        emit Register(_address, _credits); //The user selects how many credits wants to purchase
    }

    function getBalance() public view returns(address, uint){
        return (msg.sender, users[msg.sender]);
    }

    function getClass(uint _index) public view returns (string memory name, uint value) {
        Class storage clase = class[_index];
        require(clase.value == 0, "It does not exist a class with that id");
        return (clase.name, clase.value);
    }

    function takeClass(uint _index) public {
        Class storage clase = class[_index];
        require(clase.value != 0, "This class does not exist");
        require(users[msg.sender] >= clase.value, "You do not have enough credits");
        users[msg.sender] -= clase.value;
        getBalance();
    }

    function getCredits(uint _value) public {
        users[msg.sender] += _value;
        getBalance();
    }

    function transferCredits(uint _value, address _address) public {
        require(users[msg.sender] >= _value, "You do not have enough credits to transfer");
        users[msg.sender] -= _value;
        users[_address] += _value;
        getBalance();
    }
}
