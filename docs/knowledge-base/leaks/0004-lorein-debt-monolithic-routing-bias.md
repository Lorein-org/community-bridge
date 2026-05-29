---
id: LAB-DEBT-20260529-0004
title: RISQUE D'ACTIVATION ACCIDENTELLE PAR MOT-CLÉ MONOLITHIQUE
status: LOGGED
severity: CRITICAL
---

## DETTE TECHNIQUE 0004 : RISQUE D'ACTIVATION ACCIDENTELLE PAR MOT-CLÉ MONOLITHIQUE

## 1. CARACTÉRISATION DE LA DETTE

L'architecture initiale basait l'inclusion du bouclier Lorein sur la simple présence globale du mot-clé `**/lorein/**`. Cette modélisation crée un biais de faux positifs critiques : n'importe quel dossier personnel externe nommé arbitrairement `lorein` déclencherait l'application des politiques d'entreprise, provoquant une fuite d'identité ou un blocage cryptographique GPG.

## 2. IMPACT SUR LE CQFD ET LA SCALABILITÉ

- **Qualité :** Alignement non étanche des contextes bornés (Bounded Contexts) du Domain-Driven Design.
- **Scalabilité :** Incapacité à isoler des règles GPG strictes pour le cœur privé (`ecosystem-hub`) et des configurations légères pour les workers de la communauté (`gov-work-*`) clonés de manière indépendante.
