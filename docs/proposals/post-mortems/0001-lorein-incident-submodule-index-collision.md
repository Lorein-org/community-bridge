# POST-MORTEM: SUBMODULE INDEX COLLISION AND POWERSHELL ALIAS CONFLICT

## INCIDENT METADATA

- **Incident ID:** LAB-PM-20260529-0001
- **Severity:** High (Repository Architecture Corruption)
- **Impacted Component:** Core Repository Index (submodules/gov-work-registry)
- **Resolution Status:** Fixed

## SYMPTOMS & DIAGNOSIS

The downstream governance submodule `gov-work-registry` was mistakenly committed to the master repository as a standard flat text directory instead of a formal cryptographic submodule link.
When attempting to purge the directory via terminal commands, the shell threw a validation exception: `Remove-Item : Impossible de trouver un paramètre correspondant au nom « rf »`.
Subsequent attempts to force-readd the submodule were blocked by Git core components: `fatal: 'submodules/gov-work-registry' already exists and is not a valid git repo`.

## ROOT CAUSE ANALYSIS (RCA)

1. **Index Type Collision:** Committing files inside a subdirectory before registering it via `git submodule add` converts the path descriptor to a standard tree object in the Git index, blocking subsequent submodule mapping.
2. **Interpreter Command Conflict:** Windows PowerShell maps the alias `rm` to `Remove-Item`. This command crashes when encountering Linux flag syntaxes (`-rf`), leaving dirty modules cache targets in `.git/modules/`.

## RESOLUTION & MITIGATION ACTIONS

The workspace index was scrubbed using system-native clean operations:

- Forced cache eviction was completed via `git rm --cached`.
- The stale directory allocation inside `.git\modules\` was safely deleted via native Windows PowerShell commands (`Remove-Item -Recurse -Force`).
- The physical path collision was cleared from disk, enabling `git submodule add --force` to successfully establish the clean SHA-1 link to the origin repository.
