---
title: Chainlink Oracle
categories:
  - [DEFI,chainlink]
tags:
  - chainlink
date: 2024-03-01 12:00:00
---

### 0x00 Introduction

> 区块链就像黑匣子一样是完全封闭的，无法与外部世界连通，智能合约本身也无法连接链下数据。对于现实世界中的例如：天气，比赛分数以及航班信息等都无法获取，这也是智能合约最大的痛点，极大程度上限制了智能合约开发者的创造力，那么有什么办法可以解决吗？
>
> 答：当然是有的，预言机则充当这类角色，负责上传现实世界中的真实数据到智能合约。
>
> **预言机分为中心化预言机和去中心化预言机。**
>
> **工作流程**
>
> ![image-20240819153831639](Use-of-Chainlink/image-20240819153831639.png)
>
> ***中心化预言机***
>
> 负责上传现实世界的真实数据到智能合约的一个数据源，但是由于中心化的缘故，中心化预言机中不仅存在单点失败风险，而且还存在数据不安全风险，这又变相削弱了智能合约安全性的特性。
>
> ***去中心化预言机***
>
> 多个数据节点形成去中心预言机，每个节点都会收集数据，达成共识后输入到区块链的智能合约。而`chainlink`便是其中的一种。
>
> - 技术上：避免了单点失败风险。
> - 数据上：通过网络对多个数据源进行验证。
>
> `chainlink`提供了Data Feed，VRF，Automation 等功能，目前采用的共识机制是取中位数。

### 0x01 Data Feed

#### Principle

**业务流程**

- 数据提供商：负责收集价格数据，将价格数据提供给预言机。
- 预言机节点：获得数据之后和预言机中的其他节点达成共识，随后将共识后的数据发送到`chainlink`部署到区块链中的智能合约，最后用户可以通过部署在区块链的智能合约获取到相应的价格数据。

![image-20240819160638679](Use-of-Chainlink/image-20240819160638679.png)

**技术架构**

采用代理模式，便于合约的升级。

使用流程如下：

![image-20240819160819939](Use-of-Chainlink/image-20240819160819939.png)

**应用案例**

![image-20240819162942690](Use-of-Chainlink/image-20240819162942690.png)

#### Reproduction

**Tools:** Foundry，**Env：** Sepolia。

**Data Source:** https://docs.chain.link/data-feeds/price-feeds/addresses

**Step:**

- step1: 初始化项目

```shell
forge init
```

-  step2：拉取相关库

```shell
forge install https://github.com/smartcontractkit/chainlink --no-commit
```

- step3: 修改配置文件[create remappings]：write=> @chainlink/contracts=lib/chainlink/contracts
- step4: write smart contracts，查询当前比特币的价格

查询合约：

````solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract PriceFeed {
    AggregatorV3Interface priceFeed;

    constructor() {
        priceFeed = AggregatorV3Interface(
            0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
        );
    }

    function getPrice() public view returns (int256 price) {
        (, price, , , ) = priceFeed.latestRoundData();
    }
}

````

部署合约：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/DataFeed.sol";

contract DeployDataFeed is Script {
    function run() external returns(PriceFeed priceFeed) {
        vm.startBroadcast();
        priceFeed = new PriceFeed();
        vm.stopBroadcast();
    }
}
```

执行查询操作：

```shell
cast to-dec $(cast call 0x9AC6521008b6Cf909b0360db0B6819bBa895D559 "getPrice()" --rpc-url $env:s_rpc --private-key $env:s_pk)
```

![image-20240819173927296](Use-of-Chainlink/image-20240819173927296.png)

#### Effect

