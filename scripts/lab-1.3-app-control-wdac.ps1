# Lab 1.3: App Control for Business (WDAC)
# Snippets copied from labs/01-securing-the-os/lab-1.3-app-control-wdac.md
# Run them ONE BY ONE, on the machine named in the comment above each block. Do not run this file as a whole.
# Lab environment only: never run on production systems.

# Let's create a policy from Microsoft's built-in example. On SEA-SVR1, in an elevated PowerShell:
New-Item C:\WDAC -ItemType Directory
Copy-Item C:\Windows\schemas\CodeIntegrity\ExamplePolicies\DefaultWindows_Audit.xml C:\WDAC\Server.xml
ConvertFrom-CIPolicy -XmlFilePath C:\WDAC\Server.xml -BinaryFilePath C:\WDAC\SIPolicy.p7b
