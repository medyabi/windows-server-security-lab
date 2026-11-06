# Chapter 6: Securing Windows Server storage

[← All chapters](../../README.md)

Everything we've done so far protects a **running** server. But what if someone just takes the disk? Encryption protects **data at rest**. Without the key, a stolen disk is just random noise.

The tricky part isn't turning encryption on. It's making sure **you** never lose the key.

## Labs

| Lab | Attack | Control |
|---|---|---|
| [6.1 BitLocker with recovery keys in Active Directory](lab-6.1-bitlocker-ad-recovery.md) | Stolen disk or copied VHDX | BitLocker with recovery keys stored in Active Directory |
| [6.2 Forcing BitLocker recovery](lab-6.2-bitlocker-forced-recovery.md) | Lost recovery key (availability) | Forced-recovery drill and key rotation |
| [6.3 Encrypting Azure VM disks](lab-6.3-azure-disk-encryption.md) | Azure disk export by a rogue Contributor | Azure Disk Encryption, customer-managed keys |
