# Lab 5.2: IPsec connection security rules
# Snippets copied from labs/05-networking/lab-5.2-ipsec-connection-security.md
# Run them ONE BY ONE, on the machine named in the comment above each block. Do not run this file as a whole.
# Lab environment only: never run on production systems.

# Now let's generate some traffic and look at the security associations. From SEA-DC1:
Test-NetConnection SEA-SVR1 -Port 445

# Then on SEA-SVR1:
Get-NetIPsecMainModeSA
Get-NetIPsecQuickModeSA
