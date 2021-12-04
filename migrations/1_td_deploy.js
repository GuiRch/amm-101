var TDErc20 = artifacts.require("ERC20TD.sol");
var ERC20 = artifacts.require("DummyToken.sol"); 
var evaluator = artifacts.require("Evaluator.sol");
var erc20Basics = artifacts.require("ERC20Basics.sol");
// var exerciceSolution = artifacts.require("ExerciceSolution.sol");


module.exports = (deployer, network, accounts) => {
    deployer.then(async () => {
        await hardcodeContractAddress(deployer, network, accounts)
        // await deployFirstSolution(deployer, network, accounts); 
        await deployExerciceSolution(deployer, network, accounts); 
    });
};

async function hardcodeContractAddress(deployer, network, accounts) {
	TDToken = await TDErc20.at("0xC366a0CDcdcD2E0C3141acDC8302f0fCa53848a3")
	Evaluator = await evaluator.at("0x34342dE8bDFd22228350e65376109123CF1Bd7E8")
}

async function deployFirstSolution(deployer, network, accounts) {
	var myPoints = await TDToken.balanceOf(accounts[0])
	console.log("Points before : " + myPoints.toString())

    await Evaluator.ex6a_getTickerAndSupply()
    console.log("Ex 6a : " + myPoints.toString())
	const ticker = await Evaluator.readTicker(accounts[0])
    console.log("Ticker : " + ticker)
	const supply = await Evaluator.readSupply(accounts[0])
    console.log("Supply : " + supply.toString())
    
    ERC20Basics = await erc20Basics.new(ticker, ticker, supply.toString())
    console.log("Points at that step : " + myPoints.toString())
    console.log("ERC20 Basics contract address : " + ERC20Basics.address)
    
    await Evaluator.submitErc20(ERC20Basics.address)
    console.log("Points after submitErc20 : " + myPoints.toString())
    await Evaluator.ex6b_testErc20TickerAndSupply()

	console.log("Points after : " + myPoints.toString())
}

async function deployExerciceSolution(deployer, network, accounts) {
	uniswapV2FactoryAddress = "0x5c69bee701ef814a2b6a3edd4b1652cb9cc5aa6f"
	wethAddress = "0xc778417e063141139fce010982780140aa0cd5ab"
}