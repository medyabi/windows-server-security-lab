# Lab 2.4: Read-only domain controller (RODC)

[← Lab 2.3](lab-2.3-protected-users.md) · [Chapter overview](README.md) · [Lab 2.5 →](lab-2.5-authentication-policy-silos.md)

| | |
|---|---|
| **Attack** | Stolen branch-office domain controller |
| **Control** | RODC + Password Replication Policy |
| **Machines** | SEA-SVR2, SEA-DC1 |
| **Needs** | None |
| **Checkpoint first** | Yes, strongly recommended (can lock you out or stop a server booting) |
| **Scripts** | [`scripts/lab-2.4-rodc.ps1`](../../scripts/lab-2.4-rodc.ps1) |

## 🥷 Hacker scenario

A thief walks out of the Agadir branch office with the server. At home, they copy the AD database (`ntds.dit`) off the disk and crack every hash in it, including your Domain Admins.

## 📖 Concepts

A normal domain controller has a copy of every password hash in the domain. That's fine in a locked data centre. But what about a small branch office, with a server under a desk and no IT staff?

A **read-only domain controller** (RODC) solves this:

- Its copy of AD is **read-only**. Nobody can make changes on it.
- It **doesn't store passwords** by default. Only the accounts you allow in the **Password Replication Policy** (PRP) get cached.
- You can make a branch user its local admin, without making them a Domain Admin. That's **Administrator Role Separation**.

## 🛡️ How this stops the attacker

The stolen RODC only holds hashes of branch users. The admin hashes were never there. You reset the cached passwords, delete the RODC computer object, and the damage stays small.

## 🧪 Step by step

1. On SEA-SVR2, install the role:

   ```powershell
   Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
   ```

2. In **Server Manager**, click the flag and choose **Promote this server to a domain controller**. Pick **Add a domain controller to an existing domain**.
3. On **Domain Controller Options**, tick **Read only domain controller (RODC)** and set a DSRM password.
4. On **RODC Options**, set **Delegated administrator account** to **Adam**. Adam becomes local admin of this RODC only.
5. Under **Accounts that are allowed to replicate passwords**, add **Accounting**. Leave Administrators, Server Operators and the other admin groups in the **denied** list.
6. Finish the wizard and let it reboot.

The PowerShell version, in one line:

```powershell
Install-ADDSDomainController -DomainName contoso.com -ReadOnlyReplica -SiteName Default-First-Site-Name -InstallDns
```

In a real branch you'd create a separate site, and use **Install From Media** (IFM) for slow links.

Let's check. In ADUC, SEA-SVR2 appears under **Domain Controllers** with the type **Read-only, DC**. Open its properties, go to **Password Replication Policy > Advanced**. Only accounts from Accounting will ever show up as cached.

## ✅ Key takeaway

Physical theft is a real risk for branch offices. An RODC makes sure a stolen server doesn't mean a stolen domain.

---
[← Lab 2.3](lab-2.3-protected-users.md) · [Chapter overview](README.md) · [Lab 2.5 →](lab-2.5-authentication-policy-silos.md)
