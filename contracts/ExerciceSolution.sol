pragma solidity >=0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./utils/IUniswapV2Router02.sol";

contract ExerciceSolution {

    address public owner;
    address public wethAddress;
    address public dummyAddress;
    address public myTokenAddress;
    IUniswapV2Router02 uniswapV2Router02;
    
    constructor(address _wethAddress, address _dummyAddress, address _myTokenAddress, IUniswapV2Router02 _uniswapV2Router02Address) public {
        owner = msg.sender;
        wethAddress = _wethAddress;
        dummyAddress = _dummyAddress;
        myTokenAddress = _myTokenAddress;
        uniswapV2Router02 = IUniswapV2Router02(_uniswapV2Router02Address);
	}

    function swapYourTokenForEth() public {
        uint myTokenAmount = IERC20(myTokenAddress).balanceOf(address(this));
        require(myTokenAmount > 0, "No token to swap for ether");

        uint amountIn = myTokenAmount / 2;
        // uint amountOutMin = 1; // I guess you should never do that
        uint amountOutMin = getAmountOutMin(myTokenAddress, wethAddress, amountIn);
        uint deadline = block.timestamp + 300;
        address[] memory path = new address[](2);
        path[0] = myTokenAddress;
        path[1] = wethAddress;
        
        IERC20(myTokenAddress).approve(address(uniswapV2Router02), amountIn);

        uniswapV2Router02.swapExactTokensForETH(amountIn, amountOutMin, path, msg.sender, deadline);
    }

    /*
    function swapYourTokenForDummyToken() public {
        uint myTokenAmount = IERC20(myTokenAddress).balanceOf(address(this));
        require(myTokenAmount > 0, "No token to swap for dummyToken");

        uint amountIn = myTokenAmount / 2;
        // uint amountOutMin = 1; // I guess you should never do that
        uint amountOutMin = getAmountOutMin(myTokenAddress, wethAddress, amountIn);
        uint deadline = block.timestamp + 300;
        address[] memory path = new address[](3);
        path[0] = myTokenAddress;
        path[1] = wethAddress;
        path[2] = dummyAddress;
        
        IERC20(myTokenAddress).approve(address(uniswapV2Router02), amountIn);

        uniswapV2Router02.swapExactTokensForTokens(amountIn, amountOutMin, path, msg.sender, deadline);
    }
    */

    /*
    function addLiquidity() public {
        uint myTokenAmount = IERC20(myTokenAddress).balanceOf(address(this));
        require(myTokenAmount > 0, "No token to swap for dummyToken");
        require(address(this).balance > 0, "Not enough Ether");

        uint amountTokenDesired = myTokenAmount / 2;
        uint amountTokenMin = 1;
        uint amountETHMin = 1;
        uint deadline = block.timestamp + 300;

        IERC20(myTokenAddress).approve(address(uniswapV2Router02), amountTokenDesired);

        uniswapV2Router02.addLiquidityETH{ value: msg.sender }(myTokenAddress, amountTokenDesired, amountTokenMin, amountETHMin, msg.sender, deadline);
    }
    */

    // Reliable ?
    function getAmountOutMin(address _tokenIn, address _tokenOut, uint256 _amountIn) public returns (uint256) {

       //path is an array of addresses.
       //this path array will have 3 addresses [tokenIn, WETH, tokenOut]
       //the if statement below takes into account if token in or token out is WETH.  then the path is only 2 addresses
        address[] memory path;
        if (_tokenIn == wethAddress || _tokenOut == wethAddress) {
            path = new address[](2);
            path[0] = _tokenIn;
            path[1] = _tokenOut;
        } else {
            path = new address[](3);
            path[0] = _tokenIn;
            path[1] = wethAddress;
            path[2] = _tokenOut;
        }
        
        uint256[] memory amountOutMins = uniswapV2Router02.getAmountsOut(_amountIn, path);
        return amountOutMins[path.length -1];  
    }
	
}