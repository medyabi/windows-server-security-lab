# Lab 6.1: BitLocker with recovery keys in Active Directory
# Snippets copied from labs/06-storage-encryption/lab-6.1-bitlocker-ad-recovery.md
# Run them ONE BY ONE, on the machine named in the comment above each block. Do not run this file as a whole.
# Lab environment only: never run on production systems.

# To see the recovery keys in ADUC, add the BitLocker viewer on SEA-DC1:
Install-WindowsFeature RSAT-Feature-Tools-BitLocker-BdeAducExt

# Now install BitLocker on SEA-SVR1:
Install-WindowsFeature BitLocker -IncludeAllSubFeature -IncludeManagementTools -Restart

# The server reboots. Apply the GPO with gpupdate /force, then turn on BitLocker:
Enable-BitLocker -MountPoint C: -EncryptionMethod XtsAes256 -UsedSpaceOnly -TpmProtector
Add-BitLockerKeyProtector -MountPoint C: -RecoveryPasswordProtector

# Let's check:
manage-bde -status C:
