# Lab 1.4: Credential Guard
# Snippets copied from labs/01-securing-the-os/lab-1.4-credential-guard.md
# Run them ONE BY ONE, on the machine named in the comment above each block. Do not run this file as a whole.
# Lab environment only: never run on production systems.

# Let's verify:
(Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard).SecurityServicesRunning
