# Lab 3.3: The Kerberos double-hop
# Snippets copied from labs/03-least-privilege-and-delegation/lab-3.3-kerberos-double-hop.md
# Run them ONE BY ONE, on the machine named in the comment above each block. Do not run this file as a whole.
# Lab environment only: never run on production systems.

# Let's see the problem first. On SEA-CL1, as a Domain Admin:
Enter-PSSession -ComputerName SEA-SVR1
Invoke-Command -ComputerName SEA-DC1 -ScriptBlock { Get-Service NTDS }

# On SEA-CL1, allow your client to send credentials to SEA-SVR1:
Enable-WSManCredSSP -Role Client -DelegateComputer SEA-SVR1 -Force

# On SEA-SVR1, allow the server to receive them:
Invoke-Command -ComputerName SEA-SVR1 -ScriptBlock { Enable-WSManCredSSP -Role Server -Force }

# Now connect with CredSSP and try the second hop again:
Enter-PSSession SEA-SVR1 -Credential CONTOSO\administrator -Authentication CredSSP
Invoke-Command -ComputerName SEA-DC1 -ScriptBlock { Get-Service NTDS }

# And now the most important part, the cleanup:
Disable-WSManCredSSP -Role Client
Invoke-Command -ComputerName SEA-SVR1 -ScriptBlock { Disable-WSManCredSSP -Role Server }
Get-WSManCredSSP
