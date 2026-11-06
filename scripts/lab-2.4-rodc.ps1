# Lab 2.4: Read-only domain controller (RODC)
# Snippets copied from labs/02-hybrid-ad-accounts/lab-2.4-rodc.md
# Run them ONE BY ONE, on the machine named in the comment above each block. Do not run this file as a whole.
# Lab environment only: never run on production systems.

# On SEA-SVR2, install the role:
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# The PowerShell version, in one line:
Install-ADDSDomainController -DomainName contoso.com -ReadOnlyReplica -SiteName Default-First-Site-Name -InstallDns
