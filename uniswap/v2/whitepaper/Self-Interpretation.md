## 深入解读 Uniswap V2 白皮书

### 引言

本文主要记录我个人对 uniswap v2 白皮书的解读，水平有限难免有错误之处，欢迎斧正。

旨在深入理解其中的数学原理，从而帮助进一步理解 代码的实现。

文章按照白皮书的目录进行解读，其中会加入一些个人的理解和思考。



### 1.  Introduction

Uniswap v1是一个以太坊链上智能合约系统，实现了基于 𝑥⋅𝑦=𝑘 的AMM（自动做市）协议。每一个Uniswap v1交易对池子包含两种代币，在提供流动性的过程中保证两种代币余额的乘积无法减少。交易者为每次交易支付0.3%的手续费给流动性提供者。v1的合约不可升级。

Uniswap v2是基于同一个公式的新版实现，包含许多令人期待的新特性。其中最重要的一个特性是可以支持任意ERC20代币的交易对，而不是v1只支持ERC20与ETH的交易对。此外，v2提供了价格预言机功能，其原理是在每个区块开始时累计两种代币的相对价格。这将允许其他以太坊合约可以获取任意时间段内两种代币的时间加权平均价格；最后，v2还提供“闪电贷”功能，这将允许用户在链上自由借出并使用代币，只需在该交易的最后归还这些代币并支付一定手续费即可。

虽然v2的合约也是不可升级的，但是它支持在工厂合约中修改一个变量，以便允许Uniswap协议针对每笔交易收取`0.05%`的手续费（即`0.3%`的 `1/6` ）。该手续费默认关闭，但是可以在未来被打开，在打开后流动性提供者将只能获取`0.25%`手续费，而非`0.3%`。

> 这里的数学原理将会在后面的 **2.4 Protocol fee** 

在第三节，将介绍Uniswap v2同时修复了Uniswap v1的一些小问题，同时重构了合约实现，通过最小化（持有流动性资金的）core合约逻辑，降低了Uniswap被攻击的风险，并使得系统更加容易升级。

本文讨论了core合约和用来初始化交易对合约的工厂合约的结构。实际上，使用Uniswap v2需要通过router（路由）合约调用交易对合约，它将帮助计算在交易和提供流动性时需要向交易对合约转账的代币数量。

### 2. New feature

#### 2.1 ERC-20 pairs

Uniswap v1 使用 ETH 作为桥梁货币。每对都包含 ETH 作为其资产之一。这使得路由更简单——ABC 和 XYZ 之间的每笔交易都经过 ETH/ABC 对和 ETH/XYZ 对——并减少了流动性的分散。

> - V1 和 V2 工作原理的区别：
> ![image-20240718110153513](Self-Interpretation/image-20240718110153513.png)
> ![image-20240718110756065](Self-Interpretation/image-20240718110756065.png)

然而，这条规则给流动性提供者带来了巨大的成本。所有流动性提供者都接触 ETH，并根据其他资产相对于 ETH 的价格变化而遭受无常损失。当两种资产 ABC 和 XYZ 相互关联时——例如，如果它们都是美元稳定币——Uniswap 对 ABC/XYZ 上的流动性提供者通常会比 ABC/ETH 或 XYZ/ETH 对遭受更少的无常损失。

> 什么是无常损失？可以阅读 [这篇文章](https://academy.binance.com/en/articles/impermanent-loss-explained#What-is-impermanent-loss?)。
>
> 可以举个实际案例分析：
>
> ![img](Self-Interpretation/d0a9071eb55f678cd92fda104fce85bc.jpg)
>
> `LP`亏损的资金便被称为无常损失。
>
> 这样看似乎，做`LP`反而会亏钱，但是实际上这部分的损失已经由用户的手续费冲淡了。（因为不断地收取用户的手续费，从而使得池子越来越深，`LP`可以从中获利。）
>
> 因为稳定币的价格比较稳定，不会像 ETH 有这么大的波动，所以相对来说遭受的无常损失较弱。

使用 ETH 作为强制性桥梁货币也会给交易者带来成本。交易者必须支付的费用是直接 ABC/XYZ 对的两倍，并且他们会遭受两次滑点。 

Uniswap v2 允许流动性提供者为任意两个 ERC-20 创建配对合约。

> v2不直接支持 ETH 的交易对，它需要 wrap 成遵循 ERC20 标准的 WETH Token。

任意 ERC-20 之间的配对激增可能会使找到交易特定配对的最佳路径变得更加困难，但可以在更高层处理路由（链下或通过链上路由器或聚合器）。



#### 2.2 Price Oracle







### 3. Other changes

#### 3.4 Initialization of liquidity token supply

当一个新的流动性提供者将代币存入一个已存在的Uniswap交易对，新铸造的流动性代币数量可根据当前代币数量计算：

$$
s_{minted} = \frac{x_{deposited}}{x_{starting}} * s_{starting}
$$

> 这里 ${s_{minted}}$ 其实本身也是一种ERC20 Token，持有的流动性 Token的数量即表示占有该交易池的份额（一般称之为share）。
>
> 当往现有的交易对，且不是第一个流动性提供者，那么存入的代币价值和总价值的比例，与其得到的 LP Token数量和 LP Token 的总数量（可以通过`totalSupply()`获取）的比例相等。即
>
>
> $$
> \frac {s_{minted}} {s_{starting}} = \frac {x_{deposited}} {x_{starting}}
> $$
>
>
> 但是在实际的代码实现中，只需要比较 $ \frac {x_{deposited}}{x_0} $ ，其中`x`指的交易对中的某个代币，比如`ETH/DAI`中的`ETH`， ${x_0}$ 指未添加流动性前`x`的数量。白皮书这里没有说`x`是什么，所以我尝试着理解为 `x*y`的乘积开根号算出来的结果也没错。推导过程如下：
>
> ![da778117626a9b85a0402995a60ce55c](Self-Interpretation/da778117626a9b85a0402995a60ce55c.jpg)
>
> 举个实际案例：往 ETH/DAI 交易池中添加流动性即做lp。
>
>
> $$
> state_0 ==> ETH = 10 : DAI = 100, add => ETH=2,DAI=20
> $$
>
> 如果采用上述文字部分的推导，则计算过程如下：
>
> $$
> s_{minted} = \frac {\Delta {ETH}} {{ETH}_0} *s_1 = \frac {2} {10} *s_1 = 0.2 *s_1\tag {1}
> $$
>
> 如果采用的是图中的推导，则计算过程如下：
>
> $$
> \sqrt {k_1} = \sqrt {x_0 * y_0} = \sqrt {10 * 100},\sqrt {k_2} = \sqrt {x_1 * y_1} = \sqrt {12 * 120}
> $$
>
> 
> $$ s_{minted} = \frac {{\sqrt k_2} - {\sqrt k_1}}  {\sqrt k_1} *s_1 = \frac {{\sqrt {12*120}} - {\sqrt {10*100}}} {\sqrt{10*100}} * s_1 = 0.2 *s_1\tag {2 }$$
> 
>
> 由此可见，`(1)`和`(2)`的结果是一致的，感觉两种方式都可以，但是还是推荐文字版推导，因为白皮书是这么写的。




### 文章延伸

#### swap导致价格波动的原因

UNISWAP 围绕着 `x * y = k` 这个恒定乘积执行代币的`swap`操作。

$$
x * y = k  \tag{恒定乘积AMM}
$$

如果 userA 使用 ${\Delta x}$ 数量 的 TokenA 去兑换 TokenB，有

$$
y'_1 = \frac {k} {x_0 + \Delta x}
$$

如果 userB 使用 ${\Delta x}$  数量 的 TokenA 去兑换 TokenB，有

$$
y'_2 = \frac {k} {x_0 + \Delta x + \Delta x} 
$$


不难看出 ${y'_2}$ 的值肯定是要比 ${y'_1}$ 的值要小的，从而反映出 TokenB的价格升高了。


这是因为 TokenA 的数量变多了，即使 userB 和 userA 的 TokenA 数量相同，那么后来者的 TokenA 将会对池子中TokenA的数量影响将会被削弱，即池子TokenA的数量将不会受到同样大幅度的影响。

举个例子，假如ETH/DAI池子中的资金为：ETH(100):DAI(10000)，K = 100 * 10000 = 1e6

$$
state_0: K = 1e6, ETH=100, DAI=10000
$$

假设userA使用10个ETH兑换DAI，有

$$
y'_1 = \frac {k} {x_0 + \Delta x} = \frac {1e6} {100 + 10} \approx 9090.9
$$

$$
\Delta y_1 = y_0 - y'_1 = 10000 - 9090.9 = 909.1 DAI
$$

$$
state_1: K = 1e6, ETH=110, DAI=9090.9
$$

假设userB也使用10个ETH兑换DAI，有

$$
y'_2 = \frac {k} {x_1 + \Delta x} = \frac {1e6} {110 + 10} \approx 8333.3
$$

$$
\Delta y_2 = y_0 - y'_2 = 9090.9 - 8333.3 = 757.6 DAI
$$

$$
state_2: K = 1e6, ETH=120, DAI=8333.3
$$

userB也是使用10 ETH兑换 DAI，换出来的DAI要少于userA兑换的DAI，说明TokenB的价格变高了。


TokenA 和 TokenB 在池中的数量变换关系为：

![image-20240715142350886](Self-Interpretation/image-20240715142350886.png)

![image-20240715142620934](Self-Interpretation/image-20240715142620934.png)