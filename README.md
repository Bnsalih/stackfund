# StackFund Smart Contract

StackFund is a Clarity smart contract for the Stacks blockchain, designed to manage decentralized crowdfunding campaigns. Contributors can fund projects, and refunds are available if campaign goals are not met.

## Features

- Accepts STX contributions from users
- Tracks individual contributions
- Allows campaign owner to withdraw funds if the goal is reached
- Supports contributor refunds if the campaign fails
- Secure and transparent logic using Clarity

## Getting Started

### Prerequisites

- [Clarinet](https://docs.hiro.so/clarinet/get-started) for local development and testing
- Stacks blockchain testnet or mainnet

### Installation

Clone the repository:

```
git clone https://github.com/your-username/stackfund.git
cd stackfund
```

### Usage

1. **Compile the contract:**
   ```
   clarinet compile
   ```

2. **Test the contract:**
   ```
   clarinet test
   ```

3. **Deploy to Stacks:**
   Follow [Stacks deployment instructions](https://docs.stacks.co/docs/smart-contracts/deploy-smart-contracts).

### Contract Functions

- `contribute(amount)`  
  Contribute STX to the campaign.

- `refund()`  
  Request a refund if the campaign did not reach its goal.

- `withdraw()`  
  Campaign owner withdraws funds if the goal is met.

## File Structure

- `contracts/stackfund.clar` — Main smart contract
- `tests/` — Unit tests for contract logic
- `.gitattributes` — Git configuration

## License

MIT

## Authors

- [Your Name](https://github.com/your-username)

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.
