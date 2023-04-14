# Pinkwhale smart contracts 🐳

## Run tests
You can run thest by `yarn test`. Don't forget to do `yarn install` first!

## Pinkwhale Protocol

tl;dr

Pinkwhale is a NFT lending protocol built upon Seaport protocol. 

Pinkwhale creates Loans by accepting valid Seaport orders that specify Pinkwhale address as the recipient of the token to collateralise. Upon receiving the orders, Pinkwhale contract attempts matching them on Seaport and, if successful, creates two Seaport orders on-chain to cover both outcomes of a Loan:

- Repayment Order: an order for the Borrower to ‘buy back’ its collateralised token at the price of capital borrowed + interest, which expires when the Loan expires.
- Default Order: an order for the Lender to buy the token *for free*, which is valid from the moment the Loan expires

---

Pinkwhale is a NFT lending protocol built upon Seaport, an open protocol created by Opensea.

> Seaport is a generalized ETH/ERC20/ERC721/ERC1155 marketplace. [...] Each order contains an arbitrary number of items that may be spent (the "offer") along with an arbitrary number of items that must be received back by the indicated recipients (the "consideration").
> 

Using Seaport makes it possible to:

- Write a Lending Protocol with few hundreds lines code
- Inherit its extreme security
- Offer Loans not only to specific tokens, but also to whole collections, or a list of tokens that share some traits, or even bundles!

Although Seaport was born as a marketplace protocol, Pinkwhale takes advantage of its highly composable design to inherit Seaport’s unbeatable security and make lending possible.

To understand how Pinkwhale allows lending on Seaport, we need to familiarise with some Seaport terms: **consideration recipients**, **zones** and **zone hashes**.

Every Seaport order is composed by one or more **offer items** (what you are trying to sell) and one or more **consideration items** (what you want in exchange).

Each consideration item specifies an arbitrary **recipient** address, which can be the same as the order signer or any other address. By setting Pinkwhale as the recipient we effectively use Pinkwhale as a safe escrow for the collateralised token.

To create a Loan, Pinkwhale takes two valid Seaport orders (one for Lender side and one for Borrower side) that specify Pinkwhale as the `recipient` address of the token to collateralise. Upon receiving such orders, Pinkwhale will attempt matching them on Seaport and, upon success, it will create two new Seaport orders on-chain to cover both outcomes of a Loan:

- **Repayment Order**: an order for the Borrower to ‘buy back’ its collateralised token at the price of capital borrowed + interest, which expires when the Loan expires.
- **Default Order**: an order for the Lender to buy the token *for free*, which is valid from the moment the Loan expires

![image](https://user-images.githubusercontent.com/13155741/194912662-99843400-68d0-4a73-99e1-60598a222747.png)
---

# Order types

## Loan Creation Orders

These Orders are used to *create* a Loan. Besides all the expected Seaport parameters, they must have:

- The `recipient` of the collateralised token set as Pinkwhale address. This allows to receive token and keep it in escrow.
- The `zone` set as Pinkwhale address. This allows Pinkwhale to execute these two Orders.
- The `zoneHash` set as `hash(terms.interest, terms.duration)`. This will prevent Orders creating Loans with terms that were not agreed upon.

## Loan Resolution Orders

The Loan Resolution Orders are of two types: Loan Repayment and Loan Default. This is enough to cover all possible outcomes of a Loan (in fact, a Loan is either *repaid* or *defaulted*). 

Both Orders share these parameters:

- The `zone` is set as Pinkwhale. This makes sure that Seaport will call `isValidOrderIncludingExtraData` function whenever the order is executed (we will see later why)
- The `zoneHash` is set as the hash of
    - `upstreamOrder` → an optional Seaport order hash. If present, Pinkwhale will verify if that Order has been already fulfilled, in which case it will fail the validation of this Order
    - `authorisedCaller` → the expected `msg.sender`
    - `lienTokenAddress` → the address of the collateralised NFT
    - `lienTokenId` → the id of the collateralised NFT
- The `orderType` is set as `FULL_RESTRICTED`, which informs Seaport to call the `isValidOrderIncludingExtraData` on the `zone` (set as Pinkwhale) when someone attempts to execute the Order.
- The `offer` includes one single item: the collateralised token.

Other parameters are also Order-specific. 

For the Repayment Order:

- The `consideration` includes two items:
    - The lender repayment, for an amount of `capital + terms.duration`, with `recipient` address set as the lender address
    - The Pinkwhale fee, for an amount of 2.5% of capital, with `recipient` set as Pinkwhale address
- `startDate` set as the Loan creation timestamp
- `endDate` set as the `startDate` + `terms.duration`

For the Default Order:

- The `consideration` includes no items, making the Order effectively free to fulfil (for the Lender)
- The `upstreamOrder` in `zoneHash` is set as the hash of the Repayment Order.
- `startDate` is set as Loan expiry date + 1 second
- `endDate` is set as `startDate` + `365 days`

The Repayment Order is an Order that is valid from the second the Loan is created until its expiration date (timestamp of creation + `terms.duration`). 

# FAQs

- **How do we guarantee that only the Borrower or the Lender can execute the Repayment and Default Orders?**
    
    When creating the Repayment and Default Orders, we specify the Order `zoneHash` as the hash of:
    
    - `upstreamOrder` → an optional Seaport order hash. If present, Pinkwhale will verify if that Order has been already fulfilled, in which case it will fail the validation of this Order
    - `authorisedCaller` → the expected `msg.sender`
    - `lienTokenAddress` → the address of the collateralised NFT
    - `lienTokenId` → the id of the collateralised NFT
    
    When the Order is being executed, Seaport calls the `.isValidOrderIncludingExtraData` function on Pinkwhale, providing all the info necessary to rebuild the hash. If the hash matches and the `upstreamOrder` has not been executed, we can consider the order valid.
    
- **How do we guarantee that the Orders cannot be replayed?**
    
    Orders cannot be replayed because Seaport invalidates them after first execution.
    
- **Why we need the `upstreamOrderHash`?**
    
    This is important to avoid a Default Order being used if a Loan has been correctly repaid. 
    
    For example, if Alice repays Bob’s Loan correctly, and then she takes another Loan, the previous claim that Bob has is still valid. So, if the Pinkwhale contract has Alice token, Bob’s claim can be successfully fulfilled. 
    
    By setting Alice’s Repayment Order hash as the `upstreamOrderHash` we can verify if that order has been already fulfilled or not.
