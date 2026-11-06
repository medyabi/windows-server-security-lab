# Lab 2.5: Authentication policies and silos

[← Lab 2.4](lab-2.4-rodc.md) · [Chapter overview](README.md) · [Lab 3.1 →](../03-least-privilege-and-delegation/lab-3.1-restricted-groups.md)

| | |
|---|---|
| **Attack** | Stolen admin password used on a sensitive server |
| **Control** | Authentication policies and silos |
| **Machines** | SEA-DC1, SEA-SVR1, SEA-CL1 |
| **Needs** | None |
| **Checkpoint first** | Yes, strongly recommended (can lock you out or stop a server booting) |
| **Scripts** | none (portal / GUI only) |

## 🥷 Hacker scenario

The attacker phishes Adam, a Domain Admin. With his password, they connect to SEA-SVR1, the server that holds the payroll database, and copy it out.

## 📖 Concepts

By default, a Domain Admin can sign in to any computer in the domain. Any. Even a laptop in the meeting room.

**Authentication policies** and **authentication policy silos** let you say: "these accounts may only sign in to these computers". Think of it as a **firewall for authentication**.

- An **authentication policy** holds the rules: who can sign in where, and how long the Kerberos ticket (TGT) lives.
- A **silo** is the container. You put users, computers and services in it, and it applies the policy.

This uses **Kerberos armoring**, a feature that protects the Kerberos exchange and carries extra information (claims). We have to turn it on first.

## 🛡️ How this stops the attacker

Adam's password is valid, but Adam is not a member of the payroll silo. The domain controller refuses to give him a ticket for SEA-SVR1. The door stays shut.

## 🧪 Step by step

First, turn on Kerberos armoring.

1. Edit **Default Domain Controllers Policy**: *Computer Configuration > Policies > Administrative Templates > System > KDC > KDC support for claims, compound authentication and Kerberos armoring*. Set it to **Enabled**, option **Supported**.
2. Edit **Default Domain Policy**: *Computer Configuration > Policies > Administrative Templates > System > Kerberos > Kerberos client support for claims, compound authentication and Kerberos armoring*. Set it to **Enabled**.
3. Run `gpupdate /force` on the DC and the servers.

Now the policy and the silo, in **Active Directory Administrative Center**:

1. Go to **Authentication > Authentication Policies > New**. Name: **Payroll-Policy**. Select **Enforce policy restrictions**. Set **User TGT lifetime** to **60** minutes.
2. Go to **Authentication Policy Silos > New**. Name: **Payroll-Silo**. Select **Enforce silo policies**. Use **Payroll-Policy** for users, services and computers.
3. Under **Permitted Accounts**, add your own admin account and the **SEA-SVR1** computer.
4. Open your admin account and SEA-SVR1 in ADAC. In the **Silo** section, assign **Payroll-Silo**.
5. Back in **Payroll-Policy**, open **User Sign On > Edit** and add the condition **User > AuthenticationSilo > Equals > Payroll-Silo**.
6. Restart SEA-SVR1.

Let's test. Sign in to SEA-SVR1 as **Adam**. Windows says: *The computer you are signing into is protected by an authentication firewall*. Now sign in with your own admin account. That works.

One tip: both the policy and the silo must be set to **Enforce**. If one is still on audit, the lab "doesn't work". That's the number one mistake I see in class.

## ✅ Key takeaway

Even if an admin password is stolen, the attacker can only use it from the machines you allowed. Sensitive servers stay closed to everyone else.

---
[← Lab 2.4](lab-2.4-rodc.md) · [Chapter overview](README.md) · [Lab 3.1 →](../03-least-privilege-and-delegation/lab-3.1-restricted-groups.md)
