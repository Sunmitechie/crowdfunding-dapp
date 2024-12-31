import {
  Clarinet,
  Tx,
  Chain,
  Account,
} from "https://deno.land/x/clarinet@v1.0.1/index.ts";

Clarinet.test({
  name: "Test project creation",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    let deployer = accounts.get("deployer")!;

    // Create a project
    let block = chain.mineBlock([
      Tx.contractCall(
        "crowdfunding",
        "create-project",
        ["u5000", "u1000"],
        deployer.address
      ),
    ]);

    block.receipts[0].result.expectOk().expectTuple();
  },
});

Clarinet.test({
  name: "Test pledging funds",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    let wallet1 = accounts.get("wallet_1")!;

    // Pledge funds
    let block = chain.mineBlock([
      Tx.contractCall(
        "crowdfunding",
        "pledge-funds",
        ["u1", "u500"],
        wallet1.address
      ),
    ]);

    block.receipts[0].result.expectOk().expectTuple();
  },
});

Clarinet.test({
  name: "Test withdrawing funds",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    let deployer = accounts.get("deployer")!;

    // Withdraw funds
    let block = chain.mineBlock([
      Tx.contractCall(
        "crowdfunding",
        "withdraw-funds",
        ["u1"],
        deployer.address
      ),
    ]);

    block.receipts[0].result.expectOk().expectTuple();
  },
});

Clarinet.test({
  name: "Test refunding pledge",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    let wallet1 = accounts.get("wallet_1")!;

    // Refund pledge
    let block = chain.mineBlock([
      Tx.contractCall(
        "crowdfunding",
        "refund-pledge",
        ["u1"],
        wallet1.address
      ),
    ]);

    block.receipts[0].result.expectOk().expectTuple();
  },
});
