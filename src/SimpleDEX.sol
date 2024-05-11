// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {IERC20} from "./IERC20.sol";

/**
 * @title Simple Decentralized Exchange (DEX)
 * @dev This contract allows for the exchange of ERC-20 tokens at a specified exchange rate.
 */
contract SimpleDEX {
    /**
     * State variables
     */

    // Immutable
    address private immutable i_owner;

    // Mutable
    address private s_tokenA;
    address private s_tokenB;
    uint256 private s_exchangeRate;

    /*
     * Events
     */
    event ExchangeRateUpdated(uint256 indexed oldRate, uint256 indexed newRate);

    /**
     * Errors
     */
    error SimpleDEX__AmountMustBeMoreThanZero();
    error SimpleDEX__InsufficientTokenBalance(address token);
    error SimpleDEX__TransferFailed();
    error SimpleDEX__TransferFromFailed();
    error SimpleDEX__Unauthorized();
    error SimpleDEX__ValueMustBeMoreThanZero();

    /**
     * Modifiers
     */

    // Modifier to restrict access to only the owner
    modifier _onlyOwner() {
        if (msg.sender != i_owner) {
            revert SimpleDEX__Unauthorized();
        }
        _;
    }

    // Modifier to ensure non-zero amount
    modifier _checkZeroAmount(uint256 _amount) {
        if (_amount == 0) {
            revert SimpleDEX__AmountMustBeMoreThanZero();
        }
        _;
    }

    /**
     * Functions
     */

    /**
     * @notice Constructor to initialize the contract with token addresses and initial exchange rate
     * @param _tokenA The address of the first erc20 token to be used for exchange
     * @param _tokenB The address of the second erc20 token to be used for exchange
     * @param _exchangeRate The initial exchange rate between the two tokens
     */
    constructor(address _tokenA, address _tokenB, uint256 _exchangeRate) {
        s_tokenA = _tokenA;
        s_tokenB = _tokenB;
        s_exchangeRate = _exchangeRate;
        // The contract deployer will be assigned as owner of the contract
        i_owner = msg.sender;
    }

    /**
     * External & Public Functions
     */

    /**
     * @dev Sets a new exchange rate between token A and token B
     * @param _newRate New exchange rate to be set
     */
    function setExchangeRate(uint256 _newRate) public _onlyOwner {
        if (_newRate != 0) {
            revert SimpleDEX__ValueMustBeMoreThanZero();
        }
        uint256 oldRate = s_exchangeRate;
        s_exchangeRate = _newRate;

        emit ExchangeRateUpdated(oldRate, _newRate);
    }

    /**
     * @dev Exchange token A for token B at the current exchange rate
     * @param amountA Amount of token A to exchange
     */
    function exchangeTokenAForTokenB(uint256 amountA) public _checkZeroAmount(amountA) {
        uint256 amountB = amountA / s_exchangeRate;

        // check if contract has sufficient balance of token B
        _checkTokenBalance(s_tokenB, amountB);

        // transfer amount A from the caller to the contract
        _transferFrom(s_tokenA, msg.sender, address(this), amountA);

        // transfer token B from the contract to the caller
        _transfer(s_tokenB, msg.sender, amountB);
    }

    /**
     * @dev Exchange token B for token A at the current exchange rate
     * @param amountB Amount of token B to exchange
     */
    function exchangeTokenBForTokenA(uint256 amountB) public _checkZeroAmount(amountB) {
        uint256 amountA = amountB * s_exchangeRate;

        // check if contract has sufficient balance of token A
        _checkTokenBalance(s_tokenA, amountA);

        // transfer amountB from the caller to the contract
        _transferFrom(s_tokenB, msg.sender, address(this), amountB);

        // transfer token A from the contract to the caller
        _transfer(s_tokenA, msg.sender, amountA);
    }

    /**
     * Internal & Private Functions
     */

    /**
     * @dev Internal function to transfer tokens from the contract to a specified address
     * @param _token Address of the token to transfer
     * @param _to Address to transfer tokens to
     * @param _amount Amount of tokens to transfer
     */
    function _transfer(address _token, address _to, uint256 _amount) private {
        // execute token transfer
        bool success = IERC20(_token).transfer(_to, _amount);
        // Revert if the transfer fail
        if (!success) {
            revert SimpleDEX__TransferFailed();
        }
    }

    /**
     * @dev Internal function to transfer tokens from a specified address to another address
     * @param _token Address of the token to transfer
     * @param _from Address to transfer tokens from
     * @param _to Address to transfer tokens to
     * @param _amount Amount of tokens to transfer
     */
    function _transferFrom(address _token, address _from, address _to, uint256 _amount) private {
        // execute token transfer
        bool success = IERC20(_token).transferFrom(_from, _to, _amount);
        // Revert if the transfer fail
        if (!success) {
            revert SimpleDEX__TransferFromFailed();
        }
    }

    /**
     * @dev Internal function to check the balance of a specified token
     * @param _token Address of the token
     * @param _amount Amount to check the balance for
     */
    function _checkTokenBalance(address _token, uint256 _amount) private view {
        // Retrieve token balance of the contract
        uint256 tokenBalance = IERC20(_token).balanceOf(address(this));
        // Revert if the token balance is insufficient
        if (tokenBalance < _amount) {
            revert SimpleDEX__InsufficientTokenBalance(_token);
        }
    }

    /**
     * Getter Function
     */
    function getOwner() external view returns (address) {
        return i_owner;
    }

    function getTokenA() external view returns (address) {
        return s_tokenA;
    }

    function getTokenB() external view returns (address) {
        return s_tokenB;
    }

    function getExchangeRate() external view returns (uint256) {
        return s_exchangeRate;
    }
}
