import FungibleToken from 0x05
import pranavtoken from 0x05

transaction() {

    // Define references
    let userVault: &pranavtoken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, pranavtoken.CollectionPublic}?
    let account: AuthAccount

    prepare(acct: AuthAccount) {

        // Borrow vault capability and set account reference
        self.userVault = acct.getCapability(/public/Vault)
            .borrow<&pranavtoken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, pranavtoken.CollectionPublic}>()

        self.account = acct
    }

    execute {
        if self.userVault == nil {
            // Create and link an empty vault if none exists
            let emptyVault <- pranavtoken.createEmptyVault()
            self.account.save(<-emptyVault, to: /storage/VaultStorage)
            self.account.link<&pranavtoken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, pranavtoken.CollectionPublic}>(/public/Vault, target: /storage/VaultStorage)
            log("Empty vault created and linked")
        } else {
            log("Vault already exists and is properly linked")
        }
    }
}