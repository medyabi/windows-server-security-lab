# Lab 2.1: Fine-grained password policy
# Snippets copied from labs/02-hybrid-ad-accounts/lab-2.1-fine-grained-password-policy.md
# Run them ONE BY ONE, on the machine named in the comment above each block. Do not run this file as a whole.
# Lab environment only: never run on production systems.

# First, put Mohamed in the Accounting group:
Add-ADGroupMember Accounting -Members Mohamed

# Prefer PowerShell? Here you go:
New-ADFineGrainedPasswordPolicy -Name Accounting-PSO -Precedence 10 -MinPasswordLength 16 -ComplexityEnabled $true -PasswordHistoryCount 24
Add-ADFineGrainedPasswordPolicySubject Accounting-PSO -Subjects Accounting

# Let's check which policy Mohamed really gets:
Get-ADUserResultantPasswordPolicy Mohamed
