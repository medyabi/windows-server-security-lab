# Lab 1.3: App Control for Business (WDAC)

[← Lab 1.2](lab-1.2-exploit-protection.md) · [Chapter overview](README.md) · [Lab 1.4 →](lab-1.4-credential-guard.md)

| | |
|---|---|
| **Attack** | Unknown malware or attacker tools dropped on the server |
| **Control** | App Control for Business (WDAC) allow list |
| **Machines** | SEA-SVR1, SEA-DC1 |
| **Needs** | None |
| **Checkpoint first** | Yes, strongly recommended (can lock you out or stop a server booting) |
| **Scripts** | [`scripts/lab-1.3-app-control-wdac.ps1`](../../scripts/lab-1.3-app-control-wdac.ps1) |

## 🥷 Hacker scenario

The attacker gets a foothold on SEA-SVR1 and drops a file called `tool.exe`. It's a password-dumping tool, slightly modified so the antivirus doesn't recognise it. On a normal server, it runs without any problem.

## 📖 Concepts

There are two ways to stop bad software:

- **Block list**: "these programs are bad, block them". That's what antivirus does.
- **Allow list**: "only these programs are good, block everything else".

Which one is stronger? The allow list. A brand-new piece of malware is not on any block list yet. But it's also not on your allow list, so it can't run.

**App Control for Business** (it used to be called **WDAC**) is the Windows allow-list feature. It checks code before Windows loads it. That includes executables, scripts, DLLs and drivers.

One golden rule: always start in **audit mode**. Audit mode only logs what *would* be blocked. Jump straight to enforced mode and you might block something your server needs to boot.

## 🛡️ How this stops the attacker

`tool.exe` is not signed by Microsoft or anyone you trust. It's not on the allow list. In enforced mode, Windows simply refuses to load it. The attacker is logged in, but their toolbox is locked.

## 🧪 Step by step

Let's create a policy from Microsoft's built-in example. On SEA-SVR1, in an elevated PowerShell:

```powershell
New-Item C:\WDAC -ItemType Directory
Copy-Item C:\Windows\schemas\CodeIntegrity\ExamplePolicies\DefaultWindows_Audit.xml C:\WDAC\Server.xml
ConvertFrom-CIPolicy -XmlFilePath C:\WDAC\Server.xml -BinaryFilePath C:\WDAC\SIPolicy.p7b
```

The first file is a readable XML policy that allows Windows itself, in audit mode. The second command converts it into the binary format Windows actually uses.

1. Copy `SIPolicy.p7b` to a share that the servers can read (for example the `Policies$` share from the [lab setup](../../docs/00-welcome-and-lab-setup.md#extra-setup-the-labs-assume)).
2. On SEA-DC1, edit the servers GPO: *Computer Configuration > Administrative Templates > System > Device Guard > Deploy Windows Defender Application Control*. Enable it and enter the path to the `.p7b` file.
3. On SEA-SVR1, run `gpupdate /force` and restart.
4. Copy any small unsigned program to SEA-SVR1 and run it.

Now open **Event Viewer > Applications and Services Logs > Microsoft > Windows > CodeIntegrity > Operational**. Look for event **3076**. It says the program *would have been blocked*. Audit mode works. When the log only shows things you really want blocked, switch to enforced mode.

> 📌 **2025 note.** **AppLocker** still works but doesn't get new features. Prefer App Control: it also covers drivers and DLLs, and it's harder to bypass.

## ✅ Key takeaway

Even if a hacker logs in, they need tools to do damage. App Control takes their tools away.

---
[← Lab 1.2](lab-1.2-exploit-protection.md) · [Chapter overview](README.md) · [Lab 1.4 →](lab-1.4-credential-guard.md)
