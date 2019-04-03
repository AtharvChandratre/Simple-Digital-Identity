pragma solidity >=0.4.0 <0.6.0;

/**
 * The digital_identity contract handles a digital identity of a person
 */
contract digital_identity {

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
		address tempAddress=getUniqueAddress(_aadhar_number);
		for(uint i=0;i<userAccounts.length;i++)
		{
			if(userAccounts[i]==tempAddress)
			{
				//Add event which says that there is already an existing user
				revert();
			}
		}
		user memory user1=userData[tempAddress];
		user1.name=_name;
		userAccounts.push(tempAddress);	
		return tempAddress;	
	} 

	//To update the age field of the user's details
	function updateUserAge (address _addr,uint _age) public {
		for(uint i=0;i<userAccounts.length;i++)
		{
			if(userAccounts[i]==_addr)
			{
				userData[_addr].age=_age;
				break;
			}
		}
	}

	//To update the PAN field of the user's details
	function updateUserPAN (address _addr,uint _PAN) public {
		for(uint i=0;i<userAccounts.length;i++)
		{
			if(userAccounts[i]==_addr)
			{
				userData[_addr].PAN=_PAN;
				break;
			}
		}
	}

	//To update the salary field of the user's details
	function updateUserSalary (address _addr,uint _salary) public {
		for(uint i=0;i<userAccounts.length;i++)
		{
			if(userAccounts[i]==_addr)
			{
			userData[_addr].salary=_salary;
				break;
			}
		}
	}
	
	//To view your own data
	function viewOwnData () public view returns(string memory,uint,uint,uint,uint,address[] memory)  {
		user memory tempUser = userData[msg.sender];
		return (tempUser.name,tempUser.age,tempUser.aadhar_number,tempUser.PAN,tempUser.salary,tempUser.permittedToView);
	}

	//To give permission to another person to view your details
	function permitToView (address _addr) public{
		userData[msg.sender].permittedToView.push(_addr);
	}

	//To allow someone to view your data, provided you have given that person permission to view your data
	function viewOthersData(address _addrWhosDataToBeSeen) public view returns(string memory,uint,uint,uint,uint) {
		for(uint i=0;i<userData[_addrWhosDataToBeSeen].permittedToView.length;i++)
		{
			if(userData[_addrWhosDataToBeSeen].permittedToView[i]==msg.sender)
			{
				user memory tempUser = userData[_addrWhosDataToBeSeen];
				return (tempUser.name,tempUser.age,tempUser.aadhar_number,tempUser.PAN,tempUser.salary);
			}
		}
		//Send event that says the user is not allowed to view this persons data
		revert();
	}

	//Function to generate an address to every new user registered using hashing
	function getUniqueAddress(uint seed) internal pure returns (address) {
        return address(uint160(uint256(keccak256(abi.encode(seed)))));
    }
}

