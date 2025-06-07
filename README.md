# [WAVS](https://docs.wavs.xyz/) + EigenLayer Examples

This repository contains examples demonstrating the integration of WAVS (WebAssembly Actively Validated Services) with EigenLayer.

## Overview

The examples showcase how to build and deploy AVSs (Actively Validated Services) using WebAssembly and integrate them with the EigenLayer protocol.

## Prerequisites

- Rust and Cargo installed
- Node.js and npm installed
- Docker installed 
- Foundry for Solidity development

## Getting Started

1. **Clone the repository:**

   ```bash
   git clone https://github.com/samuelrojoalvarez/wavs_Apps.git
   cd wavs-eigenlayer-examples

## ETH Price Oracle
The ETH Price Oracle is a simple oracle service that fetches the current price of Ethereum from [CoinMarketCap](https://coinmarketcap.com/) and saves it on chain.

## Sports Scores Oracle
The Sports Scores Oracle is a simple oracle service that fetches the current scores of basketball games from [SportRadar](https://sportradar.com/) and saves it on chain.

> Prompt to recreate this component available [here](https://gist.github.com/samuelrojoalvarez/de38e6cbbe56da081d98f1cb3c97fbe2).

## OpenAI Inference
The OpenAI Inference is a simple oracle service that fetches the current inference of [OpenAI](https://openai.com/) from OpenAI and saves it on chain.

> Prompt to recreate this component available [here](https://gist.github.com/samuelrojoalvarez/4c3683f97a6e86a33cd47a545f3eaa6c).

## System Requirements

<details>
  <summary>Core (Docker, Compose, Make, JQ, Node v21+)</summary>
  
  Details about Core requirements here.
</details>

<details>
  <summary>Rust v1.84+</summary>
  
  Details about Rust version here.
</details>

<details>
  <summary>Cargo Components</summary>
  
  Details about Cargo Components here.
</details>

## Create Project

   ```bash
   # If you don't have foundry: `curl -L https://foundry.paradigm.xyz | bash && $HOME/.foundry/bin/foundryup`
   forge init --template Lay3rLabs/wavs-foundry-template my-wavs --branch 0.3
   ```
> [!TIP]
Run `make help` to see all available commands and environment variable overrides.


## Solidity

Install the required packages to build the Solidity contracts. This project supports both submodules and [npm packages](https://github.com/samuelrojoalvarez/wavs_Apps/blob/main/package.json).
   ```bash
   # Install packages (npm & submodules)
   make setup
   
   # Build the contracts
   forge build
   
   # Run the solidity tests
   forge test
   ```
## Build WASI components
Now build the WASI rust components into the `compiled` output directory.

> [!WARNING]  
>
> If you get: `error: no registry configured for namespace "wavs"`
>
> run, `wkg config --default-registry wa.dev`

> [!WARNING]  
>
> If you get: `failed to find the 'wasm32-wasip1' target and 'rustup' is not available`

>
> `brew uninstall rust` & install it from [https://rustup.rs/](https://rustup.rs/)
   ```bash
   make wasi-build # or `make build` to include solidity compilation.
   ```
## Execute WASI component directly

Test run the component locally to validate the business logic works. Nothing will be saved on-chain, just the output of the component is shown.
## ETH Price Oracle
An ID of 1 is Bitcoin.
   ```bash
   COIN_MARKET_CAP_ID=1 make wasi-exec
   ```
## Sports Scores Oracle
Fetch basketball scores from SportRadar API.
   ```bash
   # Replace with your actual API key in the Makefile
   # SPORTRADAR_API_KEY=your_api_key_here
   
   # Call with a game ID
   make scores-exec GAME_ID="fa15684d-0966-46e7-a3f8-f1d378692109"
   ```
## WAVS

> [!NOTE]  
> If you are running on a Mac with an ARM chip, you will need to do the following:
> ·Set up Rosetta: softwareupdate --install-rosetta
> ·Enable Rosetta (Docker Desktop: Settings -> General -> enable "Use Rosetta for x86_64/amd64 emulation on Apple Silicon")
> Configure one of the following networking:
> ·Docker Desktop: Settings -> Resources -> Network -> 'Enable Host Networking'
> ·`brew install chipmk/tap/docker-mac-net-connect && sudo brew services start chipmk/tap/docker-mac-net-connect`

## Start Environment
Start an ethereum node (anvil), the WAVS service, and deploy [eigenlayer](https://www.eigenlayer.xyz/) contracts to the local network.
   ```bash
   cp .env.example .env
   
   # Start the backend
   #
   # This must remain running in your terminal. Use another terminal to run other commands.
   # You can stop the services with `ctrl+c`. Some MacOS terminals require pressing it twice.
   make start-all
   ```
## Deploy Contract
Upload your service's trigger and submission contracts. The trigger contract is where WAVS will watch for events, and the submission contract is where the AVS service operator will submit the result on chain.
   ```bash
   export SERVICE_MANAGER_ADDR=`make get-eigen-service-manager-from-deploy`
   forge script ./script/Deploy.s.sol ${SERVICE_MANAGER_ADDR} --sig "run(string)" --rpc-url http://localhost:8545 --broadcast
   ```
> [!TIP] 
> You can see the deployed trigger address with make get-trigger-from-deploy and the deployed submission address with make get-service-handler-from-deploy

## Deploy Service

Deploy the compiled component with the contracts from the previous steps. Review the [makefile](https://github.com/samuelrojoalvarez/wavs_Apps/blob/main/Makefile) for more details and configuration options.TRIGGER_EVENT is the event that the trigger contract emits and WAVS watches for. By altering SERVICE_TRIGGER_ADDR you can watch events for contracts others have deployed.

   ```bash
   TRIGGER_EVENT="NewTrigger(bytes)" make deploy-service
   ```

## Trigger the Service

Anyone can now call the [trigger contract](https://github.com/samuelrojoalvarez/wavs_Apps/blob/main/src/contracts/WavsTrigger.sol) which emits the trigger event WAVS is watching for from the previous step. WAVS then calls the service and saves the result on-chain.
   ```bash
   export COIN_MARKET_CAP_ID=1
   export SERVICE_TRIGGER_ADDR=`make get-trigger-from-deploy`
   forge script ./script/Trigger.s.sol ${SERVICE_TRIGGER_ADDR} ${COIN_MARKET_CAP_ID} --sig "run(string,string)" --rpc-url http://localhost:8545 --broadcast -v 4
   ```
## Show the result
Query the latest submission contract id from the previous request made.
   ```bash
   # Get the latest TriggerId and show the result via `script/ShowResult.s.sol`
   make show-result
   ```

