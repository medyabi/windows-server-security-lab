# Chapter 3: Least privilege and delegation

[← All chapters](../../README.md)

The theme of this chapter fits in two words: **least privilege**. Every account gets exactly the rights it needs to do its job. Not one bit more.

Why? Because when an account is stolen (and one day, one will be), the attacker gets only what that account had.

## Labs

| Lab | Attack | Control |
|---|---|---|
| [3.1 Built-in admin groups and Restricted Groups](lab-3.1-restricted-groups.md) | Backdoor admin account (persistence) | Restricted Groups |
| [3.2 Delegation of Control](lab-3.2-delegation-of-control.md) | Over-privileged helpdesk account | Delegation of Control |
| [3.3 The Kerberos double-hop](lab-3.3-kerberos-double-hop.md) | Lateral movement through delegated tickets | Constrained delegation; CredSSP only temporarily |
| [3.4 Microsoft Defender for Identity](lab-3.4-defender-for-identity.md) | Reconnaissance and attacks against domain controllers | Microsoft Defender for Identity |
