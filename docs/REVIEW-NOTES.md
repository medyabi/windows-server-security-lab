# Review notes for the author

The labs were converted from *How to Master Windows Server Security (AZ-801)* (the file `...(AutoRecovered).docx`, so check that it is the version you want to publish). The wording of the course is unchanged. This page lists what was **added**, what looks **inconsistent** in the original text (left as is, your call), and what to **verify** against current Microsoft documentation. **None of the commands was executed** while building this repository; the PowerShell files were only checked for syntax.

## 1. Added by this repository (marked ⚠️ in the labs)

| Where | What was added | Why |
|---|---|---|
| [Lab setup](00-welcome-and-lab-setup.md#extra-setup-the-labs-assume) | Hyper-V switch and static IP / DNS commands | The course gives IP addresses but no virtual switch |
| Lab setup | `Servers` OU and moving SEA-SVR1 into it | Labs 1.2, 1.3, 1.4, 3.1, 6.1 say "a GPO linked to the servers OU", but only the `Staff` OU is created |
| Lab setup | `Policies$` share | Labs 1.2 and 1.3 copy files to `\\SEA-DC1\Policies$`, which is never created |
| Lab setup | Lab dependency table | 4.2/4.3/4.4 need 4.1; 6.2 needs 6.1; 1.6 needs Arc; 3.3 must not use Protected Users accounts |
| Lab 2.1 | Lockout settings for the PSO; a **15-character** test | A PSO replaces the domain lockout settings too (the cmdlet's default threshold is 0, to verify); a 12-character test also fails because of the 14-character domain policy |
| Lab 5.2 | Note on where to link the GPO | A domain controller stays in *Domain Controllers*, so no single OU holds both servers |
| Every lab | Header table (attack, control, machines, needs, checkpoint), navigation links | Navigation and planning |
| Whole repo | README, chapter READMEs, Mermaid diagrams, `scripts/`, progress checklist, attack → control map | Structure |

## 2. Inconsistencies in the original text (not changed)

1. **Lab 2.1 vs Lab 1.1.** The Lab 2.1 scenario says Mohamed uses an 8-character password "which the domain policy allows", but Lab 1.1 sets the domain minimum to 14. Suggestion: reword the scenario (for example a 14-character password built from company words) or say Lab 2.1 assumes a weaker domain baseline.
2. **References to "the course" / "the recording" inside the text.** Lab 4.1's 2025 note says the course installs the old MMA agent, but the steps already use the Azure Monitor Agent. Lab 6.1 has "a tip from the course recording" and Lab 6.2's note says "the course mentions MBAM". These make sense in the video, not in a standalone text.
3. **Adam and John are created without `-Path`**, so they land in `CN=Users`, outside the `Staff` OU. Lab 3.2 relies on that ("Adam, who is outside the Staff OU"); say so explicitly if it is intended.
4. **Lab 2.3** puts Adam *and* John in Protected Users and keeps "one break-glass admin" outside: that is the built-in Administrator; name it.
5. **Lab 5.2** says to link the GPO to "an OU that holds only the two test servers": see section 1.

## 3. To verify against current documentation

| Lab | What to check |
|---|---|
| 1.3 | Name of the GPO setting (*Deploy Windows Defender Application Control* vs *Deploy App Control for Business*, depends on the ADMX version) and whether the single-policy `.p7b` deployment is still the recommended format on Windows Server 2025 |
| 1.4 | "Credential Guard is on by default for member servers" on Windows Server 2025 and the exact conditions |
| 2.2 | Licensing (Entra ID P1/P2), installer names, and whether the `AzureADPasswordProtection` module names changed |
| 4.1 / 4.2 / 4.3 | Table names. Lab 4.2 queries `Event` (Windows Event Logs through a basic DCR). The Sentinel connector *Windows Security Events via AMA* writes to `SecurityEvent`, where the equivalent query is `SecurityEvent \| where EventID == 4625 \| summarize Failures = count() by Computer, bin(TimeGenerated, 10m) \| where Failures > 20` |
| 4.3 / 4.4 | Sentinel moving into the Defender portal; recommendation names in Defender for Cloud |
| 6.3 | The Azure Disk Encryption retirement date quoted in the 2025 note (September 2028) |
| All Azure labs | Portal paths and trial availability change often |

## 4. Not covered on purpose

The labs simulate attacks with harmless commands only. There is **no** credential-dumping tool, exploit or malware in this repository. If you want a hands-on "red team" part (for example a Pass-the-Hash demonstration for Lab 1.4 in an isolated lab), decide first how far to go and add it in a separate, clearly labelled section.
