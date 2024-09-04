// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IUniswapV2Pair} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import {IUniswapV2Factory} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import {IUniswapV2Router02} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import {UniswapV2Library} from "@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {USDT} from "../src/USDT.sol";
import {WETH} from "../src/WETH.sol";
import {AToken} from "../src/AToken.sol";
import {BToken} from "../src/BToken.sol";
import {CToken} from "../src/CToken.sol";
import {DToken} from "../src/DToken.sol";

import {Test, console2} from "forge-std/Test.sol";

contract TestUniswapV2Router is Test {
    // EOA Acctounts
    address deployer = makeAddr("Deployer");
    address user = makeAddr("User");

    // Tokens
    USDT usdt;
    WETH weth;
    AToken aToken;
    BToken bToken;
    CToken cToken;
    DToken dToken;

    // Uniswap
    IUniswapV2Factory factory;
    IUniswapV2Router02 router;

    function setUp() public {
        vm.deal(deployer, 1_000_000_000 ether);
        vm.deal(user, 100 ether);

        vm.startPrank(deployer);

        factory = _deployFactory();
        router = _deployRouter(address(factory), address(weth));

        // The decimals of USDT is 6
        usdt = new USDT(); // 1u / USDT

        // The decimals of WETH, AToken, BToken, CToken, DToken are 18
        weth = new WETH(); // 2533u / WETH
        aToken = new AToken(); // 50u / AToken
        bToken = new BToken(); // 100u / BToken
        cToken = new CToken(); // 150u / CToken
        dToken = new DToken(); // 200u / DToken

        // Initialize balances
        _initializeTokensBalances();

        // approve router to all tokens
        aToken.approve(address(router), type(uint256).max);
        bToken.approve(address(router), type(uint256).max);
        cToken.approve(address(router), type(uint256).max);
        dToken.approve(address(router), type(uint256).max);

        vm.stopPrank();
    }

    function test_deploy() external view {
        assertEq(address(factory), address(router.factory()));
        assertEq(address(weth), router.WETH());
    }

    function test_balances() external view {
        assertEq(deployer.balance, 500_000_000 ether);
        assertEq(user.balance, 100 ether);
        assertEq(usdt.balanceOf(deployer), 1_000_000 ether);
        assertEq(usdt.balanceOf(user), 10_000_000 * 10 ** 6);
        assertEq(weth.balanceOf(deployer), 500_000_000 ether);
        assertEq(aToken.balanceOf(deployer), 10000 ether);
        assertEq(bToken.balanceOf(deployer), 10000 ether);
        assertEq(cToken.balanceOf(deployer), 10000 ether);
        assertEq(dToken.balanceOf(deployer), 10000 ether);
    }

    function _initializeTokensBalances() internal {
        usdt.mint(deployer, 1_000_000 ether);
        usdt.mint(user, 10_000_000 * 10 ** 6); // 100w usdt
        weth.deposit{value: 500_000_000 ether}();

        aToken.mint(deployer, 1_000_000 ether);
        bToken.mint(deployer, 1_000_000 ether);
        cToken.mint(deployer, 1_000_000 ether);
        dToken.mint(deployer, 1_000_000 ether);
    }

    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    /**
     * @notice Add liquidity to the pool
     *  The first liquidity is Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
     */
    function _addLiquidity(
        address token0,
        address token1,
        uint256 amountADesired,
        uint256 amountBDesired
    ) internal returns (uint amountA, uint amountB, uint liquidity) {
        vm.startPrank(deployer);
        (amountA, amountB, liquidity) = router.addLiquidity(
            token0,
            token1,
            amountADesired,
            amountBDesired,
            0,
            0,
            deployer,
            block.timestamp
        );
        vm.stopPrank();
    }

    /**
     * To verify the addition of liquidity,
     * the share certificate is obtained through formula: S_mint = Math.sqrt(X_deposit.mul(Y_deposit)) - 1000.
     */
    function test_firstAddLiquidity() external {
        (, , uint256 liquidity) = _addLiquidity(
            address(aToken),
            address(bToken),
            100_000 ether,
            50_000 ether
        );
        uint256 _liquidity = sqrt(100_000 ether * 50_000 ether) - 1000;
        console2.log("liquidity =>", liquidity);
        (uint256 reserve0, uint256 reserve1) = UniswapV2Library.getReserves(
            address(factory),
            address(aToken),
            address(bToken)
        );
        console2.log("AToken price: (%d / %d)", reserve0, reserve1);
        console2.log("BToken price: (%d / %d)", reserve1, reserve0);
        assertEq(_liquidity, liquidity);
    }

    /**
     * Testing removal of liquidity functionality.
     */
    function test_removeLiquidity() external {
        (, , uint256 liquidity) = _addLiquidity(
            address(aToken),
            address(bToken),
            100_000 ether,
            50_000 ether
        );
        IUniswapV2Pair pair = IUniswapV2Pair(
            factory.getPair(address(aToken), address(bToken))
        );

        vm.startPrank(deployer);

        pair.approve(address(router), type(uint256).max);
        router.removeLiquidity(
            address(aToken),
            address(bToken),
            liquidity,
            0,
            0,
            deployer,
            block.timestamp
        );
        vm.stopPrank();
    }

    /**
     * When verifying the addition of liquidity,
     * the share certificate is obtained through formula: S_mint = (X_deposit / X_starting) * S_starting.
     * The liquidity added the second time is one thousandth of the first time.
     */
    function test_secondAddLiquidity() external {
        uint256 firstLiquidity;
        uint256 secondLiquidity;
        {
            (, , firstLiquidity) = _addLiquidity(
                address(aToken),
                address(bToken),
                100_000 ether,
                50_000 ether
            );

            console2.log("First liquidity =>", firstLiquidity);
        }
        vm.startPrank(deployer);

        {
            (, , secondLiquidity) = router.addLiquidity(
                address(aToken),
                address(bToken),
                100 ether,
                50 ether,
                0,
                0,
                deployer,
                block.timestamp
            );
            console2.log("Second liquidity =>", secondLiquidity);
        }
        vm.stopPrank();
        console2.log(
            unicode"The rate of liquidity = (%d / %d) ≈ %d",
            firstLiquidity,
            secondLiquidity,
            firstLiquidity / secondLiquidity
        );
    }

    function test_swapExactTokensForTokensPathEqual2() external {
        _addLiquidity(
            address(aToken),
            address(bToken),
            100_000 ether,
            50_000 ether
        );
        {
            (uint256 reserve0, uint256 reserve1) = UniswapV2Library.getReserves(
                address(factory),
                address(aToken),
                address(bToken)
            );
            console2.log("reserve0 =>", reserve0);
            console2.log("reserve1 =>", reserve1);
            console2.log("Before swap K =>", reserve0 * reserve1);
        }

        vm.startPrank(deployer);
        address[] memory path = new address[](2);
        path[0] = address(aToken);
        path[1] = address(bToken);
        uint256[] memory amounts = router.swapExactTokensForTokens(
            10 ether,
            0,
            path,
            deployer,
            block.timestamp
        );
        console2.log("Input AToken =>", amounts[0]);
        console2.log("Output BToken =>", amounts[1]);
        vm.stopPrank();

        {
            (uint256 reserve0, uint256 reserve1) = UniswapV2Library.getReserves(
                address(factory),
                address(aToken),
                address(bToken)
            );
            console2.log("reserve0 =>", reserve0);
            console2.log("reserve1 =>", reserve1);
            console2.log("After swap K =>", reserve0 * reserve1);
        }
    }

    function test_swapExactTokensForTokensPathOver2() external {
        _addLiquidity(
            address(aToken),
            address(bToken),
            100_000 ether,
            50_000 ether
        );
        _addLiquidity(
            address(bToken),
            address(cToken),
            150_000 ether,
            100_000 ether
        );
        _addLiquidity(
            address(cToken),
            address(dToken),
            200_000 ether,
            150_000 ether
        );
        console2.log(
            "A-B Pair",
            address(factory.getPair(address(aToken), address(bToken)))
        );
        console2.log(
            "B-C Pair",
            address(factory.getPair(address(bToken), address(cToken)))
        );
        console2.log(
            "C-D Pair",
            address(factory.getPair(address(cToken), address(dToken)))
        );
        address[] memory path = new address[](4);
        path[0] = address(aToken);
        path[1] = address(bToken);
        path[2] = address(cToken);
        path[3] = address(dToken);

        vm.startPrank(deployer);
        uint256[] memory amounts = router.swapExactTokensForTokens(
            10 ether,
            2.4 ether,
            path,
            deployer,
            block.timestamp
        );
        console2.log("The amount of DTokens exchanged is", amounts[3]);
        vm.stopPrank();
    }

    function test_swapTokensForExactTokens() external {
        _addLiquidity(
            address(aToken),
            address(bToken),
            100_000 ether,
            50_000 ether
        );
        address[] memory path = new address[](2);
        path[0] = address(aToken);
        path[1] = address(bToken);

        vm.startPrank(deployer);

        uint256[] memory amounts = router.swapTokensForExactTokens(
            10 ether,
            type(uint256).max,
            path,
            deployer,
            block.timestamp
        );
        console2.log("The amount of DTokens exchanged is", amounts[0]);
        vm.stopPrank();
    }

    function _deployFactory() internal returns (IUniswapV2Factory) {
        string memory pre_path = string.concat(
            vm.projectRoot(),
            "/builds/uniswap/"
        );
        return
            IUniswapV2Factory(
                deployCode(
                    string.concat(
                        pre_path,
                        "UniswapV2Factory.sol/UniswapV2Factory.json"
                    ),
                    abi.encode(deployer)
                )
            );
    }

    function _deployRouter(
        address _factory,
        address _weth
    ) internal returns (IUniswapV2Router02) {
        string memory pre_path = string.concat(
            vm.projectRoot(),
            "/builds/uniswap/"
        );
        return
            IUniswapV2Router02(
                deployCode(
                    string.concat(
                        pre_path,
                        "UniswapV2Router02.sol/UniswapV2Router02.json"
                    ),
                    abi.encode(address(_factory), address(_weth))
                )
            );
    }
}
