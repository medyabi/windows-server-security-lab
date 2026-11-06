# Chapter 4: Watching your servers from Azure

[← All chapters](../../README.md)

So far we've hardened the server and the accounts. But here's the uncomfortable truth: one day, something will still get through. When that happens, the question is simple. **Will you see it?**

In this chapter, Azure becomes your security camera.

## Labs

| Lab | Attack | Control |
|---|---|---|
| [4.1 Azure Arc and Log Analytics](lab-4.1-azure-arc-log-analytics.md) | Attacker clears the Security log | Azure Arc + Azure Monitor Agent -> Log Analytics |
| [4.2 Hunting with KQL and creating an alert](lab-4.2-kql-hunting-and-alerts.md) | Password spray nobody notices in the logs | KQL query + alert rule on event 4625 |
| [4.3 Microsoft Sentinel](lab-4.3-microsoft-sentinel.md) | An attack spread across several tools | Microsoft Sentinel: correlation, analytics rules, playbooks |
| [4.4 Improving the Secure Score with Defender for Cloud](lab-4.4-secure-score.md) | Owner account without MFA, unpatched server | Defender for Cloud recommendations and Secure Score |
