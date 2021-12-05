// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.0 (finance/escrow/ERC20Escrow.sol)

pragma solidity ^0.8.0;

import "./fungible/FungibleTokenBuyerSellerEscrow.sol";
import "../../token/ERC20/ERC20.sol";

abstract contract ERC20Escrow is FungibleTokenBuyerSellerEscrow {

    ERC20 private _purchasingToken;
    ERC20 private _purchasedToken;
    
    constructor (PartyEnum party, address purchasingToken, address purchasedToken) FungibleTokenBuyerSellerEscrow(party) {
        _purchasingToken = ERC20(purchasingToken);
        _purchasedToken = ERC20(purchasedToken);
    }

    function purchasingToken() external view returns (ERC20) {
        return _purchasingToken;
    }

    function purchasedToken() external view returns (ERC20) {
        return _purchasedToken;
    }
}