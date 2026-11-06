# Chapter 1: Securing the Windows Server operating system

[← All chapters](../../README.md)

We start with the server itself. Think of it like a house. Before you worry about the neighbourhood, you lock your own doors and windows.

## Labs

| Lab | Attack | Control |
|---|---|---|
| [1.1 Password and lockout baseline with Group Policy](lab-1.1-password-lockout-baseline.md) | Brute force / password spray | Password + lockout policy (Group Policy) |
| [1.2 Exploit protection](lab-1.2-exploit-protection.md) | Memory exploit (buffer overflow) in an unpatched app | Exploit protection: DEP, ASLR, CFG, ACG |
| [1.3 App Control for Business (WDAC)](lab-1.3-app-control-wdac.md) | Unknown malware or attacker tools dropped on the server | App Control for Business (WDAC) allow list |
| [1.4 Credential Guard](lab-1.4-credential-guard.md) | Pass-the-hash after reading LSASS memory | Credential Guard (virtualization-based security) |
| [1.5 Microsoft Defender SmartScreen](lab-1.5-smartscreen.md) | Phishing download / fake download site | Microsoft Defender SmartScreen, prevent bypass |
| [1.6 Microsoft Defender for Endpoint](lab-1.6-defender-for-endpoint.md) | Vulnerable third-party app (old 7-Zip) | Microsoft Defender for Endpoint (EDR + vulnerability management) |
