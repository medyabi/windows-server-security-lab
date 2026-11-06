# Lab 3.1: Built-in admin groups and Restricted Groups

[← Lab 2.5](../02-hybrid-ad-accounts/lab-2.5-authentication-policy-silos.md) · [Chapter overview](README.md) · [Lab 3.2 →](lab-3.2-delegation-of-control.md)

| | |
|---|---|
| **Attack** | Backdoor admin account (persistence) |
| **Control** | Restricted Groups |
| **Machines** | SEA-DC1, SEA-SVR1 |
| **Needs** | None |
| **Checkpoint first** | Recommended (see lab setup) |
| **Scripts** | [`scripts/lab-3.1-restricted-groups.ps1`](../../scripts/lab-3.1-restricted-groups.ps1) |

## 🥷 Hacker scenario

After a first compromise, the attacker adds their own account to the local Administrators group on SEA-SVR1. That's called **persistence**. Even if you clean up the malware, they still have admin rights. Nobody notices for months.

## 📖 Concepts

Active Directory comes with powerful groups out of the box:

- **Domain Admins**: full control of the domain. Also automatically added to the local **Administrators** group on every domain-joined computer.
- **Enterprise Admins**: full control of the whole forest.
- **Schema Admins**: can change the AD schema. You almost never need this one.

Enterprise Admins and Schema Admins should be **empty** most of the time. Add someone only when you need it, then remove them.

And then there's the **local Administrators** group on each server. Anyone in it owns that server.

So how do we keep these groups clean? With **Restricted Groups** in Group Policy. You tell Group Policy: "the Administrators group on these servers must contain exactly these members". Every time the policy refreshes, it puts the list back the way you defined it.

## 🛡️ How this stops the attacker

Restricted Groups rewrites the membership at every Group Policy refresh. The attacker's account is kicked out within about 90 minutes, or right away at the next `gpupdate`.

## 🧪 Step by step

First, let's look at what we have. On SEA-SVR1:

```powershell
Get-LocalGroupMember Administrators
```

You'll see the local Administrator account and **CONTOSO\Domain Admins**. Domain Admins was added automatically when the server joined the domain.

Now check the domain groups:

```powershell
Get-ADGroupMember "Domain Admins"
Get-ADGroupMember "Enterprise Admins"
Get-ADGroupMember "Schema Admins"
```

Write down every member. Do you know why each one is there? If not, that's your first finding.

Let's create a group for server admins and lock the local group:

```powershell
New-ADGroup -Name Server-Admins -GroupScope Global
```

1. In **Group Policy Management**, create a GPO called **Servers-LocalAdmins** and link it to the OU that holds your servers.
2. Edit it: *Computer Configuration > Policies > Windows Settings > Security Settings > Restricted Groups*.
3. Right-click, **Add Group**, type **Administrators**.
4. Under **Members of this group**, add **CONTOSO\Domain Admins** and **CONTOSO\Server-Admins**.
5. While you're there, rename the built-in Administrator account: *Security Settings > Local Policies > Security Options > Accounts: Rename administrator account*.

Time to play hacker. On SEA-SVR1, add Mohamed to the local Administrators group:

```powershell
Add-LocalGroupMember Administrators -Member CONTOSO\Mohamed
gpupdate /force
Get-LocalGroupMember Administrators
```

Mohamed is gone. Group Policy put the group back exactly as we defined it.

## ✅ Key takeaway

Attackers love to hide in admin groups. A quiet extra member is a backdoor that survives password resets.

---
[← Lab 2.5](../02-hybrid-ad-accounts/lab-2.5-authentication-policy-silos.md) · [Chapter overview](README.md) · [Lab 3.2 →](lab-3.2-delegation-of-control.md)
