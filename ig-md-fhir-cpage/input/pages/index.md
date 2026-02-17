# IG FHIR CPage - Masterdata

**Version**: 0.1.0 | **Publié**: 2026-02-11 | **Statut**: Draft

## Bienvenue

Cet **Implementation Guide (IG) FHIR CPage** définit les profils et extensions **spécifiques à CPage** pour la gestion des Tiers dans le contexte Master Data Management (MDM).

Il **hérite de l'IG Tiers Générique** et ajoute les extensions métier issues des tables Oracle ECO (FOU, DBT).

## Architecture Multi-IG

```
┌──────────────────────────────────────────────┐
│  FR Core 2.1.0 (HL7 France)                 │
│  • fr-core-organization                      │
│  • Slices SIREN, SIRET, FINESS               │
└────────┬─────────────────────────────────────┘
         │
         ├─▶ ┌────────────────────────────────────┐
         │   │ IG Tiers Générique                 │
         │   │ • TiersOrganization                │
         │   │ • ExtTiersRole                     │
         │   └────────┬───────────────────────────┘
         │            │
         └────────────┴─▶ ┌──────────────────────────────┐
                          │ IG CPage (CE GUIDE)          │
                          │ • CPageSupplierOrganization  │
                          │ • CPageDebtorOrganization    │
                          │ • Extensions métier CPage    │
                          └──────────────────────────────┘
```

## Contenu de ce Guide

### [Profil Fournisseur CPage](supplier.html)

**CPageSupplierOrganization** : Profil pour les fournisseurs avec extensions ECO.FOU
- Validité, Zone Europe
- Comptabilité (classe 6 et classe 2)
- Conditions de paiement
- Marchés publics
- Chorus
- Flags internes

### [Profil Débiteur CPage](debtor.html)

**CPageDebtorOrganization** : Profil pour les débiteurs avec extensions ECO.DBT
- Validité, Zone Europe
- Résidence (Résident/Non-résident/Étranger)
- Compte tiers débiteur
- Paramètres ASAP
- Identifiant externe
- Fournisseur associé

### [Terminologies CPage](terminologies.html)

CodeSystems et ValueSets CPage :
- **CPageValidityCodeSystem** : Validité V/I
- **CPageResidencyCodeSystem** : Résidence R/N/E
- **CPageEUZoneCodeSystem** : Zone Europe F/O/A

### [Extensions CPage](extensions.html)

Documentation détaillée des 13 extensions CPage avec mapping Oracle ECO.FOU et ECO.DBT.

### [Mapping Oracle vers FHIR](mapping.html)

Guide complet de transformation des données Oracle ECO (FOU, DBT) vers les profils FHIR CPage.

## Dépendances

- **ig.mdm.fhir.common** : dev (IG Tiers générique)
- **hl7.fhir.fr.core** : 2.1.0 (via IG Tiers générique)

## Principe de Conception

✅ **Héritage de l'IG générique** - Réutilisation de TiersOrganization
✅ **Extensions métier CPage** - Reflet fidèle des tables ECO.FOU et ECO.DBT
✅ **Séparation des rôles** - Profils distincts pour fournisseur et débiteur
✅ **Traçabilité Oracle** - Mapping complet des champs sources
✅ **Interopérabilité** - Respect de FR Core et FHIR R4

## Liens Importants

- 📦 **IG Tiers Générique** : [ig-md-fhir-common](https://www.cpage.fr/ig/masterdata/tiers/)
- 📦 **Repository** : [github.com/NicolasMoreauCPage/mdm-igs](https://github.com/NicolasMoreauCPage/mdm-igs)
- 🇫🇷 **FR Core** : [hl7.fr/ig/fhir/core](https://hl7.fr/ig/fhir/core/)
- 📚 **FHIR R4** : [hl7.org/fhir](https://www.hl7.org/fhir/)

## Questions?

📧 **Contact** : contact@cpage.fr
🌐 **Web** : https://www.cpage.fr
