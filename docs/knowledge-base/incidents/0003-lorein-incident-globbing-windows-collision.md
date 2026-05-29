---
id: LAB-PM-20260529-0003
title: COLLISION D'INTERPRÉTATION DU GLOBBING CONDITIONNEL GIT SOUS WINDOWS
status: RESOLVED
author: Lorein Engineer
date: 2026-05-29
---

## INCIDENT 0003 : COLLISION D'INTERPRÉTATION DU GLOBBING CONDITIONNEL GIT SOUS WINDOWS

## 1. CONTEXTE ET SYMPTOMES

Lors de l'implémentation du routage d'environnement décentralisé dans l'espace utilisateur, le filtre natif `[includeIf "gitdir/i:**/gov-work-**"]` fonctionnait parfaitement sur les environnements POSIX (Linux/Termux), mais échouait silencieusement sous l'OS hôte Windows. Les terminaux esclaves isolés refusaient de charger l'identité `community@lorein.org` et conservaient l'identité globale de la machine.

## 2. ANALYSE DES CAUSES RACINES (ROOT CAUSE ANALYSIS)

Le moteur de configuration interne de Git en C normalise différemment les chemins sous Windows. L'expression de globbing `**/` échoue à capturer le jeton lorsque le chemin physique commence par une lettre de lecteur non résolue (ex: `C:`) ou des antislashs `\` convertis dynamiquement par PowerShell. L'évaluation séquentielle en RAM ignorait le scope.

## 3. ACTIONS DE REMÉDIATION IMMÉDIATE

- Déploiement d'un script d'audit verbeux `test-env-routing.ps1` utilisant la commande brute `git config --list --show-origin` pour forcer la traçabilité des fichiers sources.
- Implémentation du patron de conception Double Patterning Universel au sein du routeur.
