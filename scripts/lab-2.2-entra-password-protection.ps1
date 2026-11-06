# Lab 2.2: Microsoft Entra Password Protection
# Snippets copied from labs/02-hybrid-ad-accounts/lab-2.2-entra-password-protection.md
# Run them ONE BY ONE, on the machine named in the comment above each block. Do not run this file as a whole.
# Lab environment only: never run on production systems.

# On SEA-SVR1 (a member server, never a DC), install the Proxy and register it:
Import-Module AzureADPasswordProtection
Register-AzureADPasswordProtectionProxy -AccountUpn admin@yourtenant.onmicrosoft.com
Register-AzureADPasswordProtectionForest -AccountUpn admin@yourtenant.onmicrosoft.com
