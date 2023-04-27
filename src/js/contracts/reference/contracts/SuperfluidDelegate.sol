pragma solidity >= 0.8.0;
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

import {ISuperfluid, ISuperToken, ISuperApp, ISuperAgreement, SuperAppDefinitions} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";

/**
    1. There needs to be a contract that OWNS the NFT that we want to delegate (we call it vault)
    2. The vault MUST be notified when a stream is closed, so to trigger the revokeDelegate function on DelegateCash contract
    3. To open a 
    4. Once the stream is open, the funds are sent to the ESCROW, but either relayed with another stream to the
        OWNER or the ESCROW offers a withdraw() function
*/

contract SupefluidDelegate is Ownable {
  using SuperTokenV1Library for ISuperToken;
  IDelegationRegistry public delegationRegistry;

  constructor(
          ISuperToken _cashToken, // super token to be used
          IDelegationRegistry _delegationRegistry // delegate.cash registry
      ) SuperAppBaseFlow(
          ISuperfluid(_cashToken.getHost()), // this creates the host
          true, 
          true, 
          true
      ) {
          delegationRegistry = _delegationRegistry; // this is the delegate.cash registry

          cashToken = _cashToken; // this is the token that will trigger the hooks
          _acceptedSuperTokens[_cashToken] = true; // needed for the library to work
      }

//   function depositNFTForDelegation(address nftAddress, uint256 tokenId) external {
//     // let's deposit the NFT
//     ERC721(nftAddress).transferFrom(msg.sender, address(this), tokenId);
//   }
  
//   function withdrawNFTFromDelecation(address nftAddress, uint256 tokenId) onlyOwner onlyIfNotDelegated external {
//     // let's deposit the NFT
//     require(
//         !delegationRegistry.getDelegatesForAll(this(address)),
//         'You cannot withdraw a delegated NFT'
//     );
//     ERC721(nftAddress).transferFrom(msg.sender, address(this), tokenId);
//   }

//   function _verifySignature(bytes memory signature) internal view returns (bool) {
//     // to implement
//     return true;
//   }
  
//   function _getDataFromSignature(bytes memory signature) internal view returns (address, uint256) {
//     // to implement
//     return (address(this), 0);
//   }

//    /// @dev super app callback triggered after user sends stream to contract
//     function afterFlowCreated(
//         ISuperToken /*superToken*/,
//         address sender /*sender*/,
//         bytes calldata /*beforeData*/, // -> da ignorare
//         bytes calldata ctx
//     ) internal override returns (bytes memory) {
//         /**
//           1. decode the EIP-721 signatuere from the ctx
//           2. if the conditions are met, send the delegate to the sender address
//          */
//         bytes signature = abi.decode(ISuperfluid(_cashToken.getHost()).decodeCtx(ctx).userData, (bytes));
//         require(_verifySignature(signature), "Invalid signature");

//         (address token, uint256 tokenId) = _getDataFromSignatuere(signature);

//         delegationRegistry.delegateForToken(sender, token, tokenId, true);

//         return bytes(0);
//     }

//     function afterFlowUpdated(
//         ISuperToken /*superToken*/,
//         address /*sender*/,
//         bytes calldata /*beforeData*/,
//         bytes calldata ctx
//     ) internal override returns (bytes memory) {
//         revert();
//     }

//     function afterFlowDeleted(
//         ISuperToken /*superToken*/,
//         address sender,
//         address receiver,
//         bytes calldata beforeData,
//         bytes calldata ctx
//     ) internal override returns (bytes memory) {
        

//         delegationRegistry.revokeAllDelegates();
//     }
}
