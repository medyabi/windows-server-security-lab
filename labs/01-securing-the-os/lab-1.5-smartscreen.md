# Lab 1.5: Microsoft Defender SmartScreen

[← Lab 1.4](lab-1.4-credential-guard.md) · [Chapter overview](README.md) · [Lab 1.6 →](lab-1.6-defender-for-endpoint.md)

| | |
|---|---|
| **Attack** | Phishing download / fake download site |
| **Control** | Microsoft Defender SmartScreen, prevent bypass |
| **Machines** | SEA-CL1, SEA-DC1 |
| **Needs** | Internet (Microsoft SmartScreen test page) |
| **Checkpoint first** | Recommended (see lab setup) |
| **Scripts** | none (portal / GUI only) |

## 🥷 Hacker scenario

An admin needs a tool, so he searches the web from the server. He lands on a fake download site that looks exactly like the real one. He downloads the installer. It's a trojan. Without SmartScreen, it installs silently.

## 📖 Concepts

**SmartScreen** checks the **reputation** of websites and downloaded files. Before a file runs or a page loads, Windows asks Microsoft: "have you seen this before, and is it bad?" Known malware and phishing sites get a big red warning.

By default the user can click **Run anyway**. With Group Policy we can remove that button.

## 🛡️ How this stops the attacker

SmartScreen recognises the bad site and the bad file and blocks them before they run. With **prevent bypass**, the admin can't click past the warning, even if he's in a hurry.

## 🧪 Step by step

1. On SEA-CL1, open **Windows Security > App & browser control > Reputation-based protection settings**. Turn on everything, including **Potentially unwanted app blocking**.
2. Open Edge and go to Microsoft's safe test page `https://demo.smartscreen.msft.net`. Click the **Known Malware** and **Phishing** tests.
3. You get the red SmartScreen page. Notice there's still a way to continue.
4. Now let's lock it down. In a GPO go to *Computer Configuration > Administrative Templates > Windows Components > Windows Defender SmartScreen > Explorer > Configure Windows Defender SmartScreen* and set it to **Enabled, Warn and prevent bypass**. Do the same for Edge under *Microsoft Edge > SmartScreen settings*.
5. Run `gpupdate /force` and try the test page again.

The warning is back, but the **continue** option is gone. Mission accomplished.

## ✅ Key takeaway

Many attacks start with a human clicking something. SmartScreen is the safety net under that click.

---
[← Lab 1.4](lab-1.4-credential-guard.md) · [Chapter overview](README.md) · [Lab 1.6 →](lab-1.6-defender-for-endpoint.md)
