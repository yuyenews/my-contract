## 项目简介
基于Truffle+infura 开发的以太坊智能合约，符合ERC20协议，【仅仅是一个demo，给小白照葫芦画瓢用的，抄一遍就可以快速摸到一点点门道】

## 目录简介

- contract是合约目录，是一个标准的truffle项目
- web-js是调用合约的demo，基于web3.js编写

## 使用前的准备工作

1. 先在本地把truffle环境搭建起来，可以参考[这个文档](https://learnblockchain.cn/docs/truffle/getting-started/installation.html)
2. 在infura上新建节点[infura网站](https://infura.io)
3. 准备一个chrome浏览器或者firfox浏览器，如果你没有“科学上网”的条件，建议用firfox，进入到插件商店，安装metamask钱包
4. 学习solidity语言，可以参考[这个文档](https://solidity-cn.readthedocs.io/zh/develop/installing-solidity.html)（如果仅仅想把这个项目运行起来，那么暂时不需要学）
5. 在本地搭建nodejs环境

## 给metamask冲测试币

1. 打开这个网站[https://faucet.metamask.io/](https://faucet.metamask.io/)
2. 将metamask切换到ropsten网络
3. 点击第一个绿色的按钮，即可获取测试币(最好早上充，不然容易被限流，充进不去)

## 发布合约

### 1. 安装HDWalletProvider
命令行进入到contract目录，然后执行以下命令
```
npm install truffle-hdwallet-provider
```

### 2. 配置 助记词和infura
```
在contract目录下建一个common目录，在common目录里新建两个文件：

1. 一个叫mnemonic.data，把助记词拷贝到这个文件里
2. 一个叫infua.data，把infua节点路径拷贝到这个文件里
```

### 4. 更改代币的名称
```
编辑contract/migrations/1_inital_migration.js

找到deployer.deploy(BTCCContract, 要发行的代币数量, '代币全称', '代币简称');进行编辑
```

### 5. 在命令行进入到contract目录，运行以下命令
```
truffle migrate --network ropsten
```

### 6. 如果没问题的话，将会看到类似的信息
```
Replacing 'Migrations'
----------------------
> transaction hash:    0b0b2344ecb1fbd5ad9b49a2731d4105bc3961990
> Blocks: 2            Seconds: 21
> contract address:    2Db13A0667e10200C45eeC80DD3
> block number:        10922
> block timestamp:     16301
> account:             C8EE5430b5f252e3AaE7Bbb6EF3
> balance:             4.991695299877712367
> gas used:            193 (0x2f2db)
> gas price:           2.800000001 gwei
> value sent:          0 ETH
> total cost:          0.000541080400193243 ETH

Pausing for 2 confirmations...
------------------------------
> confirmation number: 1 (block: 10922338)
> confirmation number: 2 (block: 10922339)

Replacing 'BTCCContract'
----------------------
> transaction hash:    ab61b248b194e65f0a1937441f29c545ca3fea67d6f3
> Blocks: 3            Seconds: 33
> contract address:    56C96CE64b055258D0e8171f0
> block number:        10922
> block timestamp:     163013
> account:             EE5430b5f252e3AaE7Bbb6EF3
> balance:             4.988500348673148151
> gas used:            1141054 (0x11693e)
> gas price:           2.800000004 gwei
> value sent:          0 ETH
> total cost:          0.003194951204564216 ETH
```

## 调用合约

#### 1. 最简单的方法
```
1. 找到发布合约时，命令行返回的那堆数据，
在Replacing 'BTCCContract'下面那一堆里面找到 contract address，后面就是合约地址

2. 打开你的metamask插件，切换到ropsten网络，
点击添加代币，将合约地址输入，即可添加进去

3. 完成以上两步，即可看到你创建的合约，以及代币数量，找到另一个metamask钱包，也在里面添加此合约，然后给他发送一点代币，如果能正常的发出与收到，则表示成功了
```

### 2. 用web3.js

进入到web-js目录下，将contract/build/contracts/BTCCContract.json里面的abi节点全部拷贝到web-js目录下的abi.json文件中（直接替换覆盖）

安装web3
```
npm install web3
```

运行main.js
```
node main.js
```
如果能看到余额也代表成功了
