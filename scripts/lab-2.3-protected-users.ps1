# Lab 2.3: The Protected Users group
# Snippets copied from labs/02-hybrid-ad-accounts/lab-2.3-protected-users.md
# Run them ONE BY ONE, on the machine named in the comment above each block. Do not run this file as a whole.
# Lab environment only: never run on production systems.

# Add Adam and John to the group:
Add-ADGroupMember "Protected Users" -Members Adam, John

# Now sign in to SEA-SVR1 as Adam and look at the tickets:
klist

# Check the End Time of the tickets. It's 4 hours after the Start Time. Next, try a connection by IP
# address, which forces NTLM:
net use \\10.10.0.10\c$
