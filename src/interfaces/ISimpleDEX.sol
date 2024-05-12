// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

/**
 * @dev Interface of the simple dex contract that allows for the exchange of ERC-20 tokens at a specified exchange rate.
 */
interface ISimpleDEX {
    /**
     * @dev Emitted when `owner` update exchange rate.
     */
    event ExchangeRateUpdated(uint256 indexed oldRate, uint256 indexed newRate);

    /**
     * @dev Sets a new exchange rate between token A and token B
     * Emits `ExchangeRateUpdated` event.
     */
    function setExchangeRate(uint256 _newRate) external;

    /**
     * @dev Exchange token A for token B at the current exchange rate
     */
    function exchangeTokenAForTokenB(uint256 amountA) external;

    /**
     * @dev Exchange token B for token A at the current exchange rate
     */
    function exchangeTokenBForTokenA(uint256 amountB) external;

    /**
     * Getter Function
     */
    function getOwner() external view returns (address);

    function getTokenA() external view returns (address);

    function getTokenB() external view returns (address);

    function getExchangeRate() external view returns (uint256);

    function getTokenBalance() external view returns (uint256);
}
