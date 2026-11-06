# Lab 6.2: Forcing BitLocker recovery
# Snippets copied from labs/06-storage-encryption/lab-6.2-bitlocker-forced-recovery.md
# Run them ONE BY ONE, on the machine named in the comment above each block. Do not run this file as a whole.
# Lab environment only: never run on production systems.

# Take a checkpoint of SEA-SVR1 first. Seriously. Now let's force recovery:
manage-bde -forcerecovery C:
Restart-Computer -Force

# Now rotate the key, because this one has been seen:
manage-bde -protectors -get C:
manage-bde -protectors -add C: -RecoveryPassword
manage-bde -protectors -delete C: -id "{old-protector-id}"
