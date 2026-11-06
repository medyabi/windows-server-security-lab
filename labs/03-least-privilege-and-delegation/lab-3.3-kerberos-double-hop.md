# Lab 3.3: The Kerberos double-hop

[← Lab 3.2](lab-3.2-delegation-of-control.md) · [Chapter overview](README.md) · [Lab 3.4 →](lab-3.4-defender-for-identity.md)

| | |
|---|---|
| **Attack** | Lateral movement through delegated tickets |
| **Control** | Constrained delegation; CredSSP only temporarily |
| **Machines** | SEA-CL1, SEA-SVR1, SEA-DC1 |
| **Needs** | None |
| **Checkpoint first** | Recommended (see lab setup) |
| **Scripts** | [`scripts/lab-3.3-kerberos-double-hop.ps1`](../../scripts/lab-3.3-kerberos-double-hop.ps1) |

## 🥷 Hacker scenario

An admin connects from SEA-CL1 to SEA-SVR1, then tries to reach SEA-DC1 from there. It fails with a strange error. Annoyed, he searches the web and finds a quick fix: tick one box on SEA-SVR1 that says "trust this computer for delegation to any service". The error is gone. Happy admin.

Happy hacker too. From now on, every admin who connects to SEA-SVR1 leaves a reusable copy of their identity on it. The attacker, sitting on SEA-SVR1, picks up a Domain Admin's identity and uses it to jump to any server in the domain. Moving from server to server like this is called **lateral movement**.

Why did the first attempt fail? And why was that one checkbox so dangerous? Let's find out.

## 📖 Concepts

This one confuses many people, so let's take it slowly.

You're on SEA-CL1. You open a remote PowerShell session to SEA-SVR1. That's the **first hop**. Fine.

Inside that session, you try to reach SEA-DC1. That's the **second hop**. And it fails. Why?

Because SEA-SVR1 doesn't have your password. It only has a Kerberos ticket that proves who you are **to SEA-SVR1**. It can't pass your identity on to SEA-DC1. That's the **double-hop problem**, and it's there on purpose.

There are a few ways to allow the second hop:

- **Unconstrained delegation**: SEA-SVR1 can impersonate you to any server. Dangerous. Avoid it.
- **Kerberos constrained delegation**: SEA-SVR1 can impersonate you to **specific services** only. Much better.
- **CredSSP**: your actual credentials are sent to SEA-SVR1. It works, but those credentials now sit on that server. Use it only temporarily, then turn it off.

## 🛡️ How this stops the attacker

With constrained delegation, SEA-SVR1 can only forward your identity to one named service on SEA-DC1. The tickets are useless anywhere else. And if you use CredSSP, you switch it off right after, so nothing stays behind. Remember also: members of **Protected Users** can't be delegated at all.

## 🧪 Step by step

Let's see the problem first. On SEA-CL1, as a Domain Admin:

```powershell
Enter-PSSession -ComputerName SEA-SVR1
Invoke-Command -ComputerName SEA-DC1 -ScriptBlock { Get-Service NTDS }
```

You get an access denied or Kerberos error. That's the double-hop block. Type `Exit-PSSession`.

**Fix 1: Kerberos constrained delegation (preferred).**

1. In ADUC, open the properties of the **SEA-SVR1** computer and go to the **Delegation** tab.
2. Select **Trust this computer for delegation to specified services only** and **Use Kerberos only**.
3. Click **Add**, choose **SEA-DC1**, and select the service you need, for example **cifs** for file access or **HOST**.

Note that PowerShell remoting through WinRM still doesn't pass the second hop with this setting for every command. For file access and many tools it does. That's why many admins use **resource-based constrained delegation** or **JEA**. For this course, focus on the concept: delegate to named services only.

**Fix 2: CredSSP (temporary only).**

On SEA-CL1, allow your client to send credentials to SEA-SVR1:

```powershell
Enable-WSManCredSSP -Role Client -DelegateComputer SEA-SVR1 -Force
```

On SEA-SVR1, allow the server to receive them:

```powershell
Invoke-Command -ComputerName SEA-SVR1 -ScriptBlock { Enable-WSManCredSSP -Role Server -Force }
```

Now connect with CredSSP and try the second hop again:

```powershell
Enter-PSSession SEA-SVR1 -Credential CONTOSO\administrator -Authentication CredSSP
Invoke-Command -ComputerName SEA-DC1 -ScriptBlock { Get-Service NTDS }
```

It works! SEA-SVR1 had your real credentials, so it could pass them on.

And now the most important part, the cleanup:

```powershell
Disable-WSManCredSSP -Role Client
Invoke-Command -ComputerName SEA-SVR1 -ScriptBlock { Disable-WSManCredSSP -Role Server }
Get-WSManCredSSP
```

The last command should tell you CredSSP is not configured on either side.

## ✅ Key takeaway

Admins hit the double-hop error all the time. The quick fix they find online is often the dangerous one. You need to know the safe one.

---
[← Lab 3.2](lab-3.2-delegation-of-control.md) · [Chapter overview](README.md) · [Lab 3.4 →](lab-3.4-defender-for-identity.md)
