// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.0 (finance/escrow/FungibleTokenBuyerEscrow.sol)

pragma solidity ^0.8.0;

import "../Escrow.sol";

abstract contract FungibleTokenBuyerEscrow is Escrow {

    constructor(PartyEnum party) Escrow(party) {}

    function buyerEnterAmount(uint amount) virtual public requireCondition(!settled()) registerBuyer(_msgSender()) {}

    function buyerWithdrawAmount(uint amount) virtual public requireCondition(_msgSender() == buyer() && !settled()) {}
}