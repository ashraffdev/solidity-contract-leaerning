//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Token {
    string public name;
    string public symbol;
    uint256 public decimals;
    uint256 public totalSupply;
    address public owner;

    //token ammount varible
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    // Events
    event Approval(
        address indexed tokenOwner,
        address indexed spender,
        uint256 tokens
    );
    event Transfer(address indexed from, address indexed to, uint256 tokens);

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _decimals,
        uint256 _totalSupply
    ) {
        totalSupply = _totalSupply;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        owner = msg.sender;
        balances[msg.sender] = totalSupply;
    }

    /// @dev return token balance of given address
    /// @param _tokenOwner address
    function balanceOf(address _tokenOwner) public view returns (uint256) {
        return balances[_tokenOwner];
    }

    /// @dev internal helper transfer function with required safety checks
    /// @param _from, where funds coming the sender
    /// @param _to receiver of token
    /// @param _numTokens amount value of token to send
    function _transfer(
        address _from,
        address _to,
        uint256 _numTokens
    ) internal {
        // Ensure sending is to valid address! 0x0 address cane be used to burn()
        require(_to != address(0));
        balances[_from] = balances[_from] - _numTokens;
        balances[_to] = balances[_to] + _numTokens;
        emit Transfer(_from, _to, _numTokens);
    }

    /// @dev transfer token from token owner to receiver address
    /// @param _receiver address of reciver
    /// @param _numTokens token ammount to transfer
    function transfer(address _receiver, uint256 _numTokens)
        public
        returns (bool)
    {
        require(_numTokens <= balances[msg.sender]);
        _transfer(msg.sender, _receiver, _numTokens);
        return true;
    }

    /// @dev give approval to spender address of given amount token address
    /// @param _spender address of spender who is going to spend this token on behalf of owner
    /// @param _numTokens token ammount to apprave
    function approve(address _spender, uint256 _numTokens)
        public
        returns (bool)
    {
        allowed[msg.sender][_spender] = _numTokens;
        emit Approval(msg.sender, _spender, _numTokens);
        return true;
    }

    /// @dev give approval to delegate address of given amount token address
    /// @param _owner address of reciver
    /// @param _buyer token ammount to apprave
    /// @param _numTokens token ammount to apprave
    function transferFrom(
        address _owner,
        address _buyer,
        uint256 _numTokens
    ) public returns (bool) {
        require(_numTokens <= balances[_owner]);
        require(_numTokens <= allowed[_owner][msg.sender]);
        allowed[_owner][msg.sender] = allowed[_owner][msg.sender] - _numTokens;
        _transfer(_owner, _buyer, _numTokens);
        return true;
    }

    /// @dev show number of token that is allowed to spend
    /// @param _owner addres of token owner
    function approvalOf(address _owner) public view returns (uint256) {
        return allowed[_owner][msg.sender];
    }
}
