# TECHNICAL DEBT: SHELL REDIRECTION FOR MULTILINE CONFIGURATION INJECTION

## DEBT METADATA

- **Debt ID:** LAB-DEBT-20260529-0002
- **Category:** Maintainability / Code Readability
- **Source Component:** .tasks/env.task.yaml (generate-switcher task)
- **Estimated Remediation Effort:** Low (1 Sprint)

## CONTEXT & CURRENT STATIONS

The configuration routing switcher engine relies on hardcoded string appending operations (`echo "..." >> file`).
This pattern was introduced to isolate Git INI bracket tokens from the native Go-Task YAML parser engine.
While functionally robust, this mechanism increases structural verbosity and reduces template flexibility.

## RISK ANALYSIS

As the ecosystem scales, introducing new multi-line enterprise routing logic will require extensive shell chaining.
This setup increases the risk of platform interpretation drift between Windows Git Bash and native Linux shells.

## REMEDIATION PLAN

During Phase 3 architectural revisions, the configuration block will be moved to an external asset directory.
The `generate-switcher` task will be updated to use a stateless token-replacement routine (`envsubst` or native Go-Task templates).
This will decouple file templates from execution tasks.
