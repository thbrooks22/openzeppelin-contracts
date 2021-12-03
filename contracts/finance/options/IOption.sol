// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.0 (finance/options/IOption.sol)

pragma solidity ^0.8.0;

interface IOption {

    function holder() external view returns (address);

    function issuer() external view returns (address);

    function strikeType() external view;

    function strikeValue() external view;

    // NOT DONE
}