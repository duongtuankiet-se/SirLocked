# Security and safe development

## Report a vulnerability

Use GitHub private vulnerability reporting when available, or contact the
maintainer privately. Do not put credentials, session tokens, or private user
data in public issues, pull requests, screenshots, or logs.

## Keep credentials out of Git

- Keep provider keys, database credentials, JWT secrets, SMTP passwords and
  Google client secrets in local environment files or deployment secret stores.
- Commit only example configuration with empty values or explicit placeholders.
- Do not commit captured login responses, room-session JSON or browser storage.
  Generate those locally as needed. Temporary scripts can remain in `tmp/`,
  but captured session JSON is intentionally absent from version control.
- `.gitignore` does not protect files already tracked by Git. Review `git diff
  --cached` before committing.
- Old credentials remain exposed in old commits until history is cleaned.
  Rotate a real leaked credential first; deleting a file is not revocation.
- Keep backup bundles private and outside published artifacts. They may contain
  the original sensitive history.

## Scan locally

Install Gitleaks 8.30.1 or newer from the
[official releases](https://github.com/gitleaks/gitleaks/releases), verifying the
release checksum. The repository configuration extends the built-in rules and
allows only reviewed example strings, test sentinels and a scoped report hash.
It does not exclude test folders from scanning.

From the repository root:

```powershell
./scripts/scan-secrets.ps1
./scripts/scan-secrets.ps1 -Staged
```

To use a binary outside PATH:

```powershell
./scripts/scan-secrets.ps1 -GitleaksPath 'C:\tools\gitleaks.exe'
```

An optional pre-commit hook scans staged changes after local opt-in:

```bash
git config --local core.hooksPath .githooks
```

CI independently scans the full reachable Git history on pushes and pull
requests. It downloads a pinned Gitleaks version, verifies the published
checksum and redacts findings. No provider key is needed for the scanner.
Enable GitHub secret scanning, push protection and Dependabot where supported.

## Before deploying an Internet-facing instance

- Use Production, HTTPS and trusted reverse-proxy configuration. Never use demo
  passwords or historical example JWT secrets for real accounts.
- Keep MongoDB private. The bundled Docker Compose configuration is for local
  development and requires network/authentication hardening before deployment.
- Review dependency advisories and update compatible versions; run build/tests
  after upgrades. Secret scanning does not replace dependency auditing.
- Review browser token storage, OAuth callback handling, token lifetimes and
  logout revocation before production use.
- Verify AI quotas, budget reservations and provider limits before enabling
  paid generation. Keep text/image/video keys on the backend.

This document and secret-scanning CI are safeguards, not a claim that every
deployment configuration or vulnerability has been audited.
