# Gielinorian Game Contracts

Gielinorian is a Runescape private server that is focused on emulating the game experience of the original game. The game will be enhanced with new technologies such as a Blockchain integration.

## Overview

Gielinorian is designed to merge the excitement of gaming with the innovative aspects of NFTs and decentralized finance. We're building a vast ecosystem where players can:

- **Register and Transfer Usernames**: Unique digital identities that are minted as NFTs, allowing players to own and trade their in-game personas.

- **Upgradable NFTs**: Engage with a variety of NFTs—pets, rare items, cosmetics, and avatars with stats—that players can upgrade and personalize.

- **Plot-Based Show-off**: A web-based 3D plot for players to display their achievements and rare NFTs.

- **World-Based Accounts**: Introduce an economic system with multi-signature accounts for servers, including vaults, a Grand Exchange with a tax system, and a player-driven economy.

- **Ingame Economy Monitoring**: Keep track of the ingame economy to ensure balance and fairness.

- **Player-Owned Wallets**: Ensure players have full control over their in-game assets by integrating player-owned wallets.

- **Player Achievements**: Reward players with NFTs for achievements in different worlds, fostering a sense of accomplishment and uniqueness.

- **Community Voting**: Empower the community to shape the game world, including server customizations and economic decisions, through tokenized in-game coins.

## How It Works

- **Creating Worlds**: Players can create game worlds, each associated with a unique NFT representing the server's keypair and metadata. Community governance models enable voting on world customizations and server expenses.

- **Minting Usernames and Trading Cards**: Upon registration, players receive a minted NFT for their username and a trading card, which can be claimed with a private wallet. These assets are tradable, emphasizing ownership and trade within the ecosystem.

- **Achievements and Rewards**: Achievements unlock NFT rewards, which players can showcase on their personal 3D plot and use in various in-game mechanics.

- **Economic Integration**: The Grand Exchange operates on the blockchain, allowing for secure in-game item trades. Account trading also integrates real-money transactions, with a portion of proceeds supporting the platform through royalties and taxes.

## Vision

Our vision is to create an immersive gaming experience that bridges the gap between traditional online gaming and blockchain technology. By empowering players with ownership of their digital assets and achievements, we aim to foster a vibrant, self-sustaining community where every action and achievement has real-world value.

## Getting Started

### Intall Pact

For more inforamation on the installation of Pact, it can be found [here](https://github.com/kadena-io/pact?tab=readme-ov-file#installing-pact).

### Running Tests

In Pact there are repl files that emulate the onchain transactions and makes it possible to test all the functions within the contracts.

1. Load the pact repl:
```
pact
```
2. Load the init repl file that setup the environment and run all the tests
```
(load "./gielinorian/tests/init.repl")
```
