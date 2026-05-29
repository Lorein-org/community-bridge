# ==============================================================================
# LOREIN L-TDD SYSTEM - TEST CASE: LAB-TEST-20260529-0001 (VERBOSE AUDIT)
# TARGET: LAB-TASK-20260529-ENV01 (Universal Userspace Sandbox Routing)
# ==============================================================================
$ErrorActionPreference = "Stop"

Write-Host "[L-TDD] Amorce de la simulation d'environnement fractale..." -ForegroundColor Cyan

$TestWorkspace = Join-Path $env:USERPROFILE ".lorein\tmp\sandbox_fixtures"
$PrivateHubDir = "$TestWorkspace\lorein\ecosystem-hub"
$PublicBridgeDir = "$TestWorkspace\lorein\community-bridge"
$IsolatedWorkerDir = "$TestWorkspace\gov-work-templates"
$ExternalPersonalDir = "$TestWorkspace\external-personal-project"

# Purge et création des environnements de simulation
if (Test-Path $TestWorkspace) { Remove-Item -Recurse -Force $TestWorkspace }
$null = New-Item -ItemType Directory -Force -Path $PrivateHubDir
$null = New-Item -ItemType Directory -Force -Path $PublicBridgeDir
$null = New-Item -ItemType Directory -Force -Path $IsolatedWorkerDir
$null = New-Item -ItemType Directory -Force -Path $ExternalPersonalDir

# Initialisation des dépôts Git locaux
foreach ($dir in @($PrivateHubDir, $PublicBridgeDir, $IsolatedWorkerDir, $ExternalPersonalDir)) {
    Set-Location $dir
    git init --template=/dev/null | Out-Null
}

# ------------------------------------------------------------------------------
# FONCTION D'AUDIT VERBEUX
# ------------------------------------------------------------------------------
function Audit-GitContext($ContextName, $Path) {
    Set-Location $Path
    Write-Host "`n--- AUDIT VERBEUX : $ContextName ---" -ForegroundColor Gray
    Write-Host "[CHEMIN RÉEL DOSSIER] : $Path" -ForegroundColor Gray
    
    # Extraction de l'origine de la configuration de l'email
    $EmailOrigin = (git config --list --show-origin | Select-String "user.email") -join "`n"
    Write-Host "[ORIGINE DETECTEE] :`n$EmailOrigin" -ForegroundColor DarkGray
    
    $email = (git config user.email) 2>$null
    if (-not $email) { $email = "not_set" }
    return $email
}

$EmailExternal = Audit-GitContext "Hors contexte Lorein" $ExternalPersonalDir
$EmailPrivate  = Audit-GitContext "Contexte Écosystème Privé" $PrivateHubDir
$EmailPublic   = Audit-GitContext "Contexte Pont Communauté" $PublicBridgeDir
$EmailIsolated = Audit-GitContext "Contexte Worker Isolé" $IsolatedWorkerDir

# Retour sécurisé sans suppression immédiate pour permettre l'inspection visuelle si besoin
Set-Location $PSScriptRoot

Write-Host "`n==================================================================" -ForegroundColor Cyan
Write-Host "[L-TDD] Résultat Final de l'évaluation :" -ForegroundColor Cyan
Write-Host "-> Hors contexte Lorein       : $EmailExternal"
Write-Host "-> Contexte Écosystème Privé  : $EmailPrivate" -ForegroundColor Yellow
Write-Host "-> Contexte Pont Communauté   : $EmailPublic" -ForegroundColor Blue
Write-Host "-> Contexte Worker Isolé      : $EmailIsolated" -ForegroundColor Magenta
Write-Host "==================================================================" -ForegroundColor Cyan

# ------------------------------------------------------------------------------
# ASSERTIONS MULTI-NIVEAUX
# ------------------------------------------------------------------------------
if ($EmailPrivate -eq "infrastructure@lorein.org" -and $EmailPublic -eq "community@lorein.org" -and $EmailIsolated -eq "community@lorein.org") {
    Write-Host "[VERT] SUCCÈS : L'architecture de routage fractale est validée." -ForegroundColor Green
    # Nettoyage uniquement en cas de succès complet
    Remove-Item -Recurse -Force $TestWorkspace
    exit 0
} else {
    Write-Host "[ROUGE] ÉCHEC : L'aiguillage de contextes n'est pas opérationnel." -ForegroundColor Red
    exit 1
}
