// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./extensions/ERC20X.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./extensions/ERC20Permit.sol";

contract OTCTokenSpecial is ERC20X, Pausable, AccessControl, ERC20XPermit {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant TRANSFER_ROLE = keccak256("TRANSFER_ROLE");

    // solhint-disable-next-line var-name-mixedcase
    bytes32 private constant _PERMIT_TYPEHASH =
        keccak256(
            "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
        );

    event Minted(address indexed to, uint256 amount);
    event Burned(address indexed from, uint256 amount);
    event TimestampSynced(address indexed caller, uint256 timestamp);

    constructor(
        address admin,
        string memory name,
        string memory symbol
    ) ERC20X(name, symbol) ERC20XPermit(name) {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(PAUSER_ROLE, admin);
        _grantRole(MINTER_ROLE, admin);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
        emit Minted(to, amount);
    }

    function mintWithPermit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public {
        require(block.timestamp <= deadline, "ERC20Permit: expired deadline");

        bytes32 structHash = keccak256(
            abi.encode(
                _PERMIT_TYPEHASH,
                owner,
                spender,
                value,
                _useNonce(owner),
                deadline
            )
        );

        bytes32 hash = _hashTypedDataV4(structHash);
        address signer = ECDSA.recover(hash, v, r, s);
        require(signer == owner, "ERC20Permit: invalid signature");
        require(spender == msg.sender, "sender should be the approved user");

        _checkRole(MINTER_ROLE, signer);
        _mint(spender, value);
        emit Minted(spender, value);
    }

    function burn(uint256 amount) public onlyRole(MINTER_ROLE) {
        _burn(_msgSender(), amount);
        emit Burned(_msgSender(), amount);
    }

    function syncTimestamp(uint256 _timestamp) public onlyRole(MINTER_ROLE) {
        _syncTimestamp(_timestamp);
        emit TimestampSynced(msg.sender, _timestamp);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override onlyRole(TRANSFER_ROLE) {
        super._transfer(from, to, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);

        require(!paused(), "ERC20Pausable: token transfer while paused");
    }
}
