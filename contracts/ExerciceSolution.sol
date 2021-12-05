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

        uint amountIn = myTokenAmount / 5;
        uint amountOutMin = 1; // I guess you should never do that
        uint deadline = block.timestamp + 300;
        address[] memory path = new address[](2);
        path[0] = myTokenAddress;
        path[1] = wethAddress;
        
        IERC20(myTokenAddress).approve(address(uniswapV2Router02), amountIn);

        uniswapV2Router02.swapExactTokensForETH(amountIn, amountOutMin, path, msg.sender, deadline);
    }

    function swapYourTokenForDummyToken() public {
        uint myTokenAmount = IERC20(myTokenAddress).balanceOf(address(this));
        require(myTokenAmount > 0, "No token to swap for dummyToken");

        uint amountIn = myTokenAmount / 2;
        uint amountOutMin = 1; // I guess you should never do that
        uint deadline = block.timestamp + 300;
        address[] memory path = new address[](2);
        path[0] = myTokenAddress;
        path[1] = dummyAddress;
        
        IERC20(myTokenAddress).approve(address(uniswapV2Router02), amountIn);

        uniswapV2Router02.swapExactTokensForTokens(amountIn, amountOutMin, path, msg.sender, deadline);
    }
	
}