var Web3 = require("web3");
var fs = require("fs");
var abi = require("./abi.json");

/* ********************创建web3******************** */
var web3 = new Web3();
var infura_url = fs.readFileSync("../common/infura.data", "utf-8").toString().trim();
web3.setProvider(new Web3.providers.HttpProvider(infura_url));


/* *****************调用智能合约的方法**************** */
var address = ""; // 换成你的合约地址
var coinContract = new web3.eth.Contract(abi, address);

coinContract.methods
    .balanceOf("") // 换成你的钱包地址
    .call(null, function (error, result) {
        console.log("balanceOf data:[" + result / 1000000000000000000 + "], error:[" + error + "]");
    });