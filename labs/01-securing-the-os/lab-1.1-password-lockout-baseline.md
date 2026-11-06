# Lab 1.1: Password and lockout baseline with Group Policy

[Chapter overview](README.md) · [Lab 1.2 →](lab-1.2-exploit-protection.md)

| | |
|---|---|
| **Attack** | Brute force / password spray |
| **Control** | Password + lockout policy (Group Policy) |
| **Machines** | SEA-DC1, SEA-SVR1, SEA-CL1 |
| **Needs** | None |
| **Checkpoint first** | Recommended (see lab setup) |
| **Scripts** | [`scripts/lab-1.1-password-lockout-baseline.ps1`](../../scripts/lab-1.1-password-lockout-baseline.ps1) |

## 🥷 Hacker scenario

An attacker on your network starts a **brute-force** tool against SEA-SVR1. It tries password after password: *Password1*, *Welcome2026*, *Summer2025!*... There's no lockout, so the tool can keep going all night. Thousands of guesses per hour. Sooner or later one of them works.

## 📖 Concepts

What is **Group Policy**? It's a way to push settings from a domain controller to many computers at once. You configure a setting one time in a **Group Policy Object** (GPO), link that GPO to a domain or OU, and every computer in there applies it.

Two settings matter here:

- **Password policy**: how long and complex a password must be.
- **Account lockout policy**: how many wrong passwords someone can type before the account gets locked.

Here's a detail many people miss: the domain password policy only works in a GPO linked to the **domain** itself, normally the **Default Domain Policy**. Put it on an OU and the domain accounts simply ignore it.

## 🛡️ How this stops the attacker

With a lockout threshold of 10, the attacker gets 10 guesses. Then the account is locked for 15 minutes. That's 40 guesses per hour instead of thousands. Most automated tools give up and look for an easier target.

## 🧪 Step by step

1. On SEA-DC1, open **Group Policy Management**: `gpmc.msc`.
2. Right-click **Default Domain Policy** and click **Edit**.
3. Go to *Computer Configuration > Policies > Windows Settings > Security Settings > Account Policies > Password Policy*.
4. Set **Minimum password length** to **14**, **Password must meet complexity requirements** to **Enabled**, **Enforce password history** to **24**.
5. Open **Account Lockout Policy**. Set **Account lockout threshold** to **10**, **Account lockout duration** and **Reset account lockout counter after** to **15 minutes**.
6. On SEA-SVR1, apply the policy:

   ```powershell
   gpupdate /force
   ```

This tells the server: don't wait 90 minutes, go get the new settings now.

Let's test it. On SEA-CL1, try to sign in as **Mohamed** with a wrong password 10 times. On the 11th try, Windows tells you the account is locked. Let's check from PowerShell:

```powershell
Get-ADUser Mohamed -Properties LockedOut | Select Name, LockedOut
```

You'll see **LockedOut: True**. That's exactly what we want.

> 📌 **2025 note.** Microsoft now recommends long passwords that you rarely change, instead of forcing a change every 30 days. Why? Forced changes create *Password1*, *Password2*, *Password3*. A hacker can guess that pattern.

## ✅ Key takeaway

Every other control in this course sits on top of this baseline. If passwords are weak and there is no lockout, the attacker doesn't need any of the fancy stuff in later chapters.

---
[Chapter overview](README.md) · [Lab 1.2 →](lab-1.2-exploit-protection.md)
