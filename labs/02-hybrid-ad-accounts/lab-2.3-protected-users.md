# Lab 2.3: The Protected Users group

[← Lab 2.2](lab-2.2-entra-password-protection.md) · [Chapter overview](README.md) · [Lab 2.4 →](lab-2.4-rodc.md)

| | |
|---|---|
| **Attack** | Credential theft when a Domain Admin signs in |
| **Control** | Protected Users group |
| **Machines** | SEA-DC1, SEA-SVR1 |
| **Needs** | None |
| **Checkpoint first** | Recommended (see lab setup) |
| **Scripts** | [`scripts/lab-2.3-protected-users.ps1`](../../scripts/lab-2.3-protected-users.ps1) |

## 🥷 Hacker scenario

Adam, a Domain Admin, signs in to SEA-SVR1 to fix a printer. The attacker is already on SEA-SVR1. They grab Adam's cached credentials and NTLM hash, then replay them against the domain controller.

## 📖 Concepts

**Protected Users** is a special security group. Put an account in it, and Windows applies strong protections automatically. You can't configure them; it's all or nothing:

- **No NTLM** authentication. Only Kerberos.
- **No cached credentials**. Nothing stays on the server after you log off.
- **No delegation**. Your credentials can't be forwarded to another server.
- **Shorter Kerberos tickets**: 4 hours instead of 10.
- No weak encryption like DES or RC4.

Sounds great, right? There's one catch. Never put service accounts or computer accounts in this group. They often need delegation or NTLM, and they'll break.

## 🛡️ How this stops the attacker

There's no NTLM hash to use, and nothing is cached on SEA-SVR1. Even a stolen Kerberos ticket expires in 4 hours. The loot is worthless or short-lived.

## 🧪 Step by step

1. Add Adam and John to the group:

   ```powershell
   Add-ADGroupMember "Protected Users" -Members Adam, John
   ```

2. Keep one **break-glass** admin account outside the group. If Kerberos ever has a problem, you still have a way in.
3. Have Adam sign out and sign back in. Group membership is only read at sign-in.

Now sign in to SEA-SVR1 as Adam and look at the tickets:

```powershell
klist
```

Check the **End Time** of the tickets. It's 4 hours after the **Start Time**. Next, try a connection by IP address, which forces NTLM:

```powershell
net use \\10.10.0.10\c$
```

It fails. NTLM is blocked for Adam. Exactly what we want.

> 📌 **2025 note.** Windows Server 2025 removed NTLMv1 completely, and Microsoft is phasing out NTLM. Protected Users gets you ready for that future today.

## ✅ Key takeaway

Your admin accounts are the crown jewels. One group membership removes most of the ways an attacker can steal and reuse them.

---
[← Lab 2.2](lab-2.2-entra-password-protection.md) · [Chapter overview](README.md) · [Lab 2.4 →](lab-2.4-rodc.md)
