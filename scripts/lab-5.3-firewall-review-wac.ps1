# Lab 5.3: Firewall review with Windows Admin Center
# Snippets copied from labs/05-networking/lab-5.3-firewall-review-wac.md
# Run them ONE BY ONE, on the machine named in the comment above each block. Do not run this file as a whole.
# Lab environment only: never run on production systems.

# First, let's plant a "malicious" rule on SEA-SVR1, so we have something to find:
New-NetFirewallRule -DisplayName "Windows Update Helper" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 4444

# Let's confirm on the server:
Get-NetFirewallRule -DisplayName "Windows Update Helper" | Select DisplayName, Enabled
