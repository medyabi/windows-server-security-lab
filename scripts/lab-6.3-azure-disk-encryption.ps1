# Lab 6.3: Encrypting Azure VM disks
# Snippets copied from labs/06-storage-encryption/lab-6.3-azure-disk-encryption.md
# Run them ONE BY ONE, on the machine named in the comment above each block. Do not run this file as a whole.
# Lab environment only: never run on production systems.

# Prefer PowerShell? Here's the same thing:
# Replace YOUR-VAULT-NAME with the name of the Key Vault you created.
$kv  = Get-AzKeyVault -VaultName 'YOUR-VAULT-NAME' -ResourceGroupName az801-rg
$key = Get-AzKeyVaultKey -VaultName $kv.VaultName -Name ade-key
Set-AzVMDiskEncryptionExtension -ResourceGroupName az801-rg -VMName win1 -DiskEncryptionKeyVaultUrl $kv.VaultUri -DiskEncryptionKeyVaultId $kv.ResourceId -KeyEncryptionKeyUrl $key.Id -KeyEncryptionKeyVaultId $kv.ResourceId -VolumeType All

# Let's check:
Get-AzVMDiskEncryptionStatus -ResourceGroupName az801-rg -VMName win1
