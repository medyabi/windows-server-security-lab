# Lab 5.3: Firewall review with Windows Admin Center

[← Lab 5.2](lab-5.2-ipsec-connection-security.md) · [Chapter overview](README.md) · [Lab 6.1 →](../06-storage-encryption/lab-6.1-bitlocker-ad-recovery.md)

| | |
|---|---|
| **Attack** | "Allow all" inbound rule planted by the attacker |
| **Control** | Firewall review with Windows Admin Center |
| **Machines** | SEA-SVR1, SEA-CL1, SEA-DC1 |
| **Needs** | Windows Admin Center download |
| **Checkpoint first** | Recommended (see lab setup) |
| **Scripts** | [`scripts/lab-5.3-firewall-review-wac.ps1`](../../scripts/lab-5.3-firewall-review-wac.ps1) |

## 🥷 Hacker scenario

During an incident, you suspect the attacker created an "allow all" inbound rule on SEA-SVR1 for their remote access tool. You need to confirm it, and close it, in two minutes.

## 📖 Concepts

**Windows Admin Center** (WAC) is a browser-based management tool for Windows Server. You add your servers once, then manage them from one place: services, events, storage, and the **firewall**.

For the firewall, WAC is great for **quick checks**: which profiles are on, which rules exist, enable or disable a rule. It can create simple port rules. For anything advanced (custom rules, IPsec), you still use `wf.msc` or Group Policy.

## 🛡️ How this stops the attacker

With WAC, you spot the unknown rule fast and disable it on the spot. The attacker's remote access is cut during the incident, not weeks later during an audit.

## 🧪 Step by step

First, let's plant a "malicious" rule on SEA-SVR1, so we have something to find:

```powershell
New-NetFirewallRule -DisplayName "Windows Update Helper" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 4444
```

Notice the innocent name. Attackers love names like that. Port 4444 is a classic for remote shells.

1. Install Windows Admin Center on SEA-CL1 (download it from Microsoft) and open it in the browser.
2. Click **Add** and add SEA-SVR1 and SEA-DC1.
3. Click **SEA-SVR1**, then **Firewall** in the left menu.
4. Check the profiles, then open **Incoming rules**. Sort by **Action** or search for the port.
5. Find **Windows Update Helper** on port 4444. Select it and click **Disable**.

Let's confirm on the server:

```powershell
Get-NetFirewallRule -DisplayName "Windows Update Helper" | Select DisplayName, Enabled
```

**Enabled: False**. The attacker's door is closed. Clean up by deleting the rule with `Remove-NetFirewallRule`.

> 📌 **2025 note.** For Arc-connected servers, WAC is also available right inside the Azure portal. You can do this review from Azure without opening any inbound port to the server.

## ✅ Key takeaway

During an incident, speed matters. Opening RDP to ten servers one by one takes forever. WAC shows you all of them from one browser tab.

---
[← Lab 5.2](lab-5.2-ipsec-connection-security.md) · [Chapter overview](README.md) · [Lab 6.1 →](../06-storage-encryption/lab-6.1-bitlocker-ad-recovery.md)
