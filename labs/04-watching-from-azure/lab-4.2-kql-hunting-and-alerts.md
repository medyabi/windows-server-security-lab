# Lab 4.2: Hunting with KQL and creating an alert

[← Lab 4.1](lab-4.1-azure-arc-log-analytics.md) · [Chapter overview](README.md) · [Lab 4.3 →](lab-4.3-microsoft-sentinel.md)

| | |
|---|---|
| **Attack** | Password spray nobody notices in the logs |
| **Control** | KQL query + alert rule on event 4625 |
| **Machines** | SEA-CL1, SEA-SVR1 |
| **Needs** | Lab 4.1 completed (law-infra) |
| **Checkpoint first** | Recommended (see lab setup) |
| **Scripts** | [`scripts/lab-4.2-kql-hunting-and-alerts.kql`](../../scripts/lab-4.2-kql-hunting-and-alerts.kql) |

## 🥷 Hacker scenario

An attacker runs a password spray against SEA-SVR1. In ten minutes, there are hundreds of failed logons. The events are in the log, but nobody looks.

## 📖 Concepts

Logs are useless until someone asks them a question. **KQL** (Kusto Query Language) is how you ask.

KQL reads like a pipeline. You start with a table, then pipe it through filters, one step at a time:

- `where` keeps only the rows you want.
- `summarize ... by` counts or groups rows.
- `bin(TimeGenerated, 10m)` groups events into 10-minute buckets.

Once a query finds something interesting, you can turn it into an **alert rule** that runs on a schedule and notifies you.

Which event do we care about? **Event 4625**: a failed logon.

## 🛡️ How this stops the attacker

Your alert fires within minutes. Instead of an invisible pattern in a log, you get an email (or a Teams message) saying "something is attacking SEA-SVR1 right now".

## 🧪 Step by step

In **law-infra > Logs**, let's find the failed logons:

```kusto
Event
| where EventLog == "Security" and EventID == 4625
| summarize Failures = count() by Computer, bin(TimeGenerated, 10m)
| where Failures > 20
```

Let me walk you through it. We take the **Event** table, keep only failed logons from the Security log, count them per computer per 10 minutes, and keep only buckets with more than 20 failures.

Right now you probably get no results. Let's be the attacker. From SEA-CL1, try to sign in to SEA-SVR1 with a wrong password 25 times (for example with `net use \\SEA-SVR1\c$ /user:CONTOSO\testuser wrongpassword` in a loop).

Run the query again. Now you see a row with SEA-SVR1 and more than 20 failures. Click **Chart** to see the spike.

Now turn it into an alert:

1. Click **New alert rule**. The query is copied in for you.
2. Condition: **Number of results greater than 0**. Evaluate every **5 minutes**.
3. **Action group**: create one that emails you.
4. Give the rule a name and severity, and save.

Repeat the failed sign-ins. A few minutes later, the alert email lands in your inbox.

## ✅ Key takeaway

Nobody reads logs manually. Queries and alerts turn millions of events into one notification that matters.

---
[← Lab 4.1](lab-4.1-azure-arc-log-analytics.md) · [Chapter overview](README.md) · [Lab 4.3 →](lab-4.3-microsoft-sentinel.md)
