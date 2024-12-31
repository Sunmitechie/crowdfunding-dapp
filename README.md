# Decentralized Crowdfunding Platform

This project is a decentralized crowdfunding system built on the Stacks blockchain using Clarity smart contracts. It allows project creators to raise funds transparently while enabling contributors to support projects securely.

---

## Features
1. Project Creation: Anyone can create a project with a funding goal and a deadline.
2. Pledge Funds: Contributors can pledge STX tokens to support projects.
3. Secure Withdrawals: Funds are released only if the project meets its goal by the deadline.
4. Transparency: All transactions and project data are stored immutably on the blockchain.
5. Test Suite: Fully tested with `Clarinet`.

---

## Contract Functions
### 1. `create-project`
   - Creates a new crowdfunding project.
   - Parameters:
     - `goal (uint)`: The funding goal in STX.
     - `deadline (uint)`: The block height by which the goal must be met.
   - Returns:
     - A success message with the `project-id`.

### 2. `pledge-funds`
   - Pledge funds to a project.
   - Parameters:
     - `project-id (uint)`: ID of the project.
     - `amount (uint)`: Amount of STX to pledge.
   - Returns:
     - A success message with the pledged amount.

### 3. `withdraw-funds`
   - Withdraw funds if the project goal is met.
   - Parameters:
     - `project-id (uint)`: ID of the project.
   - Returns:
     - A success message upon successful withdrawal.
