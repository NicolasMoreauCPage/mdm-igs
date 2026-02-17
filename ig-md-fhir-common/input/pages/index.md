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

## Profil Principal

### **TiersOrganization**

Profil générique basé sur **FR Core Organization** pour représenter un tiers (organisation, fournisseur, débiteur).

**Hérite de FR Core** :
- ✅ `identifier[siren]` : SIREN (9 chiffres)
- ✅ `identifier[siret]` : SIRET (14 chiffres)
- ✅ `identifier[finess]` : FINESS

**Ajoute** :
- `identifier[etierId]` : Identifiant interne ETIER (IDTITI)
- `identifier[tva]` : TVA intracommunautaire (TVAITI)
- `extension[tiersRole]` : Rôle(s) générique(s) - fournisseur (supplier) / débiteur (debtor)

**Champs de base** :
- `name` : Raison sociale (NORSTI)
- `alias` : Nom complémentaire (COMPTI)
- `address` : Adresse du siège
- `telecom` : Contacts (téléphone, email)
- `active` : Tiers actif/inactif (VALITI)

## Terminologies

### CodeSystem : TiersRole

Rôles génériques d'un tiers :

| Code | Libellé | Description |
|------|---------|-------------|
| `supplier` | Fournisseur | Le tiers est un fournisseur |
| `debtor` | Débiteur | Le tiers est un débiteur |

### ValueSet : TiersRoleValueSet

Ensemble de valeurs pour les rôles de tiers (inclut tous les codes de TiersRoleCodeSystem).

## Extensions

### ExtTiersRole

Extension pour qualifier le(s) rôle(s) d'un tiers :
- **Contexte** : Organization
- **Cardinalité** : 0..*
- **Type** : Coding (from TiersRoleValueSet)
- **Usage** : Permet d'indiquer qu'une organisation est fournisseur, débiteur, ou les deux

## Structure du Guide

| Section | Contenu |
|---------|---------|
| **Accueil** | Vue d'ensemble de l'IG |
| **Artefacts** | Tous les profils, extensions, CodeSystems et ValueSets |
| **Téléchargements** | Paquets et ressources téléchargeables |

## Comment Utiliser ce Guide

### Pour les Implémenteurs

1. **Implémentez TiersOrganization** pour représenter vos organisations / tiers
2. **Utilisez les slices FR Core** pour les identifiants nationaux (SIREN/SIRET/FINESS)
3. **Ajoutez vos identifiants internes** via `identifier[etierId]`
4. **Qualifiez les rôles** via `extension[tiersRole]`
5. **Héritez et enrichissez** pour vos besoins spécifiques (voir IG CPage)

### Pour les Architectes

1. Comprenez l'architecture FR Core → Tiers générique → Spécialisé
2. Planifiez vos extensions spécifiques dans un IG enfant
3. Réutilisez TiersOrganization comme socle
4. Maintenez la séparation générique / spécifique

### Mapping Tables Oracle ECO

**Table ETIER** (pivot tiers) :
- `IDTITI` → `identifier[etierId].value`
- `NORSTI` → `name`
- `COMPTI` → `alias`
- `CSINTI` → `identifier[siren].value` (FR Core)
- `CSIRTI` → `identifier[siret].value` (FR Core)
- `CFINTI` → `identifier[finess].value` (FR Core)
- `TVAITI` → `identifier[tva].value`
- `VALITI` → `active` (V=true, I=false)
- `AL1STI, AL2STI, AL3STI, CPOSTI, BDISTI, PAYSTI` → `address`
- `TELETI, MAILTI` → `telecom`

**Tables FOU / DBT** (rôles) :
- Présence dans `ECO.FOU` → `extension[tiersRole].valueCoding = #supplier`
- Présence dans `ECO.DBT` → `extension[tiersRole].valueCoding = #debtor`

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