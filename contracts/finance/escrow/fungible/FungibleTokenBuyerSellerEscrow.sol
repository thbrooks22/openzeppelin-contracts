// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.0 (finance/escrow/FungibleTokenBuyerSellerEscrow.sol)

pragma solidity ^0.8.0;

import "./FungibleTokenBuyerEscrow.sol";

abstract contract FungibleTokenBuyerSellerEscrow is FungibleTokenBuyerEscrow {

    constructor(PartyEnum party) FungibleTokenBuyerEscrow(party) {}

    function sellerEnterAmount(uint amount) virtual public requireCondition(!settled()) registerSeller(_msgSender()) {}

    function sellerWithdrawAmount(uint amount) virtual public requireCondition(_msgSender() == seller() && !settled()) {}
}