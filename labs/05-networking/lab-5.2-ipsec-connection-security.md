# Lab 5.2: IPsec connection security rules

[← Lab 5.1](lab-5.1-windows-firewall.md) · [Chapter overview](README.md) · [Lab 5.3 →](lab-5.3-firewall-review-wac.md)

| | |
|---|---|
| **Attack** | Man-in-the-middle / rogue laptop on the LAN |
| **Control** | IPsec connection security rules (domain isolation) |
| **Machines** | SEA-DC1, SEA-SVR1 |
| **Needs** | None |
| **Checkpoint first** | Yes, strongly recommended (can lock you out or stop a server booting) |
| **Scripts** | [`scripts/lab-5.2-ipsec-connection-security.ps1`](../../scripts/lab-5.2-ipsec-connection-security.ps1) |

## 🥷 Hacker scenario

The attacker plugs a laptop into a free network port in the meeting room. They run a **man-in-the-middle** attack between SEA-SVR1 and SEA-DC1, reading and changing the traffic. Or they simply try to connect to SEA-SVR1 directly from their laptop, which isn't a domain member.

## 📖 Concepts

Inside a LAN, most traffic is plain text. And any machine can talk to any machine. Not great.

**IPsec** fixes both problems. It has two protocols:

- **AH** (Authentication Header): proves **who** sent the packet and that nobody changed it. No encryption.
- **ESP** (Encapsulating Security Payload): **encrypts** the data, and can authenticate it too.

In Windows, you configure IPsec with **connection security rules**. Between two servers, we use **transport mode**: the original IP header stays, only the data is protected.

How do the two servers prove who they are? Usually with **Kerberos** (both are domain members) or **computer certificates**. Avoid pre-shared keys; they're easy to leak.

When two machines agree on IPsec, they create **security associations** (SAs). **Main mode** SA is where they authenticate each other. **Quick mode** SA is where they agree how to protect the data.

Using IPsec so only domain members can talk to each other is called **domain isolation**.

## 🛡️ How this stops the attacker

The man-in-the-middle sees only ESP-encrypted packets. They can't read them, and they can't forge authenticated ones. The rogue laptop has no domain Kerberos identity, so it can't even finish the IPsec negotiation. The connection is simply refused.

## 🧪 Step by step

We'll do this with a GPO, so both servers get the same rules.

1. On SEA-DC1, create a GPO called **IPsec-DC1-SVR1**. Link it to an OU that holds only the two test servers. Not the whole domain!

   > ⚠️ **Added by this repository:** a domain controller should stay in the **Domain Controllers** OU, so no single OU holds both machines. Link the GPO to **both** `Domain Controllers` and `Servers` (see [lab setup](../../docs/00-welcome-and-lab-setup.md#extra-setup-the-labs-assume)). Because the rule's endpoints are only `10.10.0.10` and `10.10.0.11`, it affects no other machine, but check *Group Policy Results* to be sure the GPO applies only to those two computers.
2. Edit it: *Computer Configuration > Policies > Windows Settings > Security Settings > Windows Defender Firewall with Advanced Security > Connection Security Rules > New Rule*.
3. Rule type: **Server-to-server**. Endpoint 1: **10.10.0.10** (SEA-DC1). Endpoint 2: **10.10.0.11** (SEA-SVR1).
4. Requirements: **Require authentication for inbound and outbound connections**.
5. Authentication method: **Advanced > Customize**. Under **First authentication**, add **Computer (Kerberos V5)**.
6. Profile: **Domain**. Name: **dc1-svr1-auth**.

That gives us authentication. Now let's require encryption:

1. In the same GPO, go to **Inbound Rules > New Rule > Custom**. All programs.
2. Scope: local IP **10.10.0.11**, remote IP **10.10.0.10**.
3. Action: **Allow the connection if it is secure**. Click **Customize** and choose **Require the connections to be encrypted**.
4. Profile **Domain**, name **dc1-svr1-encryption**.
5. Run `gpupdate /force` on both servers.

Now let's generate some traffic and look at the security associations. From SEA-DC1:

```powershell
Test-NetConnection SEA-SVR1 -Port 445
```

Then on SEA-SVR1:

```powershell
Get-NetIPsecMainModeSA
Get-NetIPsecQuickModeSA
```

The main mode SA shows **Kerberos** as the authentication method. The quick mode SA shows **ESP** with an encryption algorithm like **AES**. You can see the same thing in `wf.msc` under **Monitoring > Security Associations**.

One big tip: in production, start with **Request authentication** instead of **Require**. Check the SAs, then tighten. A wrong **Require** rule can cut a domain controller off from its servers. And that's not a fun phone call.

## ✅ Key takeaway

A firewall says who can connect. IPsec makes sure they really are who they claim, and that nobody can read the traffic in between.

---
[← Lab 5.1](lab-5.1-windows-firewall.md) · [Chapter overview](README.md) · [Lab 5.3 →](lab-5.3-firewall-review-wac.md)
