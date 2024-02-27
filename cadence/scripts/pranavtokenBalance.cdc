import FungibleToken from 0x05
import pranavtoken from 0x05

pub fun main(account: Address) {

    // Attempt to borrow PublicVault capability
    let publicVault: &pranavtoken.Vault{FungibleToken.Balance, FungibleToken.Receiver, pranavtoken.CollectionPublic}? =
        getAccount(account).getCapability(/public/Vault)
            .borrow<&pranavtoken.Vault{FungibleToken.Balance, FungibleToken.Receiver, pranavtoken.CollectionPublic}>()

    if (publicVault == nil) {
        // Create and link an empty vault if capability is not present
        let newVault <- pranavtoken.createEmptyVault()
        getAuthAccount(account).save(<-newVault, to: /storage/VaultStorage)
        getAuthAccount(account).link<&pranavtoken.Vault{FungibleToken.Balance, FungibleToken.Receiver, pranavtoken.CollectionPublic}>(
            /public/Vault,
            target: /storage/VaultStorage
        )
        log("Empty vault created")
        
        // Borrow the vault capability again to display its balance
        let retrievedVault: &pranavtoken.Vault{FungibleToken.Balance}? =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&pranavtoken.Vault{FungibleToken.Balance}>()
        log(retrievedVault?.balance)
    } else {
        log("Vault already exists and is properly linked")
        
        // Borrow the vault capability for further checks
        let checkVault: &pranavtoken.Vault{FungibleToken.Balance, FungibleToken.Receiver, pranavtoken.CollectionPublic} =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&pranavtoken.Vault{FungibleToken.Balance, FungibleToken.Receiver, pranavtoken.CollectionPublic}>()
                ?? panic("Vault capability not found")
        
        // Check if the vault's UUID is in the list of vaults
        if pranavtoken.vaults.contains(checkVault.uuid) {
            log(publicVault?.balance)
            log("This is a pranavtoken vault")
        } else {
            log("This is not a pranavtoken vault")
        }
    }
}