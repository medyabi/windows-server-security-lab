# Lab 1.1: Password and lockout baseline with Group Policy
# Snippets copied from labs/01-securing-the-os/lab-1.1-password-lockout-baseline.md
# Run them ONE BY ONE, on the machine named in the comment above each block. Do not run this file as a whole.
# Lab environment only: never run on production systems.

# On SEA-SVR1, apply the policy:
gpupdate /force

# Let's test it. On SEA-CL1, try to sign in as Mohamed with a wrong password 10 times. On the 11th
# try, Windows tells you the account is locked. Let's check from PowerShell:
Get-ADUser Mohamed -Properties LockedOut | Select Name, LockedOut
