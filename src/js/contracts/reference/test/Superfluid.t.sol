// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "ds-test/test.sol";

import "../contracts/Superfluid/MoneyRouter.sol";
import {ISuperfluid, ISuperToken, ISuperApp } from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import { ISETH } from "@superfluid-finance/ethereum-contracts/contracts/interfaces/tokens/ISETH.sol";
import { IPureSuperToken } from "@superfluid-finance/ethereum-contracts/contracts/interfaces/tokens/IPureSuperToken.sol";
import { PureSuperToken } from "@superfluid-finance/ethereum-contracts/contracts/tokens/PureSuperToken.sol";
import {IConstantFlowAgreementV1} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/IConstantFlowAgreementV1.sol";
import {ERC1820RegistryCompiled} from "@superfluid-finance/ethereum-contracts/contracts/libs/ERC1820RegistryCompiled.sol";

import {TestToken} from "@superfluid-finance/ethereum-contracts/contracts/utils/TestToken.sol";
import {SuperfluidUtils} from "./utils/SuperfluidUtils.sol";
import {SuperfluidFrameworkDeployer} from "@superfluid-finance/ethereum-contracts/contracts/utils/SuperfluidFrameworkDeployer.sol";


contract MoneyRouterTest is Test {

    MoneyRouter public moneyRouter;

    // ISuperfluid public host;
    // IConstantFlowAgreementV1 public cfa;
    TestToken public dai;
	// ISETH public ethx;
    ISuperToken public daix;
	ISuperToken public ETHx;
    address public account1;
    address public account2;
	SuperfluidUtils su;

    SuperfluidFrameworkDeployer.Framework sf;

    function setUp() public {
		su = new SuperfluidUtils();

		su.setUp();

		account1 = vm.addr(1);
        account2 = vm.addr(2);

		sf = su.getFramework();


        vm.startPrank(account1);
        (dai, daix) = su.getTokens();

        dai.mint(account1, 100000000000000000);
        dai.approve(address(daix), 100000000000000000);
        daix.upgrade(100000000000000000);

        vm.stopPrank();
		moneyRouter = new MoneyRouter(account1);

        vm.prank(account1);
        daix.transfer(address(moneyRouter), 50000000000000000);
    }

	function testCreateFlowsIntoContract() public {
        setUp();

        vm.startPrank(account1);

        dai.mint(account1, 100000000000000000);
        dai.approve(address(daix), 100000000000000000);
        daix.upgrade(100000000000000000);

        sf.cfaV1Forwarder.grantPermissions(daix, address(moneyRouter));
        moneyRouter.createFlowIntoContract(daix, 30000000);
        (, int96 checkCreatedFlowRate, , ) = sf.cfa.getFlow(daix, account1, address(moneyRouter));
        assertEq(30000000, checkCreatedFlowRate);

        moneyRouter.updateFlowIntoContract(daix, 60000000);
        (, int96 checkUpdatedFlowRate, , ) = sf.cfa.getFlow(daix, account1, address(moneyRouter));
        assertEq(60000000, checkUpdatedFlowRate);

        moneyRouter.deleteFlowIntoContract(daix);
        (, int96 checkDeletedFlowRate, , ) = sf.cfa.getFlow(daix, account1, address(moneyRouter));
        assertEq(0, checkDeletedFlowRate);
        vm.stopPrank();
    }

    function testCreateFlowsFromContract() public {
        setUp();

        vm.startPrank(account1);

        dai.mint(account1, 100000000000000000);
        dai.approve(address(daix), 100000000000000000);
        daix.upgrade(100000000000000000);


        moneyRouter.createFlowFromContract(daix, account2, 30000000);
        (, int96 checkCreatedFlowRate, , ) = sf.cfa.getFlow(daix, address(moneyRouter), account2);
        assertEq(30000000, checkCreatedFlowRate);

        moneyRouter.updateFlowFromContract(daix, account2, 60000000);
        (, int96 checkUpdatedFlowRate, , ) = sf.cfa.getFlow(daix, address(moneyRouter), account2);
        assertEq(60000000, checkUpdatedFlowRate);

        moneyRouter.deleteFlowFromContract(daix, account2);
        (, int96 checkDeletedFlowRate, , ) = sf.cfa.getFlow(daix, address(moneyRouter), account2);
        assertEq(0, checkDeletedFlowRate);
    }
}
