var Web3 = require("web3");
var fs = require("fs");
var Common = require('ethereumjs-common').default
var Tx = require('ethereumjs-tx');
var abi = require("./abi.json");

/* ********************创建web3******************** */
var web3 = new Web3();
var infura_url = fs.readFileSync("../contract/common/infura.data", "utf-8").toString().trim();
web3.setProvider(new Web3.providers.HttpProvider(infura_url));


/* *****************调用智能合约的方法**************** */
var address = "0xF8d809Ad4BD3E54Da9837f2e889422CdE51E00b0"; // 换成你的合约地址
var coinContract = new web3.eth.Contract(abi, address);

coinContract.methods
    .balanceOf("0xEcaceF1040C5dC8EE5430b5f252e3AaE7Bbb6EF3") // 换成你的钱包地址
    .call(null, function (error, result) {
        console.log("balanceOf data:[" + result / 1000000000000000000 + "], error:[" + error + "]");
    });

// coinContract.methods
//     .transfer("0x7c1AaA5d8f2a82e819909C0754f04EaFcD0e9957", 100)
//     .call(null, function (error, result) {
//         console.dir(result);
//         console.log("transfer data:[" + result + "], error:[" + error + "]");
//     });

/* ******************* 以下代码还没测试成功，暂时不具备参考价值 ******************* */

var fromAddress = "0xEcaceF1040C5dC8EE5430b5f252e3AaE7Bbb6EF3";
var toAddress = "0x7c1AaA5d8f2a82e819909C0754f04EaFcD0e9957";
var count = web3.eth.getTransactionCount(fromAddress);
var gasPrice = web3.eth.gasPrice;
var gasLimit = 90000;

// 转账
var data = coinContract.methods.transfer(toAddress, 300000)
    .send({ from: fromAddress });

var rawTransaction = {
    "from": fromAddress,
    "nonce": web3.utils.toHex(count),
    "gasPrice": web3.utils.toHex(gasPrice),
    "gasLimit": web3.utils.toHex(gasLimit),
    "to": address,
    "value": "0x0",
    "data": data
};

const customCommon = Common.forCustomChain(
    'ropsten',
    {
        name: 'my-network',
        networkId: 3,
        chainId: 5,
    },
    'petersburg',
)

// 读取私钥，这里不包含‘0x’两个字符
var privateKey = fs.readFileSync("../contract/common/privateKey.data", "utf-8").toString().trim();
var privKey = new Buffer.from(privateKey, 'hex');
var tx = new Tx.Transaction(rawTransaction, customCommon);

// 用私钥签名交易信息
tx.sign(privKey);
var serializedTx = tx.serialize();

// 发送交易
web3.eth.sendRawTransaction('0x' + serializedTx.toString('hex'),
    function (err, hash) {
        if (!err)
            console.log(hash);
        else
            console.log(err);
    });