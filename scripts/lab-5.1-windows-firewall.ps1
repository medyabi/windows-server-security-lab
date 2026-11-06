# Lab 5.1: Windows Defender Firewall
# Snippets copied from labs/05-networking/lab-5.1-windows-firewall.md
# Run them ONE BY ONE, on the machine named in the comment above each block. Do not run this file as a whole.
# Lab environment only: never run on production systems.

# Let's check the profiles first. On SEA-SVR1:
Get-NetFirewallProfile | Select Name, Enabled
Get-NetConnectionProfile

# If any profile is off, turn it on:
Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True

# Now let's create a rule that allows ping, but only from SEA-CL1:
New-NetFirewallRule -DisplayName "Allow ping from admin PC" -Direction Inbound -Protocol ICMPv4 -IcmpType 8 -RemoteAddress 10.10.0.20 -Profile Domain -Action Allow

# Let's test. From SEA-CL1:
Test-NetConnection SEA-SVR1
