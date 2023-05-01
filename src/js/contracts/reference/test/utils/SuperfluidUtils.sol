// SPDX-License-Identifier: AGPLv3
pragma solidity 0.8.19;

import "forge-std/console.sol";
import {FoundrySuperfluidTester} from "@superfluid-finance/ethereum-contracts/test/foundry/FoundrySuperfluidTester.sol";
import { SuperAppBaseCFA } from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperAppBaseCFA.sol";
import { SuperAppBaseCFATester } from "@superfluid-finance/ethereum-contracts/contracts/mocks/SuperAppBaseCFATester.sol";
import { ISuperToken, ISuperApp, SuperAppDefinitions } from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import { IConstantFlowAgreementV1 } from "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/IConstantFlowAgreementV1.sol";
import { SuperTokenV1Library } from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";
import {SuperfluidFrameworkDeployer} from "@superfluid-finance/ethereum-contracts/contracts/utils/SuperfluidFrameworkDeployer.sol";
import {TestToken} from "@superfluid-finance/ethereum-contracts/contracts/utils/TestToken.sol";
import {SuperToken} from "@superfluid-finance/ethereum-contracts/contracts/superfluid/SuperToken.sol";

contract SuperfluidUtils is FoundrySuperfluidTester {

    // using SuperTokenV1Library for SuperToken;
    // using SuperTokenV1Library for ISuperToken;

    SuperAppBaseCFATester superApp;
    address superAppAddress;
    ISuperToken otherSuperToken;

    constructor () FoundrySuperfluidTester(3) {
        superApp = new SuperAppBaseCFATester(sf.host, true, true, true);
        superAppAddress = address(superApp);
    }

    // function _genManifest(bool activateOnCreated, bool activateOnUpdated, bool activateOnDeleted) internal pure returns (uint256) {

    //     uint256 callBackDefinitions = SuperAppDefinitions.APP_LEVEL_FINAL
    //     | SuperAppDefinitions.BEFORE_AGREEMENT_CREATED_NOOP;

    //     if (!activateOnCreated) {
    //         callBackDefinitions |= SuperAppDefinitions.AFTER_AGREEMENT_CREATED_NOOP;
    //     }

    //     if (!activateOnUpdated) {
    //         callBackDefinitions |= SuperAppDefinitions.BEFORE_AGREEMENT_UPDATED_NOOP
    //         | SuperAppDefinitions.AFTER_AGREEMENT_UPDATED_NOOP;
    //     }

    //     if (!activateOnDeleted) {
    //         callBackDefinitions |= SuperAppDefinitions.BEFORE_AGREEMENT_TERMINATED_NOOP
    //         | SuperAppDefinitions.AFTER_AGREEMENT_TERMINATED_NOOP;
    //     }

    //     return callBackDefinitions;
    // }

    // function _deploySuperAppAndGetConfig(
    //     bool activateOnCreated,
    //     bool activateOnUpdated,
    //     bool activateOnDeleted
    // ) internal returns (SuperAppBaseCFATester, uint256 configWord) {
    //     SuperAppBaseCFATester mySuperApp = new SuperAppBaseCFATester(sf.host, activateOnCreated, activateOnUpdated, activateOnDeleted);
    //     uint256 appConfig = _genManifest(activateOnCreated, activateOnUpdated, activateOnDeleted);
    //     return (mySuperApp, appConfig);
    // }

    function getFramework () external view returns (SuperfluidFrameworkDeployer.Framework memory) {
        return sf;
    }

    function getTokens() external returns (TestToken underlyingToken, SuperToken superToken) {
        (token, superToken) = superTokenDeployer.deployWrapperSuperToken(
            "FTT",
            "FTT",
            18,
            type(uint256).max
        );

        return (token, superToken);
    }
}
