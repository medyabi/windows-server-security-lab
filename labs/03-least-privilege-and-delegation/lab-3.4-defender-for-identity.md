# Lab 3.4: Microsoft Defender for Identity

[← Lab 3.3](lab-3.3-kerberos-double-hop.md) · [Chapter overview](README.md) · [Lab 4.1 →](../04-watching-from-azure/lab-4.1-azure-arc-log-analytics.md)

| | |
|---|---|
| **Attack** | Reconnaissance and attacks against domain controllers |
| **Control** | Microsoft Defender for Identity |
| **Machines** | SEA-DC1, SEA-CL1, SEA-SVR1 |
| **Needs** | Microsoft 365 E5 trial (includes MDI) |
| **Checkpoint first** | Recommended (see lab setup) |
| **Scripts** | [`scripts/lab-3.4-defender-for-identity.ps1`](../../scripts/lab-3.4-defender-for-identity.ps1) |

## 🥷 Hacker scenario

At 3 a.m., the attacker uses a stolen account on SEA-SVR1. They list every member of Domain Admins, then run PowerShell remotely on SEA-DC1. Everyone in IT is asleep.

## 📖 Concepts

Nobody can watch domain controller logs 24 hours a day. **Microsoft Defender for Identity** (MDI) does it for you.

You install a small **sensor** on each domain controller. It reads network traffic and events, learns what normal looks like, and raises alerts on known attack techniques:

- **Reconnaissance**: someone listing all admins or all computers.
- **Credential attacks**: pass-the-hash, pass-the-ticket, Kerberoasting, brute force.
- **Domain dominance**: DCSync, Golden Ticket, suspicious remote execution on a DC.

Alerts show up in the **Microsoft Defender portal**, together with alerts from Defender for Endpoint.

## 🛡️ How this stops the attacker

MDI flags the reconnaissance and the remote execution, and links them to the user and the source machine. With one click in the same portal, you can disable the account and isolate SEA-SVR1.

## 🧪 Step by step

1. Get a licence. A **Microsoft 365 E5** trial includes MDI.
2. Open `https://security.microsoft.com` and go to **Settings > Identities > Sensors > Add sensor**. Download the installer and copy the **access key**.
3. Run the sensor setup on **SEA-DC1** and paste the access key.
4. Under **Settings > Identities > Directory service accounts**, add an account the sensor can use to read AD. A **gMSA** is the recommended choice.
5. Wait until the sensor status shows **Running** and **Healthy**.

Now let's do some (safe) hacker activity. On SEA-CL1:

```powershell
net user /domain
net group "Domain Admins" /domain
```

These commands list every user and every Domain Admin. That's exactly what an attacker does first. Next, run a remote command from SEA-SVR1 to SEA-DC1:

```powershell
Invoke-Command -ComputerName SEA-DC1 -ScriptBlock { whoami }
```

Go to **Incidents & alerts** in the Defender portal. After a few minutes you'll see alerts like *User and group membership reconnaissance* and *Remote code execution attempt*, with the user, source and target all linked.

> 📌 **2025 note.** The old MDI portal is retired. Everything now lives in the **Microsoft Defender portal**.

## ✅ Key takeaway

Every real attack has a reconnaissance phase. If you spot it there, you stop the attacker before they reach their goal.

---
[← Lab 3.3](lab-3.3-kerberos-double-hop.md) · [Chapter overview](README.md) · [Lab 4.1 →](../04-watching-from-azure/lab-4.1-azure-arc-log-analytics.md)
