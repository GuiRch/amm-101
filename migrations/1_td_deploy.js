var TDErc20 = artifacts.require("ERC20TD.sol");
var ERC20 = artifacts.require("DummyToken.sol"); 
var evaluator = artifacts.require("Evaluator.sol");
var erc20Basics = artifacts.require("ERC20Basics.sol");
var exerciceSolution = artifacts.require("ExerciceSolution.sol");


module.exports = (deployer, network, accounts) => {
    deployer.then(async () => {
        await hardcodeContractAddress(deployer, network, accounts)
        // await deployFirstSolution(deployer, network, accounts);
        await deployExerciceSolution(deployer, network, accounts);
    });
};

async function hardcodeContractAddress(deployer, network, accounts) {
	TDToken = await TDErc20.at("0x89Aa93ac2f2B59a1c00294815fbE6b1e8438319e")
	Evaluator = await evaluator.at("0x90315516b2F5534ac68f109bA9412530EbECfac1")
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
    wethAddress = "0xc778417e063141139fce010982780140aa0cd5ab"
    dummyAddress = "0xFed1E3aa9fB4Cf7ccD5Ce0291deCa90a3D23bFA6"
    uniswapV2Router02Address = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D"
    ERC20Basics = await erc20Basics.at("0x326CC27853d4C3860F964B1ffC13EB58d57705DD") // Hardcoded

    ExerciceSolution = await exerciceSolution.new(wethAddress, dummyAddress, ERC20Basics.address, uniswapV2Router02Address)
    console.log("ExerciceSolution contract address : " + ExerciceSolution.address)

    myTokenAmountOwner = await ERC20Basics.balanceOf(accounts[0])
    console.log("myTokenAmountOwner " + myTokenAmountOwner)
    // myTokenAmountOwnerToSend = myTokenAmountOwner / 1000
    myTokenAmountOwnerToSend = Math.pow(10, 20)
    console.log("myTokenAmountOwnerToSend " + myTokenAmountOwnerToSend)

    myTokenAmountBefore = await ERC20Basics.balanceOf(ExerciceSolution.address)
    console.log("myTokenAmountBefore " + myTokenAmountBefore)
    await ERC20Basics.transfer(ExerciceSolution.address, myTokenAmountOwnerToSend.toString())
    myTokenAmountAfter = await ERC20Basics.balanceOf(ExerciceSolution.address)
    console.log("myTokenAmountAfter " + myTokenAmountAfter)
    
    await Evaluator.submitExercice(ExerciceSolution.address)
    console.log("Exercice submitted")
    
    await Evaluator.ex8_contractCanSwapVsEth()
    console.log("Exercice 8 done")

    await Evaluator.ex9_contractCanSwapVsDummyToken()
    console.log("Exercice 9 done")
}