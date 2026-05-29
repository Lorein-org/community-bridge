# TECHNICAL DEBT: DESTRUCTIVE REPOSITORY PURGE FOR SUBMODULE INDEX REALIGNMENT

## DEBT METADATA

- **Debt ID:** LAB-DEBT-20260529-0002
- **Category:** Structural Maintenance / Automation Tooling
- **Source Component:** Core Repository Indexing Framework
- **Estimated Remediation Effort:** Medium (1 Sprint)

## CONTEXT & INCIDENT CORRELATION

During the repository migration and path renaming operations for the `gov-work-registry` component, a critical index collision occurred.
The master repository track logged the submodule directory path as a standard flat folder tree instead of a clean commit SHA-1 pointer hash link.
The remediation path implemented under incident `LAB-PM-20260529-0001` required a manual destructive removal of the local target directory.
This manual removal was forced using the PowerShell sequence `Remove-Item -Recurse -Force`.

## ENGINEERING INEFFICIENCY & RISK ANALYSIS

Relying on destructive directory purges introduces severe operational flaws:

1. High risk of absolute local data loss if the contributor has uncommitted work or untracked changes inside the workspace.
2. High cognitive friction for external community workers who lack expert-level internal Git plumbing knowledge.
3. Total interruption of local-first automated build executions, forcing full network re-clones that waste bandwidth.

## REMEDIATION ARCHITECTURE STRATEGY

This technical debt registers the formal intention to engineer a stateless, non-destructive alignment task within the automation suite.
The target component will be titled `task env:realign-submodules`.
The routine will utilize Git plumbing low-level commands (`git read-tree`, `git checkout-index`, and raw index filtering) to forcefully transform directory node metadata directly in the Git cache.
This adjustment will fix broken repository pointer definitions while leaving the local physical files completely untouched.
