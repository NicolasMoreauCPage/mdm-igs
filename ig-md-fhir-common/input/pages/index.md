# IG FHIR Tiers Générique - CPage MasterData

**Version**: 0.1.0 | **Publié**: 2026-02-11 | **Statut**: Draft

## Bienvenue

Cet **Implementation Guide (IG) FHIR Tiers Générique** définit les profils et ressources de base pour la gestion des **Tiers** (organisations, fournisseurs, débiteurs) dans le contexte du Master Data Management (MDM) de CPage.

Ce guide est **vendor-neutral** et réutilisable, basé sur **FR Core Organization**, et sert de socle pour des IG spécialisés.

## Architecture

Ce projet suit une **architecture multi-IG en 2 niveaux**:

```
┌──────────────────────────────────────────────┐
│  FR Core 2.1.0 (HL7 France)                 │
│  • fr-core-organization                      │
│  • Slices SIREN, SIRET, FINESS               │
└────────┬─────────────────────────────────────┘
         │
         ├─▶ ┌────────────────────────────────────┐
         │   │ IG Tiers Générique (ce guide)     │
         │   │ • TiersOrganization (generic)      │
         │   │ • Identifiant ETIER interne        │
         │   │ • TVA intracommunautaire           │
         │   │ • Rôles génériques (fournisseur/   │
         │   │   débiteur)                         │
         │   └────────┬───────────────────────────┘
         │            │
         └────────────┴─▶ ┌──────────────────────────────┐
                          │ IG CPage (spécialisé)        │
                          │ • CPageSupplierOrganization  │
                          │ • CPageDebtorOrganization    │
                          │ • Extensions métier CPage    │
                          │ • Chorus, comptabilité, ASAP │
                          └──────────────────────────────┘
```

## Contenu de ce Guide

### [Profil TiersOrganization](tiers-organization.html)

Profil générique basé sur FR Core Organization pour représenter un tiers (organisation, fournisseur, débiteur).
- Hérite des slices SIREN, SIRET, FINESS de FR Core
- Ajoute l'identifiant interne ETIER et la TVA intracommunautaire
- Extension pour les rôles génériques (fournisseur/débiteur)

### [Terminologies](terminologies.html)

CodeSystems et ValueSets pour qualifier les rôles des tiers :
- **TiersRoleCodeSystem** : Codes supplier/debtor
- **TiersRoleValueSet** : Ensemble de valeurs pour les rôles

### [Mapping Oracle ECO](mapping.html)

Guide de mapping complet entre les tables Oracle ECO (ETIER, FOU, DBT) et les profils FHIR :
- Table ETIER → TiersOrganization
- Tables FOU/DBT → Rôles (extension tiersRole)

## Comment Utiliser ce Guide

### Pour les Implémenteurs

1. Consultez le [profil TiersOrganization](tiers-organization.html) pour comprendre la structure de base
2. Référez-vous aux [terminologies](terminologies.html) pour les rôles
3. Utilisez le [guide de mapping](mapping.html) pour vos intégrations Oracle

### Pour les Architectes

1. Comprenez l'architecture FR Core → Tiers générique → Spécialisé
2. Planifiez vos extensions spécifiques dans un IG enfant (comme [IG CPage](https://www.cpage.fr/ig/masterdata/cpage/))
3. Réutilisez TiersOrganization comme socle
4. Maintenez la séparation générique / spécifique

## Principe de Conception

✅ **Interopérabilité** - Basé sur FR Core Organization (standard français)
✅ **Réutilisabilité** - Profil générique vendor-neutral
✅ **Extensibilité** - Servir de socle pour des IG spécialisés (CPage)
✅ **Clean FHIR** - Identifiants nationaux dans slices, pas en extensions
✅ **Simplicité** - Seulement l'essentiel commun ici

## Liens Importants

- 📦 **Repository**: [github.com/NicolasMoreauCPage/mdm-igs](https://github.com/NicolasMoreauCPage/mdm-igs)
- 🔗 **IG Spécialisé CPage**: [ig-md-fhir-cpage](https://www.cpage.fr/ig/masterdata/cpage/)
- 🇫🇷 **FR Core**: [hl7.fr/ig/fhir/core](https://hl7.fr/ig/fhir/core/)
- 📚 **FHIR R4**: [hl7.org/fhir](https://www.hl7.org/fhir/)

## Questions?

Contactez l'équipe CPage: [contact@cpage.fr](mailto:contact@cpage.fr)
