// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.24;

import {Pool} from "../../../libraries/Pool.sol";
import {BurnMintTokenPool} from "../../../pools/BurnMintTokenPool.sol";
import {TokenPool} from "../../../pools/TokenPool.sol";
import {BurnMintSetup} from "./BurnMintSetup.t.sol";

import {IERC20} from "../../../../vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/IERC20.sol";

contract BurnMintTokenPoolSetup is BurnMintSetup {
  BurnMintTokenPool internal s_pool;

  function setUp() public virtual override {
    BurnMintSetup.setUp();

    s_pool = new BurnMintTokenPool(s_burnMintERC677, new address[](0), address(s_mockRMN), address(s_sourceRouter));
    s_burnMintERC677.grantMintAndBurnRoles(address(s_pool));

    _applyChainUpdates(address(s_pool));
  }
}

contract BurnMintTokenPool_releaseOrMint is BurnMintTokenPoolSetup {
  function test_PoolMint_Success() public {
    uint256 amount = 1e19;
    address receiver = makeAddr("receiver_address");

    vm.startPrank(s_burnMintOffRamp);

    vm.expectEmit();
    emit IERC20.Transfer(address(0), receiver, amount);

    s_pool.releaseOrMint(
      Pool.ReleaseOrMintInV1({
        originalSender: bytes(""),
        receiver: receiver,
        amount: amount,
        localToken: address(s_burnMintERC677),
        remoteChainSelector: DEST_CHAIN_SELECTOR,
        sourcePoolAddress: abi.encode(s_remoteBurnMintPool),
        sourcePoolData: "",
        offchainTokenData: ""
      })
    );

    assertEq(s_burnMintERC677.balanceOf(receiver), amount);
  }

  function test_PoolMintNotHealthy_Revert() public {
    // Should not mint tokens if cursed.
    s_mockRMN.setGlobalCursed(true);
    uint256 before = s_burnMintERC677.balanceOf(OWNER);
    vm.startPrank(s_burnMintOffRamp);

    vm.expectRevert(TokenPool.CursedByRMN.selector);
    s_pool.releaseOrMint(
      Pool.ReleaseOrMintInV1({
        originalSender: bytes(""),
        receiver: OWNER,
        amount: 1e5,
        localToken: address(s_burnMintERC677),
        remoteChainSelector: DEST_CHAIN_SELECTOR,
        sourcePoolAddress: _generateSourceTokenData().sourcePoolAddress,
        sourcePoolData: _generateSourceTokenData().extraData,
        offchainTokenData: ""
      })
    );

    assertEq(s_burnMintERC677.balanceOf(OWNER), before);
  }

  function test_ChainNotAllowed_Revert() public {
    uint64 wrongChainSelector = 8838833;

    vm.expectRevert(abi.encodeWithSelector(TokenPool.ChainNotAllowed.selector, wrongChainSelector));
    s_pool.releaseOrMint(
      Pool.ReleaseOrMintInV1({
        originalSender: bytes(""),
        receiver: OWNER,
        amount: 1,
        localToken: address(s_burnMintERC677),
        remoteChainSelector: wrongChainSelector,
        sourcePoolAddress: _generateSourceTokenData().sourcePoolAddress,
        sourcePoolData: _generateSourceTokenData().extraData,
        offchainTokenData: ""
      })
    );
  }
}
