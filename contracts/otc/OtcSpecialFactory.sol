// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./OtcTokenSpecial.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OtcTokenSpecialFactory is Ownable {
    struct DeployedToken {
        address admin;
        address token;
        uint256 time;
        string name;
        string symbol;
    }
    address[] public deployedTokens;
    mapping(address => DeployedToken) public deployedTokensData;
    event Created(address indexed to);

    function createToken(
        string memory name,
        string memory symbol,
        address admin
    ) external onlyOwner returns (address) {
        OTCTokenSpecial newToken = new OTCTokenSpecial(admin, name, symbol);
        deployedTokens.push(address(newToken));
        deployedTokensData[address(newToken)] = DeployedToken({
            admin: admin,
            token: address(newToken),
            time: block.timestamp,
            name: name,
            symbol: symbol
        });

        emit Created(address(newToken));
        return address(newToken);
    }

    function getDeployedTokens() external view returns (address[] memory) {
        return deployedTokens;
    }
}
