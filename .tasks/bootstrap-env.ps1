# ==============================================================================
# LOREIN PRODUCTION SYSTEM - AUTOMATIC CONTEXT SWITCHER (STABILIZED)
# ==============================================================================
$ErrorActionPreference = "Stop"

$LoreinHome = Join-Path $env:USERPROFILE ".lorein"
$IdentityDir = Join-Path $LoreinHome "identities"

if (-not (Test-Path $IdentityDir)) { $null = New-Item -ItemType Directory -Force -Path $IdentityDir }

# 1. Génération des fichiers de configuration d'identité atomiques dans la sandbox centrale
Set-Content -Path "$IdentityDir\enterprise.config" -Value "[user]`n  name = Lorein Corporate Engineer`n  email = infrastructure@lorein.org`n[commit]`n  gpgsign = true" -Force
Set-Content -Path "$IdentityDir\community.config" -Value "[user]`n  name = Lorein Public Contributor`n  email = community@lorein.org" -Force

# 2. Configuration du Routeur Central de l'Espace Utilisateur (Double Patterning Universel)
$RouterContent = @(
    "# ==============================================================================",
    "# LOREIN CENTRAL ROUTER - AUTOMATIC CONTEXT SWITCHER",
    "# ==============================================================================",
    "",
    "# 1. Alignement strict du périmètre d'entreprise privé",
    "[includeIf ""gitdir/i:**/lorein/ecosystem-hub/**""]",
    "  path = ~/.lorein/identities/enterprise.config",
    "",
    "# 2. Alignement du pont communautaire public",
    "[includeIf ""gitdir/i:**/lorein/community-bridge/**""]",
    "  path = ~/.lorein/identities/community.config",
    "",
    "# 3. Alignement des modules esclaves - Pattern POSIX Standard (Linux/macOS/Termux)",
    "[includeIf ""gitdir/i:**/gov-work-**""]",
    "  path = ~/.lorein/identities/community.config",
    "",
    "# 4. Alignement des modules esclaves - Pattern Windows Natif (Résout l'asymétrie de lecteur)",
    "[includeIf ""gitdir/i:**/gov-work-**/**""]",
    "  path = ~/.lorein/identities/community.config"
)
Set-Content -Path "$LoreinHome\router.config" -Value ($RouterContent -join "`n") -Force

# 3. Inscription unique et réversible dans le .gitconfig global de la machine hôte
git config --global includeIf."gitdir/i:**/lorein*/".path "~/.lorein/router.config"
git config --global includeIf."gitdir/i:**/gov-work-*/".path "~/.lorein/router.config"

Write-Host "[SUCCESS] L'environnement Lorein centralisé a été configuré avec succès." -ForegroundColor Green
