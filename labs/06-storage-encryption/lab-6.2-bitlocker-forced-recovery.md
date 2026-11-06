# Lab 6.2: Forcing BitLocker recovery

[← Lab 6.1](lab-6.1-bitlocker-ad-recovery.md) · [Chapter overview](README.md) · [Lab 6.3 →](lab-6.3-azure-disk-encryption.md)

| | |
|---|---|
| **Attack** | Lost recovery key (availability) |
| **Control** | Forced-recovery drill and key rotation |
| **Machines** | SEA-SVR1, SEA-DC1 |
| **Needs** | Lab 6.1 completed |
| **Checkpoint first** | Yes, strongly recommended (can lock you out or stop a server booting) |
| **Scripts** | [`scripts/lab-6.2-bitlocker-forced-recovery.ps1`](../../scripts/lab-6.2-bitlocker-forced-recovery.ps1) |

## 🥷 Hacker scenario

This time, the threat isn't someone breaking in. The only copy of the recovery key was a PDF on a file share. Ransomware encrypts that share. A week later, SEA-SVR1 gets a new motherboard and boots into recovery mode. Nobody can find the key. That's an attack on your **availability**, and it's just as real.

## 📖 Concepts

Sometimes the TPM refuses to release the key. A firmware update, a moved disk, a motherboard swap, a TPM reset. When that happens, the server boots into **recovery mode** and asks for the 48-digit recovery password.

The screen shows a **Key ID**. That ID tells you which recovery password you need, because a server can have more than one over time.

After you use a recovery password, it's "burned". Someone has seen it, so you should **rotate** it: create a new one and remove the old one.

## 🛡️ How this stops the attacker

The key is stored in AD, protected by AD permissions and replicated to every domain controller. Losing one file share, or one DC, doesn't lose the key. Only admins you delegated can read it.

## 🧪 Step by step

Take a checkpoint of SEA-SVR1 first. Seriously. Now let's force recovery:

```powershell
manage-bde -forcerecovery C:
Restart-Computer -Force
```

The first command tells BitLocker: "next boot, don't trust the TPM, ask for the recovery password".

Open the VM console. You see the blue **BitLocker recovery** screen with a **Key ID**. Write down the first 8 characters.

Now find the key:

1. On SEA-DC1, open ADUC. Right-click the domain and choose **Find BitLocker recovery password**.
2. Type the first 8 characters of the Key ID and click **Search**.
3. The recovery password appears. You can also find it on the **BitLocker Recovery** tab of the SEA-SVR1 computer object.

Type the 48 digits on the VM console. No copy-paste here, so type carefully. The server boots normally.

Now rotate the key, because this one has been seen:

```powershell
manage-bde -protectors -get C:
manage-bde -protectors -add C: -RecoveryPassword
manage-bde -protectors -delete C: -id "{old-protector-id}"
```

The first command lists the protectors and their IDs. The second adds a new recovery password, which goes to AD. The third removes the old one. Check ADUC: the new recovery password is there.

> 📌 **2025 note.** The course mentions **MBAM**. It's out of support since July 2024. Use AD DS on-premises, or **Intune** with **Entra ID** for cloud-managed devices.

## ✅ Key takeaway

If nobody can find the recovery password, the data is gone. Forever. This is a fire drill. You do it **before** the fire.

---
[← Lab 6.1](lab-6.1-bitlocker-ad-recovery.md) · [Chapter overview](README.md) · [Lab 6.3 →](lab-6.3-azure-disk-encryption.md)
