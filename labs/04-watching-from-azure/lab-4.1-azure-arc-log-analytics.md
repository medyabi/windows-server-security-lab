# Lab 4.1: Azure Arc and Log Analytics

[← Lab 3.4](../03-least-privilege-and-delegation/lab-3.4-defender-for-identity.md) · [Chapter overview](README.md) · [Lab 4.2 →](lab-4.2-kql-hunting-and-alerts.md)

| | |
|---|---|
| **Attack** | Attacker clears the Security log |
| **Control** | Azure Arc + Azure Monitor Agent -> Log Analytics |
| **Machines** | SEA-SVR1 |
| **Needs** | Azure subscription (resource group az801-rg) |
| **Checkpoint first** | Recommended (see lab setup) |
| **Scripts** | [`scripts/lab-4.1-azure-arc-log-analytics.ps1`](../../scripts/lab-4.1-azure-arc-log-analytics.ps1) |

## 🥷 Hacker scenario

The attacker creates a new local admin on SEA-SVR1, does their work, and then clears the Security log. The evidence lived only on that server. Now it's gone, and you'll never know what happened.

## 📖 Concepts

Let's meet three building blocks:

- **Azure Arc** makes an on-premises server show up in Azure as a resource, just like an Azure VM. Once it's there, Azure services can manage and protect it.
- **Log Analytics workspace** is a big database in Azure where logs are stored and searched.
- **Azure Monitor Agent** (AMA) runs on the server and sends the logs. A **Data Collection Rule** (DCR) tells it which logs to send and where.

Why do we need logs in the cloud? Because logs that live only on the server can be deleted by whoever controls the server.

One design tip: use separate workspaces for operations and for security. Different teams, different permissions, different retention.

## 🛡️ How this stops the attacker

The Security events are copied to Azure within minutes. Clearing the local log doesn't touch the copy. You still see the new account (event **4720**) and the group change (event **4732**). Even the log clearing itself shows up (event **1102**).

## 🧪 Step by step

1. In the Azure portal, create two **Log Analytics workspaces** in **az801-rg**: **law-infra** and **law-sentinel**.
2. Go to **Azure Arc > Machines > Add/Create > Add a single server > Generate script**. Choose **az801-rg**, your region, **Windows**, and **Public endpoint**.
3. Copy the script to SEA-SVR1 and run it in an elevated PowerShell. It asks you to sign in with a device code at `https://microsoft.com/devicelogin`.
4. Back in the portal, SEA-SVR1 shows as **Connected** under Azure Arc.

You can also check from the server itself:

```powershell
azcmagent show
```

Look for **Agent Status: Connected**. Now let's send the logs.

1. Go to **Monitor > Data Collection Rules > Create**. Name it **dcr-sea-svr1**, platform **Windows**.
2. On **Resources**, add SEA-SVR1. The **Azure Monitor Agent** gets installed automatically as an Arc extension.
3. On **Collect and deliver**, add **Windows Event Logs**. Tick **Security** (audit success and audit failure) and **System**. Destination: **law-infra**.

Wait 10 minutes, then open **law-infra > Logs** and run:

```kusto
Heartbeat
| where Computer startswith "SEA-SVR1"
| take 5
```

You'll see a heartbeat every minute. The camera is on.

> 📌 **2025 note.** The course installs the old **Log Analytics agent** (MMA). It was retired in August 2024. Use the **Azure Monitor Agent** with Data Collection Rules, like we just did.

## ✅ Key takeaway

You can't protect what you can't see. Arc is the bridge that brings your on-prem servers into Defender for Cloud, Sentinel and Azure Monitor. Every other lab in this chapter depends on it.

---
[← Lab 3.4](../03-least-privilege-and-delegation/lab-3.4-defender-for-identity.md) · [Chapter overview](README.md) · [Lab 4.2 →](lab-4.2-kql-hunting-and-alerts.md)
