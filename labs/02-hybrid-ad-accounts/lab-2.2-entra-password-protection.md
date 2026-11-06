# Lab 2.2: Microsoft Entra Password Protection

[← Lab 2.1](lab-2.1-fine-grained-password-policy.md) · [Chapter overview](README.md) · [Lab 2.3 →](lab-2.3-protected-users.md)

| | |
|---|---|
| **Attack** | Wordlist built from company words |
| **Control** | Microsoft Entra Password Protection |
| **Machines** | SEA-DC1, SEA-SVR1 |
| **Needs** | Entra ID P1/P2 trial, Azure portal, internet from SEA-SVR1 |
| **Checkpoint first** | Recommended (see lab setup) |
| **Scripts** | [`scripts/lab-2.2-entra-password-protection.ps1`](../../scripts/lab-2.2-entra-password-protection.ps1) |

## 🥷 Hacker scenario

The attacker visits your website and builds a wordlist: *Contoso*, *Casablanca*, product names, plus the year and an exclamation mark. They spray that list against every account. Three users have exactly that kind of password.

## 📖 Concepts

Here's a problem with complexity rules. Is *Contoso2026!* complex? Upper case, lower case, number, symbol. Yes! Is it a good password? Absolutely not.

**Microsoft Entra Password Protection** fixes this. It checks every new password against two lists:

- A **global banned list**, maintained by Microsoft, based on passwords that attackers really use.
- A **custom banned list** you create: your company name, your city, your products.

It's also clever. It normalises the password first, so *C0nt0$o* is treated as *contoso*.

How does it work on-premises? Two components:

- The **Proxy service** on a member server downloads the banned lists from Entra ID.
- The **DC Agent** on each domain controller checks new passwords against those lists.

The DC never talks to the internet directly. Only the proxy does, over outbound HTTPS.

## 🛡️ How this stops the attacker

Those passwords are on the banned list, so nobody can set them anymore. The attacker's wordlist matches nothing.

## 🧪 Step by step

1. In the Azure portal, go to **Microsoft Entra ID > Security > Authentication methods > Password protection**.
2. Set **Enforce custom list** to **Yes**. Add `contoso`, `casablanca` and your product names.
3. Set **Enable password protection on Windows Server Active Directory** to **Yes**. **Mode**: **Audit** for now.
4. Download **Azure AD Password Protection** from the Microsoft Download Center. You get two installers.
5. On **SEA-SVR1** (a member server, never a DC), install the **Proxy** and register it:

   ```powershell
   Import-Module AzureADPasswordProtection
   Register-AzureADPasswordProtectionProxy -AccountUpn admin@yourtenant.onmicrosoft.com
   Register-AzureADPasswordProtectionForest -AccountUpn admin@yourtenant.onmicrosoft.com
   ```

The first command registers the proxy with your tenant. The second registers your AD forest. You only need to do the forest one time.

1. On **SEA-DC1**, install the **DC Agent** and restart the DC. The agent adds a password filter that checks every password change.
2. When the audit logs look good, switch the mode in the portal to **Enforced**.

Let's test. Try to change Mohamed's password to `C0nt0so2026!`. In enforced mode, it's rejected. Check the log on SEA-DC1: **Event Viewer > Applications and Services Logs > Microsoft > AzureADPasswordProtection > DCAgent > Admin**. You'll see the rejection.

> 📌 **2025 note.** Azure AD is now **Microsoft Entra ID**. The users who benefit from this need an **Entra ID P1 or P2** licence. The PowerShell module still has the old name.

## ✅ Key takeaway

Users pick passwords they can remember. Hackers know that. This lab blocks the passwords that are "easy to remember" for everyone, including the attacker.

---
[← Lab 2.1](lab-2.1-fine-grained-password-policy.md) · [Chapter overview](README.md) · [Lab 2.3 →](lab-2.3-protected-users.md)
