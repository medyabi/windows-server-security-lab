# Final thoughts and the attack → control map

[← Back to the README](../README.md)

You made it to the end. Well done!

Let's look back for a moment. Did you notice that no single control stops every attack? Credential Guard doesn't help against a stolen disk. BitLocker doesn't help against password spraying. That's the whole idea of **defence in depth**: many layers, so when one fails, the next one catches the attacker.

Here's a quick review. Cover the middle column with your hand, read the attack, and try to name the control yourself. If you can, you're ready for the exam, and for the real world.

| Attack | Control that stops or detects it | Lab |
|---|---|---|
| Brute force, password spray | Lockout policy, fine-grained PSO, Entra Password Protection, KQL alert on event 4625 | 1.1, 2.1, 2.2, 4.2 |
| Memory exploit (buffer overflow) | Exploit protection (DEP, ASLR, CFG) | 1.2 |
| Unknown malware or attacker tools | App Control for Business, Defender for Endpoint | 1.3, 1.6 |
| Pass-the-hash, pass-the-ticket | Credential Guard, Protected Users | 1.4, 2.3 |
| Phishing download, fake website | SmartScreen with prevent bypass | 1.5 |
| Vulnerable third-party app | Defender for Endpoint vulnerability management, Defender for Cloud | 1.6, 4.4 |
| Stolen branch office DC | RODC with Password Replication Policy, BitLocker | 2.4, 6.1 |
| Stolen admin password used on a sensitive server | Authentication policy silos | 2.5 |
| Backdoor admin account (persistence) | Restricted Groups, Sentinel analytics rule | 3.1, 4.3 |
| Over-privileged helpdesk account | Delegation of Control | 3.2 |
| Lateral movement with delegated tickets | Constrained delegation, CredSSP off after use | 3.3 |
| Reconnaissance and attacks on DCs | Defender for Identity | 3.4 |
| Clearing the logs | Arc + Azure Monitor Agent to Log Analytics | 4.1 |
| Attack spread across many tools | Microsoft Sentinel incidents and playbooks | 4.3 |
| Phished owner account without MFA | Defender for Cloud recommendations, MFA | 4.4 |
| Worm scanning for open ports | Windows Defender Firewall with scoped rules | 5.1, 5.3 |
| Man-in-the-middle, rogue laptop on the LAN | IPsec connection security rules | 5.2 |
| Stolen disk or copied VHDX | BitLocker with keys in AD | 6.1, 6.2 |
| Azure disk export by a rogue Contributor | Azure Disk Encryption, customer-managed keys | 6.3 |

One last piece of advice. Don't just read these labs. **Break things.** Play the hacker, try to get around your own controls, and see what happens. That's where the real learning is.

Good luck with your AZ-801 exam!
