# Lab 6.1: BitLocker with recovery keys in Active Directory

[← Lab 5.3](../05-networking/lab-5.3-firewall-review-wac.md) · [Chapter overview](README.md) · [Lab 6.2 →](lab-6.2-bitlocker-forced-recovery.md)

| | |
|---|---|
| **Attack** | Stolen disk or copied VHDX |
| **Control** | BitLocker with recovery keys stored in Active Directory |
| **Machines** | SEA-SVR1, SEA-DC1 |
| **Needs** | None (needs vTPM) |
| **Checkpoint first** | Yes, strongly recommended (can lock you out or stop a server booting) |
| **Scripts** | [`scripts/lab-6.1-bitlocker-ad-recovery.ps1`](../../scripts/lab-6.1-bitlocker-ad-recovery.ps1) |

## 🥷 Hacker scenario

A contractor copies the `.vhdx` file of SEA-SVR1 to a USB drive. At home, he double-clicks it and Windows mounts it. Every file share, database and config file with saved passwords is right there, readable.

## 📖 Concepts

**BitLocker** encrypts a whole volume. On a server you'll usually use **XTS-AES 256**, the strongest option.

The question is: where is the key, and how does the server unlock at boot? That's the job of **protectors**:

- **TPM**: a chip on the motherboard holds the key. It only releases it if the boot process hasn't been tampered with. The server boots without anyone typing anything.
- **TPM + PIN**: same, plus a PIN at startup. Stronger, but someone must type it. **Network Unlock** can do that automatically when the server is on the corporate network.
- **Recovery password**: a 48-digit number. Your emergency key when everything else fails.

That recovery password must be stored somewhere safe. With Group Policy, Windows can **back it up to Active Directory** automatically, on the computer object.

One more thing. BitLocker isn't installed by default on Windows Server. It's a **feature** you add.

## 🛡️ How this stops the attacker

The copied disk is AES-encrypted, and the key is sealed inside SEA-SVR1's TPM. When the contractor mounts it at home, Windows asks for a recovery key. He doesn't have one. The disk is useless to him.

## 🧪 Step by step

First, Group Policy. We tell Windows to back up the recovery key to AD **before** it encrypts anything.

1. On SEA-DC1, edit a GPO linked to the servers OU: *Computer Configuration > Policies > Administrative Templates > Windows Components > BitLocker Drive Encryption*.
2. Open **Operating System Drives > Choose how BitLocker-protected operating system drives can be recovered**. Enable it. Tick **Save BitLocker recovery information to AD DS** and **Do not enable BitLocker until recovery information is stored to AD DS**.
3. Open **Operating System Drives > Require additional authentication at startup**. Enable it and allow **TPM**.

To see the recovery keys in ADUC, add the BitLocker viewer on SEA-DC1:

```powershell
Install-WindowsFeature RSAT-Feature-Tools-BitLocker-BdeAducExt
```

Now install BitLocker on SEA-SVR1:

```powershell
Install-WindowsFeature BitLocker -IncludeAllSubFeature -IncludeManagementTools -Restart
```

The server reboots. Apply the GPO with `gpupdate /force`, then turn on BitLocker:

```powershell
Enable-BitLocker -MountPoint C: -EncryptionMethod XtsAes256 -UsedSpaceOnly -TpmProtector
Add-BitLockerKeyProtector -MountPoint C: -RecoveryPasswordProtector
```

The first command encrypts C: with the TPM as protector. `-UsedSpaceOnly` makes it much faster on a new server. The second command adds the 48-digit recovery password, which Group Policy sends to AD.

Let's check:

```powershell
manage-bde -status C:
```

You should see **Protection On** and **XTS-AES 256**. Now open ADUC on SEA-DC1, turn on **View > Advanced Features**, and open the **SEA-SVR1** computer. There's a new tab, **BitLocker Recovery**, with the recovery password inside.

One tip from the course recording: an error appeared because the GPO said *Do not allow TPM* while the server had no TPM. If BitLocker refuses to start, check that your startup settings don't contradict each other.

## ✅ Key takeaway

Servers get stolen. Disks get swapped and sent back under warranty. VM files get copied. Without encryption, whoever holds the disk reads everything.

---
[← Lab 5.3](../05-networking/lab-5.3-firewall-review-wac.md) · [Chapter overview](README.md) · [Lab 6.2 →](lab-6.2-bitlocker-forced-recovery.md)
