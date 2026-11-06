# Progress checklist

[← Back to the README](../README.md)

Copy this file or tick the boxes in your own fork. A lab is **done** when you ran the attack simulation, applied the control, and saw the verification result.

- [ ] Lab built (4 VMs, domain, users, RSAT) and the *extra setup* done
- [ ] Checkpoint **Baseline** taken on every VM

## Chapter 1: Securing the Windows Server operating system

- [ ] [Lab 1.1: Password and lockout baseline with Group Policy](../labs/01-securing-the-os/lab-1.1-password-lockout-baseline.md)
- [ ] [Lab 1.2: Exploit protection](../labs/01-securing-the-os/lab-1.2-exploit-protection.md)
- [ ] [Lab 1.3: App Control for Business (WDAC)](../labs/01-securing-the-os/lab-1.3-app-control-wdac.md)
- [ ] [Lab 1.4: Credential Guard](../labs/01-securing-the-os/lab-1.4-credential-guard.md)
- [ ] [Lab 1.5: Microsoft Defender SmartScreen](../labs/01-securing-the-os/lab-1.5-smartscreen.md)
- [ ] [Lab 1.6: Microsoft Defender for Endpoint](../labs/01-securing-the-os/lab-1.6-defender-for-endpoint.md)

## Chapter 2: Securing hybrid Active Directory accounts

- [ ] [Lab 2.1: Fine-grained password policy](../labs/02-hybrid-ad-accounts/lab-2.1-fine-grained-password-policy.md)
- [ ] [Lab 2.2: Microsoft Entra Password Protection](../labs/02-hybrid-ad-accounts/lab-2.2-entra-password-protection.md)
- [ ] [Lab 2.3: The Protected Users group](../labs/02-hybrid-ad-accounts/lab-2.3-protected-users.md)
- [ ] [Lab 2.4: Read-only domain controller (RODC)](../labs/02-hybrid-ad-accounts/lab-2.4-rodc.md)
- [ ] [Lab 2.5: Authentication policies and silos](../labs/02-hybrid-ad-accounts/lab-2.5-authentication-policy-silos.md)

## Chapter 3: Least privilege and delegation

- [ ] [Lab 3.1: Built-in admin groups and Restricted Groups](../labs/03-least-privilege-and-delegation/lab-3.1-restricted-groups.md)
- [ ] [Lab 3.2: Delegation of Control](../labs/03-least-privilege-and-delegation/lab-3.2-delegation-of-control.md)
- [ ] [Lab 3.3: The Kerberos double-hop](../labs/03-least-privilege-and-delegation/lab-3.3-kerberos-double-hop.md)
- [ ] [Lab 3.4: Microsoft Defender for Identity](../labs/03-least-privilege-and-delegation/lab-3.4-defender-for-identity.md)

## Chapter 4: Watching your servers from Azure

- [ ] [Lab 4.1: Azure Arc and Log Analytics](../labs/04-watching-from-azure/lab-4.1-azure-arc-log-analytics.md)
- [ ] [Lab 4.2: Hunting with KQL and creating an alert](../labs/04-watching-from-azure/lab-4.2-kql-hunting-and-alerts.md)
- [ ] [Lab 4.3: Microsoft Sentinel](../labs/04-watching-from-azure/lab-4.3-microsoft-sentinel.md)
- [ ] [Lab 4.4: Improving the Secure Score with Defender for Cloud](../labs/04-watching-from-azure/lab-4.4-secure-score.md)

## Chapter 5: Securing Windows Server networking

- [ ] [Lab 5.1: Windows Defender Firewall](../labs/05-networking/lab-5.1-windows-firewall.md)
- [ ] [Lab 5.2: IPsec connection security rules](../labs/05-networking/lab-5.2-ipsec-connection-security.md)
- [ ] [Lab 5.3: Firewall review with Windows Admin Center](../labs/05-networking/lab-5.3-firewall-review-wac.md)

## Chapter 6: Securing Windows Server storage

- [ ] [Lab 6.1: BitLocker with recovery keys in Active Directory](../labs/06-storage-encryption/lab-6.1-bitlocker-ad-recovery.md)
- [ ] [Lab 6.2: Forcing BitLocker recovery](../labs/06-storage-encryption/lab-6.2-bitlocker-forced-recovery.md)
- [ ] [Lab 6.3: Encrypting Azure VM disks](../labs/06-storage-encryption/lab-6.3-azure-disk-encryption.md)

## Final

- [ ] Self-test: cover the middle column of the [attack → control map](attack-to-control-map.md) and name the control for every attack
