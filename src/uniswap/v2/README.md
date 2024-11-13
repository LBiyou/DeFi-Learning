### 0x00 Preparation

#### **安装相关的包**

```shell
forge install Uniswap/v2-core --no-commit && 
forge install Uniswap/v2-periphery --no-commit &&
forge install OpenZeppelin/openzeppelin-contracts --no-commit
```

#### **添加映射remappings.txt**

```js
@uniswap/v2-core/=lib/v2-core/
@uniswap/v2-periphery/=lib/v2-periphery/
@openzeppelin/contracts/=lib/openzeppelin-contracts/contracts/
```

#### **修改源码**

- 在 `UniswapV2Factory.sol`合约中添加一行代码

```solidity
bytes32 public constant INIT_CODE_PAIR_HASH = keccak256(abi.encodePacked(type(UniswapV2Pair).creationCode));
```

- 在 `IUniswapV2Factory.sol`合约中添加

```solidity
function INIT_CODE_PAIR_HASH() external view;
```

- 修改 `UniswapV2Library.sol`合约

    修改 `UniswapV2Library.sol:pairFor()`

```solidity
// step1
hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
// =>
IUniswapV2Factory(factory).INIT_CODE_PAIR_HASH() // init code hash

// step2: 将 `pure` 修改为 `view`
function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair)
// =>
function pairFor(address factory, address tokenA, address tokenB) internal view returns (address pair)
```

​	并导入`IUniswapV2Factory.sol`

```solidity
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol';
```

#### **获取字节码**

- 首先，先编译出需要用到的`uniswap`合约的字节码，将其存放到`builds/uniswap`中

```shell
forge build --out builds/uniswap --names UniswapV2Factory lib/v2-core/contracts/UniswapV2Factory.sol; forge build --out builds/uniswap --names UniswapV2Router02 lib/v2-periphery/contracts/UniswapV2Router02.sol
```

- 编译报错：无法导入`TransferHelper.sol`

```
[⠢] Compiling 9 files with Solc 0.6.6
[⠆] Solc 0.6.6 finished in 65.50ms
Error:
Compiler run failed:
Error: Source "@uniswap/lib/contracts/libraries/TransferHelper.sol" not found: File outside of allowed directories.
lib/v2-periphery/contracts/UniswapV2Router02.sol:4:1: ParserError: Source "@uniswap/lib/contracts/libraries/TransferHelper.sol" not found: File outside of allowed directories.
import '@uniswap/lib/contracts/libraries/TransferHelper.sol';
```

- 修改源码，手动加入`lib\v2-periphery\contracts\libraries\TransferHelper.sol`这个所需合约，同时修改代码

```solidity
import '@uniswap/lib/contracts/libraries/TransferHelper.sol';
//  =>
import './libraries/TransferHelper.sol';
```

- 再次编译，编译成功。

#### 	添加Token

- WETH
- USDT
- AToken，BToken，CToken，DToken （ERC20）



### 0x01 Deploy Contacts

#### 踩坑1

使用字节码部署uniswap相关的合约时报错，无法访问：

```js
[FAIL. Reason: setup failed: the path builds/uniswap/UniswapV2Factory.sol/UniswapV2Factory.json is not allowed to be accessed for read operations]
```

解决办法：在`remappings.txt`开启访问权限

```toml
fs_permissions = [
    { access = "read", path = "./builds/uniswap/"}
]
```

#### 踩坑2

使用`foundry`测试`UniswapV2Library.sol`报错。

原因：`SafeMath`版本问题，修改适用版本范围即可：

```solidity
pragma solidity =0.6.6;
// =>
pragma solidity >=0.6.6;
```

