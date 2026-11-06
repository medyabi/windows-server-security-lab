# Lab 3.4: Microsoft Defender for Identity
# Snippets copied from labs/03-least-privilege-and-delegation/lab-3.4-defender-for-identity.md
# Run them ONE BY ONE, on the machine named in the comment above each block. Do not run this file as a whole.
# Lab environment only: never run on production systems.

# Now let's do some (safe) hacker activity. On SEA-CL1:
net user /domain
net group "Domain Admins" /domain

# These commands list every user and every Domain Admin. That's exactly what an attacker does first.
# Next, run a remote command from SEA-SVR1 to SEA-DC1:
Invoke-Command -ComputerName SEA-DC1 -ScriptBlock { whoami }
