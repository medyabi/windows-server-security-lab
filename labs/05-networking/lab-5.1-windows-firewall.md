# Lab 5.1: Windows Defender Firewall

[← Lab 4.4](../04-watching-from-azure/lab-4.4-secure-score.md) · [Chapter overview](README.md) · [Lab 5.2 →](lab-5.2-ipsec-connection-security.md)

| | |
|---|---|
| **Attack** | Worm scanning for open SMB / RDP |
| **Control** | Windows Defender Firewall with scoped rules |
| **Machines** | SEA-SVR1, SEA-CL1, SEA-DC1 |
| **Needs** | None |
| **Checkpoint first** | Recommended (see lab setup) |
| **Scripts** | [`scripts/lab-5.1-windows-firewall.ps1`](../../scripts/lab-5.1-windows-firewall.ps1) |

## 🥷 Hacker scenario

Two years ago, someone turned off the firewall on SEA-SVR1 "to fix an app". Nobody turned it back on. Today, a worm on a compromised laptop scans the subnet. It finds SMB and RDP wide open on SEA-SVR1 and spreads to it in minutes.

## 📖 Concepts

**Windows Defender Firewall with Advanced Security** is a host-based firewall. It runs on the server itself, so it protects the server even from machines on the same subnet.

It has three **profiles**, and Windows picks one based on the network:

- **Domain**: the server can reach a domain controller. Normal for a domain-joined server.
- **Private**: a trusted network you marked yourself, like home.
- **Public**: everything else, like a coffee shop. The strictest one.

The default behaviour is simple: **inbound traffic is blocked**, unless a rule allows it. **Outbound traffic is allowed**. Rules can be very specific: program, port, protocol, remote IP address, profile.

The secret to a good firewall is the **scope**. "Allow RDP" is OK. "Allow RDP only from the admin workstation" is much better.

## 🛡️ How this stops the attacker

With the firewall on and rules scoped, the worm finds closed ports. Only the admin workstation can reach management traffic. And during an active attack, you can block all new inbound connections with one setting.

## 🧪 Step by step

Let's check the profiles first. On SEA-SVR1:

```powershell
Get-NetFirewallProfile | Select Name, Enabled
Get-NetConnectionProfile
```

The first command shows if each profile is on. The second one shows which profile your network card uses right now. It should say **DomainAuthenticated**.

If any profile is off, turn it on:

```powershell
Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True
```

Now let's create a rule that allows ping, but only from SEA-CL1:

```powershell
New-NetFirewallRule -DisplayName "Allow ping from admin PC" -Direction Inbound -Protocol ICMPv4 -IcmpType 8 -RemoteAddress 10.10.0.20 -Profile Domain -Action Allow
```

Let me explain: inbound traffic, ICMP type 8 (that's an echo request, a ping), only from 10.10.0.20, only on the Domain profile.

You can do the same in the GUI: `wf.msc` > **Inbound Rules > New Rule > Custom**, then set protocol ICMPv4, the scope and the profile.

Let's test. From SEA-CL1:

```powershell
Test-NetConnection SEA-SVR1
```

**PingSucceeded: True**. Now run the same from SEA-DC1. **PingSucceeded: False**. Only our admin workstation gets in.

A few more things to know:

- **Export the policy**: in `wf.msc`, right-click the root node and choose **Export Policy**. In production, create the rules in a GPO under *Security Settings > Windows Defender Firewall with Advanced Security* so every server gets them.
- **Shields up**: in the Control Panel firewall settings, **Block all incoming connections, including those in the list of allowed apps**. That's your emergency button during an attack.

## ✅ Key takeaway

A server with the firewall off, or full of "allow any" rules, can be reached from everywhere. Every open service is a door.

---
[← Lab 4.4](../04-watching-from-azure/lab-4.4-secure-score.md) · [Chapter overview](README.md) · [Lab 5.2 →](lab-5.2-ipsec-connection-security.md)
