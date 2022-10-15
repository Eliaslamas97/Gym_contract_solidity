// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract gym {
    struct Class{
        string name;
        uint value;
    }

    //Eventos:
    event ClassCreated (
        string name,
        uint value
    );

    event Register (
        address user,
        uint credits
    );

    //Inmutable;
    address immutable public ADMIN;

    constructor() {
        ADMIN = msg.sender;
    }

    //Alumnos:
    mapping(address => uint) public users; //users[wallet] => uint credits

    Class[] public class;

    //Funciones del admin: 
    function createClass(string memory _name, uint _value) public {
        require(ADMIN == msg.sender, "Solo el Administrador del Gym puede crear clases");
        class.push(Class(_name, _value));
        emit ClassCreated(_name, _value);
    }

    function updateClass(uint _index, string memory _name, uint _value) public {
        require(ADMIN == msg.sender, "Solo el Administrador del Gym puede modificar clases");
        Class storage clase = class[_index];
        clase.name = _name;
        clase.value = _value;
    }

    function removeClass(uint _index) public {
        require(ADMIN == msg.sender, "Solo el Administrador del Gym puede eliminar clases");
        delete class[_index];
    }

    //Funciones del Usuario:
    function register(address _address, uint _credits) public {
        //require(_address == ADMIN, "Eres el Administrador"); //NO FUNCIONA, deja registrar al admin
        require(users[msg.sender] == 0, "Ya te encuentras registrado en el gym");
        users[msg.sender] = _credits;
        emit Register(_address, _credits); //El usuario elige cuantos creditos desea adquirir
    }

    function getBalance() public view returns(address, uint){
        return (msg.sender, users[msg.sender]);
    }

    function getClass(uint _index) public view returns (string memory name, uint value) {
        Class storage clase = class[_index];
        require(clase.value == 0, "No existe una clase con ese Id");
        return (clase.name, clase.value);
    }

    function takeClass(uint _index) public {
        Class storage clase = class[_index];
        require(users[msg.sender] >= clase.value, "No tienes creditos suficientes");
        users[msg.sender] -= clase.value;
        getBalance();
    }

    function getCredits(uint _value) public {
        users[msg.sender] += _value;
        getBalance();
    }

    function transferCredits(uint _value, address _address) public {
        require(users[msg.sender] >= _value, "No tienes creditos suficientes para transferir");
        users[msg.sender] -= _value;
        users[_address] += _value;
        getBalance();
    }

}

// falta validar que el admin no se pueda registrar;
//