# Lab 1.6: Microsoft Defender for Endpoint

[← Lab 1.5](lab-1.5-smartscreen.md) · [Chapter overview](README.md) · [Lab 2.1 →](../02-hybrid-ad-accounts/lab-2.1-fine-grained-password-policy.md)

| | |
|---|---|
| **Attack** | Vulnerable third-party app (old 7-Zip) |
| **Control** | Microsoft Defender for Endpoint (EDR + vulnerability management) |
| **Machines** | SEA-SVR1 |
| **Needs** | Azure subscription, Defender for Servers plan, Azure Arc (see Lab 4.1) |
| **Checkpoint first** | Recommended (see lab setup) |
| **Scripts** | none (portal / GUI only) |

## 🥷 Hacker scenario

SEA-SVR1 runs an old version of 7-Zip with a known vulnerability. Nobody remembers installing it. The attacker sends a crafted archive to a user, who extracts it on the server. The vulnerability gives the attacker code execution.

## 📖 Concepts

Normal antivirus looks for things it already knows. **Microsoft Defender for Endpoint** (MDE) goes further. It's an **EDR** (Endpoint Detection and Response) tool:

- It watches **behaviour**, not just files. "Why is Word starting PowerShell?" is suspicious, even if no file is known malware.
- It keeps an **inventory** of installed software and finds **vulnerabilities**, also in non-Microsoft apps like 7-Zip.
- It can **respond**: isolate a server from the network with one click.

On servers, you normally get MDE through **Defender for Servers**, a plan in **Microsoft Defender for Cloud**.

## 🛡️ How this stops the attacker

MDE lists the old 7-Zip as a vulnerability, so you patch it before the attacker shows up. And if an exploit still runs, MDE sees the weird behaviour, raises an alert and can isolate the server.

## 🧪 Step by step

1. In the Azure portal, open **Microsoft Defender for Cloud > Environment settings** and choose your subscription.
2. Turn on **Defender for Servers**. **Plan 1** is enough for MDE. The trial is free for 30 days.
3. Under the plan's **Settings**, check that **Endpoint protection** is **On**.
4. Connect SEA-SVR1 with **Azure Arc** (we'll do that properly in Lab 4.1). MDE is then deployed to it automatically.
5. Open the Defender portal `https://security.microsoft.com` and go to **Assets > Devices**.

After a little while, SEA-SVR1 shows up with its software inventory and an exposure level. Open **Vulnerability management > Recommendations** to see what to fix first.

> 📌 **2025 note.** Defender for Servers includes the MDE licence for those servers. No need to buy MDE separately.

## ✅ Key takeaway

You can't patch what you don't know about. And attacks that use legitimate tools (PowerShell, for example) slip past normal antivirus.

---
[← Lab 1.5](lab-1.5-smartscreen.md) · [Chapter overview](README.md) · [Lab 2.1 →](../02-hybrid-ad-accounts/lab-2.1-fine-grained-password-policy.md)
