pragma solidity ^0.6.0;

library SafeMath {

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

      assert(b <= a);

      return a - b;

    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

      uint256 c = a + b;

      assert(c >= a);

      return c;

    }

}

interface IERC20 {

    function totalSupply() external view returns (uint256);



    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

}

contract ICO is IERC20 {

    string public constant name = "IOC";

    string public constant symbol = "ERC20";

    uint8 public constant decimals = 18;

    event Transfer(address indexed from, address indexed to, uint tokens);

   

    address owner;

    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    // Functions with this modifier can only be executed by the owner

    modifier onlyOwner() {

        require (msg.sender != owner);

        _;

    }

   

    uint256 totalSupply_ = 100000000; //Total Supply of Token: 100 Million

   

    using SafeMath for uint256;

    constructor() public {

        balances[msg.sender] = totalSupply_;

    }

   

    //Check Total Supply

    function totalSupply() public override view returns (uint256) {

        return totalSupply_;

    }

    //Check Balance

    function balanceOf(address tokenOwner) public override view returns (uint256) {

        return balances[tokenOwner];

    }

   

    //Burning Total Supply

    function burn(uint256 amount) internal {

        require(amount <= balances[msg.sender]);

        totalSupply_ -= amount;

        balances[msg.sender] -= amount;

        emit Transfer(msg.sender, address(0), amount);

    }

   

    //Initial Value at $0.01 (Pre-sale Quantity: 30 Million)

    function initialSale(uint _ethers) internal pure returns(uint _tokens)

    {

        uint oneTokenwei = 1 ether * 1 / 5000 / 100; //5000 is price of ether

        uint tokens = _ethers  * (1 ether) / oneTokenwei;

        return tokens;

    }

    //2nd Sale Value at $0.02 (Seed Sale Quantity: 50 Million)

    function preSale(uint _ethers) internal pure returns(uint _tokens)

    {

        uint oneTokenwei = 1 ether * 2 / 5000 / 100; //$5000 is price of ether

        uint tokens = _ethers  * (1 ether) / oneTokenwei;

        return tokens;

    }

   

    //Random Number Generation

    function randMod() internal view returns(uint)

    {

        uint randNonce = 0;

        // increase nonce

        randNonce++;

        return uint(keccak256(abi.encodePacked(now,msg.sender,randNonce))) % 1000;

    }

   

    //Final Sale for Remaining Tokens should be dynamically allocated.

    function finalSale(uint _ethers) internal view returns(uint _tokens)

    {

        uint randomNumber = randMod();

        uint oneTokenwei = 1 ether * randomNumber / 5000 / 100; //$5000 is price of ether

        uint tokens = _ethers  * (1 ether) / oneTokenwei;

        return tokens;

    }

   

    //Transfer Tokens

    function transfer(address receiver, uint256 _ethers) public override returns (bool) {

        uint numTokens;

       

        if(totalSupply_ > 70000000)

        {

            numTokens = initialSale(_ethers);

        }

        else if(totalSupply_ >=20000000 && totalSupply_ <= 70000000)

        {

            numTokens = preSale(_ethers);

        }

        else if(totalSupply_ < 20000000)

        {

            numTokens = finalSale(_ethers);

        }

       

        balances[msg.sender] = balances[msg.sender].sub(numTokens);

       

        balances[receiver] = balances[receiver].add(numTokens);

       

        emit Transfer(msg.sender, receiver, numTokens);

       

        burn(numTokens);

       

        return true;

    }

}

