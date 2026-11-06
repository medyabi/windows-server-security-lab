# Lab 4.4: Improving the Secure Score with Defender for Cloud

[← Lab 4.3](lab-4.3-microsoft-sentinel.md) · [Chapter overview](README.md) · [Lab 5.1 →](../05-networking/lab-5.1-windows-firewall.md)

| | |
|---|---|
| **Attack** | Owner account without MFA, unpatched server |
| **Control** | Defender for Cloud recommendations and Secure Score |
| **Machines** | Azure portal |
| **Needs** | Lab 4.1 completed (Arc-connected server) |
| **Checkpoint first** | Not applicable (Azure only): delete the resources when you are done to avoid costs |
| **Scripts** | none (portal / GUI only) |

## 🥷 Hacker scenario

An owner account on your Azure subscription has no MFA. SEA-SVR1 is a month behind on patches. The attacker phishes the owner's password. Now they control everything in Azure, including the Arc-connected servers back in your data centre.

## 📖 Concepts

**Microsoft Defender for Cloud** checks your resources against security best practices and gives you two things:

- **Recommendations**: a to-do list, sorted by impact. "Enable MFA on owner accounts", "Install system updates", and so on.
- **Secure Score**: one number that goes up as you fix recommendations.

It covers Azure VMs **and** Arc-connected servers. That's why Arc was so important in lab 4.1.

## 🛡️ How this stops the attacker

With MFA, a phished password alone is useless. The attacker also needs the owner's phone. And a patched SEA-SVR1 closes the vulnerability they were planning to use next.

## 🧪 Step by step

1. Open **Defender for Cloud > Overview**. Write down your current Secure Score.
2. Go to **Recommendations**. Find *Accounts with owner permissions on Azure resources should be MFA enabled*.
3. Open it and look at the affected accounts. Fix it by enabling MFA through **Conditional Access** (or security defaults in a trial tenant).
4. Open a server recommendation, for example *System updates should be installed on your machines*. Click **Fix** if available, or follow the manual steps.
5. Optional: on any recommendation, use **Trigger logic app** to automate the fix next time.

Recommendations refresh on a schedule, so give it up to 24 hours. Then the item moves to **Healthy** and your Secure Score goes up. That's your progress, in one number your manager will understand.

## ✅ Key takeaway

Security is a long list of small things. Defender for Cloud tells you which ones matter most, so you fix the big holes first.

---
[← Lab 4.3](lab-4.3-microsoft-sentinel.md) · [Chapter overview](README.md) · [Lab 5.1 →](../05-networking/lab-5.1-windows-firewall.md)
