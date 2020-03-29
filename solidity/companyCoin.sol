pragma solidity ^0.4.23;

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v1.6.0/contracts/token/ERC20/StandardToken.sol";

contract SEI is StandardToken {
    string public name = "Coin Name";
    string public symbol = "Coin Symbol";
    uint public decimals = 0;
    
    uint256 public remaingCoin = 0;
    
    address private fausetAddress = 0x81b7e08f65bdf5648606c89998a9cc8164397647;
    
    mapping(address=>uint256) public tokenBalances;
    
    constructor(uint _initialSupply) public {
        totalSupply_ = _initialSupply;
        remaingCoin = _initialSupply;
    }
    
    function getCoin() public payable checkAmount checkBalance {
        uint256 coins = msg.value / 2;
        balances[msg.sender] = balances[msg.sender] + coins;
        remaingCoin = remaingCoin - coins;
        tokenBalances[msg.sender] = tokenBalances[msg.sender] + coins;
        
        fausetAddress.transfer(msg.value);
    }
    
    // function getTokenBalanceOf() external view returns(uint256) {
    //     return balances[msg.sender];
    // }
    
    // function getTokenBalanceOf2() external view returns(uint256) {
    //     uint256 tmp = 0;
    //     tmp = tokenBalances[msg.sender];
    //     return tmp;
    // }
    
    // function getHello() external view returns(string) {
    //     return "Hello";
    // }
    
    // function getRemainingCoin() external view returns(uint) {
    //     return remaingCoin;
    // }
    
    modifier checkAmount(){
        require(msg.value >= 2 wei);
        _;
    }
    
    modifier checkBalance(){
        uint coins = msg.value / 2;
        require(remaingCoin >= coins);
        _;
    }

}
