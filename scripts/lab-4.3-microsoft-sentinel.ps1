# Lab 4.3: Microsoft Sentinel
# Snippets copied from labs/04-watching-from-azure/lab-4.3-microsoft-sentinel.md
# Run them ONE BY ONE, on the machine named in the comment above each block. Do not run this file as a whole.
# Lab environment only: never run on production systems.

# Time to test. On SEA-SVR1:
New-LocalUser -Name backdoor -NoPassword
Add-LocalGroupMember Administrators -Member backdoor
