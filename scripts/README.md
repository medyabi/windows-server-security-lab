# Scripts

Every command and KQL query of the labs, one file per lab: `lab-N.M-<name>.ps1` (PowerShell) and `.kql` (Kusto).

- Each block starts with the sentence of the lab that introduces it, as a comment. That sentence tells you **on which machine** to run it (SEA-DC1, SEA-SVR1, SEA-CL1 or the Azure portal).
- They are **snippets to run one by one** while you follow the lab, not scripts to run as a whole. Several steps need a reboot, a GPO refresh or a portal action in between.
- **Lab environment only.** Several commands lock accounts, change boot behaviour or force BitLocker recovery. Take a checkpoint first.
- The PowerShell files were checked with the PowerShell parser (no syntax errors). They have **not been executed** by the repository's author tooling: test them in your lab.
- Placeholders to replace: the tenant UPN in Lab 2.2, the Key Vault name in Lab 6.3, `{old-protector-id}` in Lab 6.2.
