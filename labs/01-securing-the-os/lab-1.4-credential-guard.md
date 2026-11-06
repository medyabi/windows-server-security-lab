# Lab 1.4: Credential Guard

[← Lab 1.3](lab-1.3-app-control-wdac.md) · [Chapter overview](README.md) · [Lab 1.5 →](lab-1.5-smartscreen.md)

| | |
|---|---|
| **Attack** | Pass-the-hash after reading LSASS memory |
| **Control** | Credential Guard (virtualization-based security) |
| **Machines** | SEA-SVR1, SEA-DC1 |
| **Needs** | None (needs Gen 2 VM + vTPM + Secure Boot) |
| **Checkpoint first** | Yes, strongly recommended (can lock you out or stop a server booting) |
| **Scripts** | [`scripts/lab-1.4-credential-guard.ps1`](../../scripts/lab-1.4-credential-guard.ps1) |

## 🥷 Hacker scenario

The attacker already has local admin on SEA-SVR1. Earlier today, **Adam** (a Domain Admin) signed in to fix a printer. He signed out an hour ago. Is he safe now? Not at all. The attacker runs a tool that reads the server's memory and finds something Adam left behind: a **hash** of his password. They don't even need to crack it. They send that hash to SEA-DC1 and log in as Adam. Now they're Domain Admin. Game over.

Wait, how can a hash be used like a password? And why was it still in memory? That's exactly what we'll explain now.

## 📖 Concepts

When you sign in to Windows, a process called **LSASS** keeps your secrets in memory: your **NTLM hash** and your **Kerberos tickets**. Why? So you don't have to type your password every time you open a file share.

Here's the problem. Anyone who is a local admin can read LSASS memory. And a hash is almost as good as a password. An attacker can send the hash to another server and log in as you. That's called **pass-the-hash**.

**Credential Guard** fixes this with **virtualization-based security** (VBS). It uses the Hyper-V hypervisor to create a small, isolated area of memory. The secrets move into a process called **LSAIso** inside that area. LSASS can still use them, but nobody can read them. Not even a local admin.

Think of it like a bank vault inside the bank. Even the bank manager can't open it on his own.

## 🛡️ How this stops the attacker

The dump tool reads LSASS and finds only encrypted blobs. The real hash lives in LSAIso, behind the hypervisor. No hash, no pass-the-hash. The attacker is stuck on SEA-SVR1.

## 🧪 Step by step

First, check that the server is ready. On SEA-SVR1 run `msinfo32` and look at **Secure Boot State** (should be On) and **Virtualization-based security**. Your Gen 2 VM with a vTPM has everything it needs.

1. On SEA-DC1, edit the servers GPO: *Computer Configuration > Administrative Templates > System > Device Guard > Turn On Virtualization Based Security*.
2. Set it to **Enabled**. **Select Platform Security Level**: **Secure Boot**. **Credential Guard Configuration**: **Enabled without lock**.
3. On SEA-SVR1, run `gpupdate /force` and restart.

Why "without lock"? With UEFI lock, you can't turn Credential Guard off remotely anymore. That's great in production, but painful in a lab.

Let's verify:

```powershell
(Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard).SecurityServicesRunning
```

If you see the value **1**, Credential Guard is running. You can also open `msinfo32` again: **Virtualization-based security Services Running** now shows **Credential Guard**.

> 📌 **2025 note.** On Windows Server 2025, Credential Guard is turned on by default for member servers on supported hardware. Domain controllers don't use it. Always check instead of assuming.

## ✅ Key takeaway

Pass-the-hash is one of the most common ways attackers move from one server to the whole domain. Credential Guard cuts that path.

---
[← Lab 1.3](lab-1.3-app-control-wdac.md) · [Chapter overview](README.md) · [Lab 1.5 →](lab-1.5-smartscreen.md)
