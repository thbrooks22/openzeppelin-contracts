// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.0 (finance/escrow/FixedRateERC20Escrow.sol)

pragma solidity ^0.8.0;

import "./ERC20Escrow.sol";
import "../../token/ERC20/ERC20.sol";

contract FixedRateERC20Escrow is ERC20Escrow {
    uint _purchasingTokenAmount;
    uint _purchasedTokenAmount;

    modifier doSettle {
        _;
        this.settle();
    }
    
    constructor (PartyEnum party, address purchasingToken, address purchasedToken, uint purchasingTokenAmount, uint purchasedTokenAmount) 
            ERC20Escrow(party, purchasingToken, purchasedToken) {
        
        _purchasingTokenAmount = purchasingTokenAmount;
        _purchasedTokenAmount = purchasedTokenAmount;
    }

    function purchasingTokenAmount() external view returns (uint) {
        return _purchasingTokenAmount;
    }

    function purchasedTokenAmount() external view returns (uint) {
        return _purchasedTokenAmount;
    }


    function settleConditionsMet() override public view returns (bool) {
        bool sellerConditionMet = this.purchasedToken().balanceOf(address(this)) >= _purchasedTokenAmount;
        bool buyerConditionsMet = this.purchasingToken().balanceOf(address(this)) >= _purchasingTokenAmount;
        return sellerConditionMet && buyerConditionsMet;
    }

    function buyerWithdraw() override public {
        super.buyerWithdraw();
        this.purchasingToken().transfer(buyer(), this.purchasingToken().balanceOf(address(this)));
    }

    function buyerWithdrawAmount(uint amount) override public {
        uint entered = this.purchasingToken().balanceOf(address(this));

        if (amount >= entered) {
            this.buyerWithdraw();
        } else {
            super.buyerWithdrawAmount(amount);
            this.purchasingToken().transfer(buyer(), amount);
        }
    }

    function sellerWithdraw() override public {
        super.sellerWithdraw();
        this.purchasedToken().transfer(seller(), this.purchasedToken().balanceOf(address(this)));
    }

    function sellerWithdrawAmount(uint amount) override public {
        uint entered = this.purchasedToken().balanceOf(address(this));

        if (amount >= entered) {
            this.sellerWithdraw();
        } else {
            super.sellerWithdrawAmount(amount);
            this.purchasedToken().transfer(seller(), amount);
        }
    }

    function buyerEnter() override public {
        uint alreadyEntered = this.purchasingToken().balanceOf(address(this));
        require(
            alreadyEntered < _purchasingTokenAmount,
            "Already entered full amount."
        );
        this.buyerEnterAmount(_purchasingTokenAmount - alreadyEntered);
    }

    function buyerEnterAmount(uint amount) override public doSettle {
        super.buyerEnterAmount(amount);
        uint alreadyEntered = this.purchasingToken().balanceOf(address(this));
        require(
            alreadyEntered < _purchasingTokenAmount,
            "Already entered full amount."
        );
        require(
            this.purchasingToken().transferFrom(buyer(), address(this), amount),
            "Not enough allowance."
        );
    }

    function sellerEnter() override public {
        uint alreadyEntered = this.purchasedToken().balanceOf(address(this));
        require(
            alreadyEntered < _purchasedTokenAmount,
            "Already entered full amount."
        );
        this.sellerEnterAmount(_purchasedTokenAmount - alreadyEntered);
    }

    function sellerEnterAmount(uint amount) override public doSettle {
        super.sellerEnterAmount(amount);
        uint alreadyEntered = this.purchasedToken().balanceOf(address(this));
        require(
            alreadyEntered < _purchasedTokenAmount,
            "Already entered full amount."
        );
        require(
            this.purchasedToken().transferFrom(seller(), address(this), amount),
            "Not enough allowance."
        );
    }

    function settle() override public {
        super.settle();

        this.purchasingToken().transfer(seller(), _purchasingTokenAmount);
        uint purchasingTokenRemaining = this.purchasingToken().balanceOf(address(this));
        if (purchasingTokenRemaining > 0) {
            this.purchasingToken().transfer(buyer(), purchasingTokenRemaining);
        }

        this.purchasedToken().transfer(buyer(), _purchasedTokenAmount);
        uint purchasedTokenRemaining = this.purchasedToken().balanceOf(address(this));
        if (purchasedTokenRemaining > 0) {
            this.purchasedToken().transfer(seller(), purchasedTokenRemaining);
        }
    }
}