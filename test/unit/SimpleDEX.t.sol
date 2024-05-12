// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {SimpleDEX} from "../../src/SimpleDEX.sol";
import {IERC20} from "../../src/interfaces/IERC20.sol";
import {DeploySimpleDEX} from "../../script/DeploySimpleDEX.s.sol";

contract ISimpleDEXTest is Test {
    DeploySimpleDEX deployer;
    SimpleDEX simpleDEXToken;

    address USER = makeAddr("user");

    uint256 constant DEX_INITIAL_BALANCE = 10 ether;
    uint256 constant USER_INITIAL_BALANCE = 100_000 ether;
    uint256 constant TOKENA_EXCHANGE_AMOUNT = 5 ether;
    uint256 constant TOKENB_EXCHANGE_AMOUNT = 0.02 ether;

    address simpleDEX;
    address admin;
    address tokenA;
    address tokenB;

    uint256 initialExchangeRate = 100;

    /* Functions */
    function setUp() external {
        deployer = new DeploySimpleDEX();

        DeploySimpleDEX.DeployedAddresses memory deployedAddresses;
        (simpleDEXToken, deployedAddresses) = deployer.run();

        simpleDEX = deployedAddresses.simpleDEX;
        tokenA = deployedAddresses.tokenA;
        tokenB = deployedAddresses.tokenB;
        admin = deployedAddresses.admin;

        vm.startPrank(admin);
        IERC20(tokenA).transfer(simpleDEX, DEX_INITIAL_BALANCE);
        IERC20(tokenB).transfer(simpleDEX, DEX_INITIAL_BALANCE);
        IERC20(tokenA).transfer(USER, USER_INITIAL_BALANCE);
        IERC20(tokenB).transfer(USER, USER_INITIAL_BALANCE);
        vm.stopPrank();
    }

    /**
     * Getter functions
     */
    function testGetOwnerAddress() public {
        console.log("Admin", admin);
        assertEq(admin, simpleDEXToken.getOwner());
    }

    function testGetTokenA() public {
        console.log("TokenA", tokenA);
        assertEq(tokenA, simpleDEXToken.getTokenA());
    }

    function testGetTokenB() public {
        console.log("TokenB", tokenB);
        assertEq(tokenB, simpleDEXToken.getTokenB());
    }

    function testGetExchangeRate() public {
        uint256 exchangeRate = simpleDEXToken.getExchangeRate();
        assertEq(exchangeRate, initialExchangeRate);
    }

    function testGetContractTokenABalance() public {
        uint256 tokenABalance = IERC20(tokenA).balanceOf(simpleDEX);
        console.log("Contract tokenA balance", tokenABalance);
        assertEq(DEX_INITIAL_BALANCE, tokenABalance);
    }

    function testGetContractTokenBBalance() public {
        uint256 tokenBBalance = IERC20(tokenB).balanceOf(simpleDEX);
        console.log("Contract tokenB balance", tokenBBalance);
        assertEq(DEX_INITIAL_BALANCE, tokenBBalance);
    }

    function testGetUserTokenABalance() public {
        uint256 tokenABalance = IERC20(tokenA).balanceOf(USER);
        console.log("User's tokenA balance", tokenABalance);
        assertEq(USER_INITIAL_BALANCE, tokenABalance);
    }

    function testGetUserTokenBBalance() public {
        uint256 tokenBBalance = IERC20(tokenB).balanceOf(USER);
        console.log("Contract tokenB balance", tokenBBalance);
        assertEq(USER_INITIAL_BALANCE, tokenBBalance);
    }

    /**
     * Exchange Rate
     */
    function testNonAdminNotAllowedToUpdateExchangeRate() public {
        vm.prank(USER);
        vm.expectRevert(SimpleDEX.SimpleDEX__Unauthorized.selector);
        simpleDEXToken.setExchangeRate(10);
    }

    function testAdminNotAllowedToUpdateExchangeRateToZero() public {
        vm.prank(admin);
        vm.expectRevert(SimpleDEX.SimpleDEX__ValueMustBeMoreThanZero.selector);
        simpleDEXToken.setExchangeRate(0);
    }

    function testAdminCanUpdateExchangeRate() public {
        vm.prank(admin);
        simpleDEXToken.setExchangeRate(50);
        assertEq(simpleDEXToken.getExchangeRate(), 50);
    }

    /**
     * exchange tokenA for tokenB
    //  */
    function testExchangeTokenAForTokenBFailWhenBalanceIsLess() public {
        vm.startPrank(USER);
        IERC20(tokenA).approve(simpleDEX, USER_INITIAL_BALANCE);
        
        vm.expectRevert(abi.encodeWithSelector(SimpleDEX.SimpleDEX__InsufficientTokenBalance.selector, tokenB));
        
        simpleDEXToken.exchangeTokenAForTokenB(USER_INITIAL_BALANCE);
        vm.stopPrank();
    }
    
    function testExchangeTokenAForTokenB() public {
        vm.startPrank(USER);
        IERC20(tokenA).approve(simpleDEX, TOKENA_EXCHANGE_AMOUNT);
        simpleDEXToken.exchangeTokenAForTokenB(TOKENA_EXCHANGE_AMOUNT);
        vm.stopPrank();

        console.log("TokenA balance of user", IERC20(tokenA).balanceOf(USER));
        console.log("TokenB balance of user", IERC20(tokenB).balanceOf(USER));

        assertEq(IERC20(tokenA).balanceOf(USER), USER_INITIAL_BALANCE - TOKENA_EXCHANGE_AMOUNT);
        assertEq(IERC20(tokenB).balanceOf(USER), USER_INITIAL_BALANCE +(TOKENA_EXCHANGE_AMOUNT/100));
    }

    /**
     * exchange tokenB for tokenA
     */
      function testExchangeTokenBForTokenAFailWhenBalanceIsLess() public {
        vm.startPrank(USER);
        IERC20(tokenB).approve(simpleDEX, USER_INITIAL_BALANCE);
        
        vm.expectRevert(abi.encodeWithSelector(SimpleDEX.SimpleDEX__InsufficientTokenBalance.selector, tokenA));
        
        simpleDEXToken.exchangeTokenBForTokenA(USER_INITIAL_BALANCE);
        vm.stopPrank();
    }
    
    function testExchangeTokenBForTokenA() public {
        vm.startPrank(USER);
        IERC20(tokenB).approve(simpleDEX, TOKENB_EXCHANGE_AMOUNT);
        simpleDEXToken.exchangeTokenBForTokenA(TOKENB_EXCHANGE_AMOUNT);
        vm.stopPrank();

        console.log("TokenA balance of user", IERC20(tokenA).balanceOf(USER));
        console.log("TokenB balance of user", IERC20(tokenB).balanceOf(USER));

        assertEq(IERC20(tokenA).balanceOf(USER), USER_INITIAL_BALANCE + TOKENB_EXCHANGE_AMOUNT*100);
        assertEq(IERC20(tokenB).balanceOf(USER), USER_INITIAL_BALANCE -(TOKENB_EXCHANGE_AMOUNT));
    }
}
