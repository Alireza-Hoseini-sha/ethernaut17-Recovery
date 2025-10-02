## Ethernaut: Recovery (Level 17)

### Goal

Recover (or remove) the 0.001 ETH that was sent to a "lost" token contract deployed by a factory.

### TL;DR Solution

- The factory (`Recovery`) deploys `SimpleToken` via a regular CREATE and never stores the address.
- The `SimpleToken` has a public `destroy(address)` that anyone can call. Calling it self-destructs the token and forwards its entire ETH balance to the provided address.
- Once you learn or derive the lost token address, call `destroy(<your-EOA>)`.

### Addresses

```
Instance: 0xCf7084cA063B088DA505Ea6C70DaD460B88a544A
Level:    0x71ADA81382C62BB1D5CC194c2BD836Eee34AffF5
Lost token (from Arbiscan): 0xC31d24E5D7805Eb0EB95EaA21CaDa6905E9E52bc
```

### Why this works

- `SimpleToken` implements:
  - `receive()` to accept ETH
  - `destroy(address)` which executes `selfdestruct(_to)` with no access control
- Anyone can therefore reclaim ETH from the token by calling `destroy` and specifying their own address.

### Run the solution script (Foundry)

Pre-reqs:

- Foundry installed (`forge --version`)
- RPC URL and a funded private key for the target network (the lost token address was found via Arbiscan; use the matching network RPC)

Commands:

```bash
# Set environment (example)
export RPC_URL="<your_rpc_url>"
export PRIVATE_KEY="<your_private_key>"

# Dry-run
forge script script/Solve.s.sol \
  --rpc-url "$RPC_URL" \
  --private-key "$PRIVATE_KEY" \
  -vvvv

# Broadcast the transaction
forge script script/Solve.s.sol \
  --rpc-url "$RPC_URL" \
  --private-key "$PRIVATE_KEY" \
  --broadcast -vvvv
```

The script calls `destroy(msg.sender)` on the lost token and logs the token balance afterwards.

### Verifying completion

- Check the transaction on the block explorer to confirm the `SELFDESTRUCT` and that 0.001 ETH was transferred to your account.
- Submit the transaction hash in Ethernaut to complete the level.

### Optional: Deriving the lost address

Even without the explorer, the token address can be recovered because it was deployed with CREATE. The contract address is a deterministic function of `(deployer, nonce)`. Once the correct nonce is known, you can compute the same address locally.

### Screenshot

![Recovered via selfdestruct](Screenshot.png)
