pragma solidity >=0.4.21 <0.6.0;

/**
 * The digitalIdentity contract handles a digital identity of a person
 */
contract digitalIdentity {

	//Struct for user
	struct user {
		string name;
		uint age;
		uint aadhar_number;
		uint PAN;
		uint salary;
		address[] permittedToView;
	}
	
	//Admin address. Here admin is the person who created the contract
	address admin;

	//Mapping from address to users called userData
	mapping (address => user) userData;

	//An array to store all the created accounts
	address[] userAccounts;

	//Admin modifier in case we need it later
	modifier onlyAdmin() {
    require (msg.sender==admin);
    _;
  	}

  	//Constructor
	constructor () public {
		admin=msg.sender;
	}	

	//To Add a user to the system
	function addUser (string memory _name, uint _aadhar_number) public returns(address)  {
		address tempAddress=getUniqueId(_aadhar_number);
		var user1=userData[tempAddress];
		user1.name=_name;
		userAccounts.push(tempAddress);	
		return tempAddress;	
	} 

	//To update the age field of the user's details
	function updateUserAge (address _addr,uint _age) public {
		require (userAccounts[uint(_addr)].exists,"User does not exist");
		userData[_addr].age=_age;
	}

	//To update the PAN field of the user's details
	function updateUserPAN (address _addr,uint _PAN) public {
		require (userAccounts[uint(_addr)].exists,"User does not exist");
		userData[_addr].PAN=_PAN;
	}

	//To update the salary field of the user's details
	function updateUserSalary (address _addr,uint _salary) public {
		require (userAccounts[uint(_addr)].exists,"User does not exist");
		userData[_addr].salary=_salary;
	}
	
	// //To view your own data
	// function viewOwnData () public returns(user)  {
	// 	user memory tempUser = userData[msg.sender];
	// 	return tempUser;
	// }

	//To give permission to another person to view your details
	function permitToView (address _addr) public{
		userData[msg.sender].permittedToView.push(_addr);
	}

	// //To allow someone to view your data, provided you have given that person permission to view your data
	// function viewOthersData(address _addrWhosDataToBeSeen) public returns(user) {
	// 	require (userData[_addrWhosDataToBeSeen].permittedToView[msg.sender].exists,"You do not have permission to access this data");
	// 	return userData[_addrWhosDataToBeSeen];
	// }

	//Function to generate an address to every new user registered using hashing
	function getUniqueId(uint seed) internal view returns (address) {
        bytes20 b = bytes20(keccak256(seed, now));
        uint addr = 0;
        for (uint index = b.length-1; index+1 > 0; index--) {
            addr += uint(b[index]) * ( 16 ** ((b.length - index - 1) * 2));
        }
        return address(addr);
    }
}

