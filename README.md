# WAVS + EigenLayer Examples

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
   git clone https://github.com/dabit3/wavs-eigenlayer-examples.git
   cd wavs-eigenlayer-examples


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

## Solidity

Install the required packages to build the Solidity contracts. This project supports both submodules and npm packages.
   ```bash
   # Install packages (npm & submodules)
   make setup
   
   # Build the contracts
   forge build
   
   # Run the solidity tests
   forge test
   ```
## Build WASI components
Now build the WASI rust components into the compiled output directory.

> ⚠ **Warning**
>
> If you get: `error: no registry configured for namespace "wavs"`
>
> run, `wkg config --default-registry wa.dev`

> ⚠ **Warning**
>
> If you get: failed to find the 'wasm32-wasip1' target and 'rustup' is not available

>
> brew uninstall rust & install it from [https://rustup.rs]([url](https://rustup.rs/))
