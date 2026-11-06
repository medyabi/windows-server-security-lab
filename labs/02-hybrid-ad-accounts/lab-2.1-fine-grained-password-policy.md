# Lab 2.1: Fine-grained password policy

[← Lab 1.6](../01-securing-the-os/lab-1.6-defender-for-endpoint.md) · [Chapter overview](README.md) · [Lab 2.2 →](lab-2.2-entra-password-protection.md)

| | |
|---|---|
| **Attack** | Password spray against a high-value team |
| **Control** | Fine-grained password policy (PSO) |
| **Machines** | SEA-DC1, SEA-CL1 |
| **Needs** | None |
| **Checkpoint first** | Recommended (see lab setup) |
| **Scripts** | [`scripts/lab-2.1-fine-grained-password-policy.ps1`](../../scripts/lab-2.1-fine-grained-password-policy.ps1) |

## 🥷 Hacker scenario

The attacker targets the Accounting team. Why? Because they approve payments. Mohamed uses an 8-character password, which the domain policy allows. A password-spray attack cracks it. Now the attacker sends fake payment approvals from Mohamed's real mailbox. Nobody suspects a thing.

## 📖 Concepts

In lab 1.1 we set one password policy for the whole domain. One size fits all. But does it?

Your receptionist and your finance team don't carry the same risk. Neither do your Domain Admins. A **fine-grained password policy** lets you give one group stronger rules, without building a second domain.

The technical name is a **Password Settings Object** (PSO). A few rules to remember:

- You apply a PSO to **users** or **global security groups**, not to OUs.
- Each PSO has a **precedence** number. If a user gets two PSOs, the **lowest** number wins.
- A PSO always beats the domain policy.

## 🛡️ How this stops the attacker

With a 16-character minimum, Mohamed's password is out of reach for spraying and takes far longer to crack offline. The attacker's quick win disappears.

## 🧪 Step by step

First, put Mohamed in the Accounting group:

```powershell
Add-ADGroupMember Accounting -Members Mohamed
```

Now let's create the PSO. You can't do this in ADUC; you need **Active Directory Administrative Center** (`dsac.exe`) or PowerShell.

1. Open `dsac.exe` and go to *contoso (local) > System > Password Settings Container*.
2. Right-click, **New > Password Settings**.
3. Name: **Accounting-PSO**. Precedence: **10**. Minimum password length: **16**. Complexity: on. History: **24**.
4. Under **Directly Applies To**, click **Add** and choose **Accounting**.

Prefer PowerShell? Here you go:

```powershell
New-ADFineGrainedPasswordPolicy -Name Accounting-PSO -Precedence 10 -MinPasswordLength 16 -ComplexityEnabled $true -PasswordHistoryCount 24
Add-ADFineGrainedPasswordPolicySubject Accounting-PSO -Subjects Accounting
```

> ⚠️ **Added by this repository (not in the original course text): carry the lockout rules over.** A PSO replaces the domain policy for its users, *including the lockout settings*. The PowerShell cmdlet leaves the lockout threshold at its default of `0` (never lock out), which would silently undo [Lab 1.1](../01-securing-the-os/lab-1.1-password-lockout-baseline.md) for the Accounting team. Set them explicitly (and check with `Get-ADFineGrainedPasswordPolicy Accounting-PSO`):
>
> ```powershell
> Set-ADFineGrainedPasswordPolicy Accounting-PSO -LockoutThreshold 10 -LockoutDuration 00:15:00 -LockoutObservationWindow 00:15:00
> ```
>
> In `dsac.exe` the same fields are in the *Password Settings* form (enforce account lockout policy).

Let's check which policy Mohamed really gets:

```powershell
Get-ADUserResultantPasswordPolicy Mohamed
```

The output shows **Accounting-PSO** with **MinPasswordLength 16**. Now try to give Mohamed a 12-character password. Windows refuses. Perfect.

> ⚠️ **Added by this repository: a sharper test.** If you did [Lab 1.1](../01-securing-the-os/lab-1.1-password-lockout-baseline.md), the *domain* policy already requires 14 characters, so a 12-character password is refused even without the PSO. To prove the PSO is doing the work, try a **15-character** password for Mohamed: the domain policy would accept it, the PSO (16) refuses it. Then try 16 characters: accepted.
>
> ```powershell
> Set-ADAccountPassword Mohamed -Reset -NewPassword (Read-Host -AsSecureString "15-character test password")
> ```

## ✅ Key takeaway

You can protect your high-value people with strong rules, while keeping life simple for everyone else. That's how you make security that users don't fight against.

---
[← Lab 1.6](../01-securing-the-os/lab-1.6-defender-for-endpoint.md) · [Chapter overview](README.md) · [Lab 2.2 →](lab-2.2-entra-password-protection.md)
