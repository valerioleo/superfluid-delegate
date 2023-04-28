// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;

import '@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol';

contract ERC20Token is ERC20PresetMinterPauser {
  constructor(
    string memory name,
    string memory symbol,
    uint256 initialSupply,
    address owner
  ) ERC20PresetMinterPauser(name, symbol) { }

  function mint(address to, uint256 amount) public override {
    _mint(to, amount);
  }
}