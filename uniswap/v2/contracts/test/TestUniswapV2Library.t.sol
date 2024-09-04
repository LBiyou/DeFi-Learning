// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IUniswapV2Pair} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import {IUniswapV2Factory} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import {UniswapV2Library} from "@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol";
import {AToken} from "../src/AToken.sol";
import {BToken} from "../src/BToken.sol";

import {Test, console2} from "forge-std/Test.sol";

contract TestUniswapV2Library is Test {
    // EOA Acctounts
    address deployer = makeAddr("Deployer");
    address user = makeAddr("User");

    // Tokens
    AToken aToken;
    BToken bToken;

    // Uniswap
    IUniswapV2Factory factory;
    IUniswapV2Pair pair;

    function setUp() public {

        aToken = new AToken();
        bToken = new BToken();

        string memory pre_path = string.concat(
            vm.projectRoot(),
            "/builds/uniswap/"
        );

        factory = IUniswapV2Factory(
            deployCode(
                string.concat(
                    pre_path,
                    "UniswapV2Factory.sol/UniswapV2Factory.json"
                ),
                abi.encode(deployer)
            )
        );
    }

    /// @notice Test sortTokens, arrange the token addresses from smallest to largest
    function test_SortTokens() external view {
        console2.log("================= before sortTokens ===================");
        console2.log(address(aToken));
        console2.log(address(bToken));
        (address token0, address token1) = UniswapV2Library.sortTokens(
            address(aToken),
            address(bToken)
        );
        console2.log("================= after sortTokens ===================");
        console2.log(token0);
        console2.log(token1);
    }

    function _deployPair(
        address _aToken,
        address _bToken
    ) internal returns (address _pair) {
        string memory pre_path = string.concat(
            vm.projectRoot(),
            "/builds/uniswap/"
        );

        bytes memory creationCode = vm.getCode(
            string.concat(pre_path, "UniswapV2Pair.sol/UniswapV2Pair.json")
        );

        (address token0, address token1) = UniswapV2Library.sortTokens(
            (_aToken),
            (_bToken)
        );

        bytes32 salt = keccak256(abi.encodePacked(token0, token1));

        assembly {
            _pair := create2(
                0,
                add(creationCode, 0x20),
                mload(creationCode),
                salt
            )
        }
    }

    /**
     * @notice It is worth noting that before creating a trading pair, the size of the tokens will be arranged first,
     *         with the smaller ones in front and the larger ones in the back.
     * @dev It is just to test the calculation principle. The salt is determined based on token0 and token1.
     */
    function test_PairFor() external {

        (address token0, address token1) = UniswapV2Library.sortTokens(
            address(aToken),
            address(bToken)
        );

        bytes32 salt = keccak256(abi.encodePacked(token0, token1));

        // Calculate the pair address based on create2.
        address _pair2 = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            uint8(0xFF),
                            address(this),
                            salt,
                            IUniswapV2Factory(factory).INIT_CODE_PAIR_HASH()
                        )
                    )
                )
            )
        );

        address _pair = _deployPair(address(aToken), address(bToken));

        assertEq(_pair, _pair2);

    }

    /**
     * @dev The quote() function is used to add liquidity to the fund pool.
     * The formula is: amountA / amountB = reserveA / reserveB 
     * [This is to ensure that the price remains unchanged.]
     */
    function test_quote() external pure {
        uint256 amountA = 100;
        uint256 amountB = UniswapV2Library.quote(amountA, 1000, 2000);
        console2.log("amountB=>", amountB);
    }

    /**
     * @dev The function of this function is to calculate the input amount of 
     * another token given the output amount of a certain token.
     * The formula is: 
     *  1. K = (reserveIn + amountIn) * (reserveOut - amountOut) = reserveOut * reserveIn
     *     amountIn = reserveIn * amountOut / (reserveOut - amountOut)
     *  2. amountIn' = amountIn * (997 / 1000)
     *  => amountIn = amountIn' / (997 / 1000)
     *  => amountIn = (reserveIn * amountOut / (reserveOut - amountOut)) * 1000 / 997
     * 
     *  For example: 
     *  amountOut = 100, reserveIn = 1e6, reserveOut = 2e6
     *  amountIn = 1e6 * 100 / (2e6 - 100) * 1000 / 997 ≈ 50.153
     *  => 50.153 Round down and add one
     *  => amountIn = 50 + 1 = 51
     */ 
    function test_getAmountIn() external pure {
        uint256 amountIn = UniswapV2Library.getAmountIn(100, 1e6, 2e6);
        console2.log("amountIn=>", amountIn); 
    }

    /**
     * @dev The function of this function is to calculate the output amount of 
     * another token given the input amount of a certain token.
     * The formula is: 
     *  1. K = (reserveIn + amountIn) * (reserveOut - amountOut) = reserveOut * reserveIn
     *     amountOut = amountIn * reserveOut / (reserveIn + amountIn)
     *  2. amountIn' = amountIn * (997 / 1000)
     *  => amountOut = (amountIn * reserveOut / (reserveIn + amountIn)) * (997 / 1000)
     * 
     *  For example:
     *  amountIn = 100, reserveIn = 1e6, reserveOut = 2e6
     *  amountOut = 100 * 2e6 / (1e6 + 100) * 997 / 1000 ≈ 199.38
     *  => 199.38 Round down
     *  => amountOut = 199
     */
    function test_getAmountOut() external pure {
        uint256 amountOut = UniswapV2Library.getAmountOut(100, 1e6, 2e6);
        console2.log("amountOut=>", amountOut); 
    }
}
