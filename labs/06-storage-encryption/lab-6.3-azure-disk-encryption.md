# Lab 6.3: Encrypting Azure VM disks

[← Lab 6.2](lab-6.2-bitlocker-forced-recovery.md) · [Chapter overview](README.md)

| | |
|---|---|
| **Attack** | Azure disk export by a rogue Contributor |
| **Control** | Azure Disk Encryption, customer-managed keys |
| **Machines** | Azure portal / Azure PowerShell |
| **Needs** | Azure subscription, Key Vault, a Windows Server 2025 Azure VM (costs apply) |
| **Checkpoint first** | Not applicable (Azure only): delete the resources when you are done to avoid costs |
| **Scripts** | [`scripts/lab-6.3-azure-disk-encryption.ps1`](../../scripts/lab-6.3-azure-disk-encryption.ps1) |

## 🥷 Hacker scenario

An attacker steals an account with the **Contributor** role on your Azure subscription. Contributor can't sign in to your VMs, so you feel safe. But it can manage the disks. The attacker creates a temporary download link for the OS disk of a VM, downloads the whole disk, and mounts it on their own laptop.

But wait, aren't Azure disks always encrypted? They are. And yet, the attacker can read every file. How is that possible? The answer is in *which* encryption you use, and *who* holds the key.

## 📖 Concepts

In Azure, nobody walks out with your server. But there are other risks: **disk exports**, **snapshots**, and people with too many rights on storage.

Azure has several encryption layers. Students mix them up a lot, so here's the whole picture in one table:

| Layer | What it protects | Who holds the key | Still encrypted after a disk export? |
|---|---|---|---|
| Server-side encryption (SSE), platform key | Data at rest in Azure storage | Microsoft | No |
| SSE with customer-managed key | Same, but you control and can revoke the key | You, in Key Vault, through a Disk Encryption Set | No |
| Encryption at host | Also the temp disk and caches, end to end on the host | Microsoft or you | No |
| Azure Disk Encryption (ADE) | BitLocker inside the guest OS | You, in Key Vault | Yes |

See the last column? That's the key point. SSE encrypts the data in storage, but when someone with the right permissions exports the disk, Azure decrypts it for them. With **ADE**, the disk is BitLocker-encrypted inside the VM, so the export is still encrypted.

Two more terms:

- **Key Vault**: the Azure service that stores keys and secrets.
- **Disk Encryption Set** (DES): links a Key Vault key to managed disks, for SSE with a customer-managed key. It's **not** used for ADE.

## 🛡️ How this stops the attacker

With ADE, the downloaded disk is still BitLocker-encrypted, and the key sits in a Key Vault the attacker can't access. With a customer-managed key, you can also **revoke** the key, and the disks become unreadable instantly.

## 🧪 Step by step

**Part 1: Azure Disk Encryption.**

1. Create a **Key Vault** in **seclab-rg**. Under **Access configuration**, tick **Azure Disk Encryption for volume encryption**.
2. In the Key Vault, go to **Keys > Generate/Import**. Name the key **ade-key**, type RSA, size 2048.
3. Create a Windows Server 2025 VM called **win1**, with one data disk. Make sure it's **running**.
4. Open the VM, go to **Disks > Additional settings** (or **Encryption**). Choose **OS and data disks**, select your Key Vault and **ade-key**, and save.

Prefer PowerShell? Here's the same thing:

```powershell
$kv  = Get-AzKeyVault -VaultName <your-vault> -ResourceGroupName seclab-rg
$key = Get-AzKeyVaultKey -VaultName $kv.VaultName -Name ade-key
Set-AzVMDiskEncryptionExtension -ResourceGroupName seclab-rg -VMName win1 -DiskEncryptionKeyVaultUrl $kv.VaultUri -DiskEncryptionKeyVaultId $kv.ResourceId -KeyEncryptionKeyUrl $key.Id -KeyEncryptionKeyVaultId $kv.ResourceId -VolumeType All
```

The first two lines grab the vault and the key. The last line installs the ADE extension in the VM, which turns on BitLocker for all volumes. The key-encryption key (KEK) wraps the BitLocker key, so it's never stored in plain text.

Let's check:

```powershell
Get-AzVMDiskEncryptionStatus -ResourceGroupName seclab-rg -VMName win1
```

**OsVolumeEncrypted** and **DataVolumesEncrypted** both say **Encrypted**. Connect to the VM and run `manage-bde -status`. Yes, it's plain BitLocker inside.

**Part 2: customer-managed key with a Disk Encryption Set.**

1. Go to **Disk Encryption Sets > Create**. Name it **seclab-des**, encryption type **Encryption at-rest with a customer-managed key**, and choose your Key Vault and a key.
2. Stop (deallocate) a VM. Open **Disks**, click the OS disk, go to **Encryption**, and choose **seclab-des**. Save, then start the VM.

On the disk's **Encryption** page you now see **customer-managed key**, with your key's name.

> 📌 **2025 note.** Microsoft announced that **Azure Disk Encryption will be retired in September 2028**, and recommends **encryption at host** for new VMs. Know how ADE works, but use encryption at host for new deployments. Check the date on Microsoft Learn before class; these things move.

## ✅ Key takeaway

You need to know which layer protects against which risk, and who holds the keys.

---
[← Lab 6.2](lab-6.2-bitlocker-forced-recovery.md) · [Chapter overview](README.md)
