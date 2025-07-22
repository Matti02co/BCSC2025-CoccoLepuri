// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

/// @title TokenA
/// @notice Implementa il token TokenA con ERC20
contract TokenA is ERC20{
    address owner;
    error notTheOwner(address _address);
    constructor() ERC20("TokenA", "A") {
        owner = msg.sender;
    }

    modifier onlyOwner(){
        if (msg.sender != owner) revert notTheOwner(msg.sender);
        _;
    }

    /// @notice Permette di ottenere i token
    /// @param recipient Indirizzo su cui ricevere i token
    /// @param quantity Quantita di token da ricevere in formato decimale a 18
    function mint(address recipient, uint256 quantity) public onlyOwner{
        _mint(recipient,quantity);
    }
}

/// @title TokenB
/// @notice Implementa il token TokenB con ERC20
contract TokenB is ERC20{
    address owner;
    error notTheOwner(address _address);
    constructor() ERC20("TokenB", "B") {
        owner = msg.sender;
    }

    modifier onlyOwner(){
        if (msg.sender != owner) revert notTheOwner(msg.sender);
        _;
    }

    /// @notice Permette di ottenere i token
    /// @param recipient Indirizzo su cui ricevere i token
    /// @param quantity Quantita di token da ricevere in formato decimale a 18
    function mint(address recipient, uint256 quantity) public onlyOwner{
        _mint(recipient,quantity);
    }
}
