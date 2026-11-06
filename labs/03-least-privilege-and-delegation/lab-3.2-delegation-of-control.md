# Lab 3.2: Delegation of Control

[← Lab 3.1](lab-3.1-restricted-groups.md) · [Chapter overview](README.md) · [Lab 3.3 →](lab-3.3-kerberos-double-hop.md)

| | |
|---|---|
| **Attack** | Over-privileged helpdesk account |
| **Control** | Delegation of Control |
| **Machines** | SEA-DC1, SEA-CL1 |
| **Needs** | None |
| **Checkpoint first** | Recommended (see lab setup) |
| **Scripts** | none (portal / GUI only) |

## 🥷 Hacker scenario

The attacker phishes a helpdesk technician. If that account is a Domain Admin, the attacker now owns the whole domain. Every server, every user, every backup.

## 📖 Concepts

Your helpdesk needs to reset passwords. That's all. Do they need to be Domain Admins for that? Of course not. But you'd be surprised how often that's exactly what happens.

**Delegation** lets you give a specific permission on a specific OU. For example: "Helpdesk can reset passwords for users in the Staff OU". Nothing else, nowhere else.

The easiest way is the **Delegation of Control Wizard** in ADUC. Behind the scenes, it writes permissions (ACEs) on the OU.

## 🛡️ How this stops the attacker

With delegation, the stolen account can only reset passwords in the Staff OU. It can't reset a Domain Admin's password, and it can't add itself to a privileged group. The attacker is stuck in one small corner.

## 🧪 Step by step

1. In ADUC, right-click the **Staff** OU and choose **Delegate Control**.
2. Click **Add** and choose **Mohamed** (in real life, use a **Helpdesk** group, not a single user).
3. Choose the common task **Reset user passwords and force password change at next logon**.
4. Click **Finish**.

Let's test. Sign in to SEA-CL1 as Mohamed and open ADUC. Right-click a user in the **Staff** OU and choose **Reset Password**. It works.

Now try the same on **Adam**, who is outside the Staff OU. You get **Access is denied**. Try to add yourself to a group. Denied again. That's least privilege in action.

## ✅ Key takeaway

Delegation shrinks the blast radius. A stolen helpdesk account becomes a small problem instead of a domain-wide disaster.

---
[← Lab 3.1](lab-3.1-restricted-groups.md) · [Chapter overview](README.md) · [Lab 3.3 →](lab-3.3-kerberos-double-hop.md)
