// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.0 (finance/escrow/Escrow.sol)

pragma solidity ^0.8.0;

import "../../utils/Context.sol";

abstract contract Escrow is Context {
    enum PartyEnum {Buyer, Seller}

    bool private _settled;
    address private _buyer;
    address private _seller;

    modifier requireCondition(bool b) {
        require(
            b,
            "Unauthorized action."
        );
        _;
    }

    modifier registerBuyer (address addr) {
        if (addr == address(0)) {
            require(_buyer != address(0), "Unauthorized action.");
        } else {
            require(_buyer == address(0) || addr == _buyer, "Unauthorized action.");
        }
        _buyer = addr;
        _;
    }

    modifier registerSeller (address addr) {
        if (addr == address(0)) {
            require(_seller != address(0), "Unauthorized action.");
        } else {
            require(_seller == address(0) || addr == _seller, "Unauthorized action.");
        }
        _seller = addr;
        _;
    }

    constructor(PartyEnum senderParty) {
        if (senderParty == PartyEnum.Buyer) {
            _buyer = _msgSender();
        } else {
            _seller = _msgSender();
        }
    }

    function settled() public view returns (bool) {
        return _settled;
    }
    
    function buyer() public view returns (address) {
        return _buyer;
    }

    function seller() public view returns (address) {
        return _seller;
    }

    function settleConditionsMet() virtual public view returns (bool);

    function buyerEnter() virtual public requireCondition(!settled()) registerBuyer(_msgSender()) {}

    function buyerWithdraw() virtual public requireCondition(_msgSender() == buyer() && !settled()) registerBuyer(address(0)) {}

    function sellerEnter() virtual public requireCondition(!settled()) registerSeller(_msgSender()) {}

    function sellerWithdraw() virtual public requireCondition(_msgSender() == seller() && !settled()) registerSeller(address(0)) {}

    function settle() virtual public requireCondition(!settled() && settleConditionsMet()) {
        _settled = true;
    }
}