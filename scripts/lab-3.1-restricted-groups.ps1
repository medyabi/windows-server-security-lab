# Lab 3.1: Built-in admin groups and Restricted Groups
# Snippets copied from labs/03-least-privilege-and-delegation/lab-3.1-restricted-groups.md
# Run them ONE BY ONE, on the machine named in the comment above each block. Do not run this file as a whole.
# Lab environment only: never run on production systems.

# First, let's look at what we have. On SEA-SVR1:
Get-LocalGroupMember Administrators

# Now check the domain groups:
Get-ADGroupMember "Domain Admins"
Get-ADGroupMember "Enterprise Admins"
Get-ADGroupMember "Schema Admins"

# Let's create a group for server admins and lock the local group:
New-ADGroup -Name Server-Admins -GroupScope Global

# Time to play hacker. On SEA-SVR1, add Mohamed to the local Administrators group:
Add-LocalGroupMember Administrators -Member CONTOSO\Mohamed
gpupdate /force
Get-LocalGroupMember Administrators
