// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract bcsc2025amm {
    IERC20 public tokenA;
    IERC20 public tokenB;

    uint256 public reserveA;
    uint256 public reserveB;

    mapping(address => uint256) public liquidity;
    uint256 public totalLiquidity;

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function mint(uint256 amountA, uint256 amountB) external returns (uint256 shares) {
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        if (totalLiquidity == 0) {
            shares = sqrt(amountA * amountB);
        } else {
            shares = min(
                (amountA * totalLiquidity) / reserveA,
                (amountB * totalLiquidity) / reserveB
            );
        }
        
        require(shares > 0, "Liquidity mintata insufficiente");

        liquidity[msg.sender] += shares;
        totalLiquidity += shares;
        reserveA += amountA;
        reserveB += amountB;
    }

    function burn(uint256 shares) external returns (uint256 amountA, uint256 amountB) {
        require(liquidity[msg.sender] >= shares, "Non hai abbastanza quote");

        amountA = (shares * reserveA) / totalLiquidity;
        amountB = (shares * reserveB) / totalLiquidity;

        liquidity[msg.sender] -= shares;
        totalLiquidity -= shares;
        reserveA -= amountA;
        reserveB -= amountB;

        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);
    }

    function swap(address tokenIn, uint256 amountIn) external returns (uint256 amountOut) {
        bool isAtoB = tokenIn == address(tokenA);
        require(isAtoB || tokenIn == address(tokenB), "INVALID_TOKEN");

        (IERC20 tokenFrom, IERC20 tokenTo, uint256 reserveFrom, uint256 reserveTo) =
            isAtoB ? (tokenA, tokenB, reserveA, reserveB) : (tokenB, tokenA, reserveB, reserveA);

        tokenFrom.transferFrom(msg.sender, address(this), amountIn);

        uint256 amountInWithFee = (amountIn * 997) / 1000;
        amountOut = (amountInWithFee * reserveTo) / (reserveFrom + amountInWithFee);

        require(amountOut > 0, "INSUFFICIENT_OUTPUT");

        tokenTo.transfer(msg.sender, amountOut);

        if (isAtoB) {
            reserveA += amountIn;
            reserveB -= amountOut;
        } else {
            reserveB += amountIn;
            reserveA -= amountOut;
        }
    }

    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function min(uint x, uint y) internal pure returns (uint) {
        return x <= y ? x : y;
    }
}
