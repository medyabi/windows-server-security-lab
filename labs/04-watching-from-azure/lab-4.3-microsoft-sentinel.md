# Lab 4.3: Microsoft Sentinel

[← Lab 4.2](lab-4.2-kql-hunting-and-alerts.md) · [Chapter overview](README.md) · [Lab 4.4 →](lab-4.4-secure-score.md)

| | |
|---|---|
| **Attack** | An attack spread across several tools |
| **Control** | Microsoft Sentinel: correlation, analytics rules, playbooks |
| **Machines** | SEA-SVR1 |
| **Needs** | Lab 4.1 completed (law-sentinel), Defender for Identity / Endpoint for the XDR connector |
| **Checkpoint first** | Recommended (see lab setup) |
| **Scripts** | [`scripts/lab-4.3-microsoft-sentinel.ps1`](../../scripts/lab-4.3-microsoft-sentinel.ps1) |

## 🥷 Hacker scenario

At 02:10, there's a risky Entra ID sign-in for Adam. At 02:25, a new local admin appears on SEA-SVR1. At 02:40, Defender for Identity flags reconnaissance. Three different tools, three small alerts. Nobody connects them until it's too late.

## 📖 Concepts

What's the difference between Defender for Cloud and Sentinel? Many students mix them up, so let's make it simple:

- **Defender for Cloud** is about **hygiene**: is this server configured securely? Are patches missing? It's for every admin.
- **Microsoft Sentinel** is about **detection and response**: is someone attacking us right now? It's for the security team.

Sentinel is a **SIEM** (Security Information and Event Management) and **SOAR** (Security Orchestration, Automation and Response). In plain words:

- **Data connectors** bring signals in from everywhere: servers, Entra ID, Defender, even AWS.
- **Analytics rules** look for suspicious patterns and create **incidents**.
- **Playbooks** (Logic Apps) respond automatically, for example by disabling an account.

The magic word is **correlation**. Sentinel connects small signals from different places into one story.

## 🛡️ How this stops the attacker

Sentinel correlates the three events into one incident with a timeline. An analyst sees the whole attack in one screen. A playbook can even disable Adam's account automatically while the analyst wakes up.

## 🧪 Step by step

1. In the Azure portal, open **Microsoft Sentinel > Create** and choose the **law-sentinel** workspace. The first 31 days include a free trial allowance.
2. Go to **Content hub**. Install the **Windows Security Events** and **Microsoft Defender XDR** solutions.
3. Open **Data connectors > Windows Security Events via AMA > Open connector page > Create data collection rule**. Add SEA-SVR1 and choose **Common** events.
4. Connect **Microsoft Defender XDR** too. That brings in the alerts from Defender for Endpoint and Defender for Identity.
5. Go to **Analytics > Rule templates**. Find a rule about a user being added to a privileged group, and click **Create rule**.
6. Optional: under **Automation**, create a **playbook** that posts new high-severity incidents to a Teams channel.

Time to test. On SEA-SVR1:

```powershell
New-LocalUser -Name backdoor -NoPassword
Add-LocalGroupMember Administrators -Member backdoor
```

This is exactly what our attacker did. When the rule runs, an **incident** appears in Sentinel with the user, the host and the timeline. Don't forget to delete the `backdoor` account afterwards.

> 📌 **2025 note.** Microsoft is moving Sentinel into the **Microsoft Defender portal**. Depending on your tenant, you might find it there instead of the Azure portal. The concepts are exactly the same.

## ✅ Key takeaway

Real attacks are spread across many tools. Each tool sees a piece. Sentinel puts the pieces together.

---
[← Lab 4.2](lab-4.2-kql-hunting-and-alerts.md) · [Chapter overview](README.md) · [Lab 4.4 →](lab-4.4-secure-score.md)
