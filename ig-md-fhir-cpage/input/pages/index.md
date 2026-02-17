# IG FHIR CPage - Masterdata

**Version**: 0.1.0 | **Publié**: 2026-02-11 | **Statut**: Draft

## Bienvenue

Cet **Implementation Guide (IG) FHIR CPage** définit les profils et extensions **spécifiques à CPage** pour la gestion des Tiers dans le contexte Master Data Management (MDM).

Il **hérite de l'IG Tiers Générique** et ajoute les extensions métier issues des tables Oracle ECO (FOU, DBT).

## Architecture Multi-IG

Cet IG s'appuie sur une **architecture multi-niveaux** :

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
         │   │ • Identifiants nationaux + ETIER   │
         │   └────────┬───────────────────────────┘
         │            │
         └────────────┴─▶ ┌──────────────────────────────┐
                          │ IG CPage (CE GUIDE)          │
                          │ • CPageSupplierOrganization  │
                          │ • CPageDebtorOrganization    │
                          │ • Extensions métier CPage    │
                          │ • Validité, Zone EU, Résidence
                          │ • Chorus, Comptabilité, ASAP │
                          └──────────────────────────────┘
```

## Profils Principaux

### **CPageSupplierOrganization** (Fournisseur)

Profil CPage pour un tiers fournisseur. Hérite de **TiersOrganization** et ajoute les extensions issues de la table **ECO.FOU**.

**Extensions ajoutées** :
- `ExtCPageValidity` : Validité du fournisseur (VALIFO : V/I)
- `ExtCPageEUZone` : Zone Europe (EUROTI : F/O/A)
- `ExtCPageSupplierAccountingClass6` : Comptabilité classe 6 (LBU6FO, CPT6FO)
- `ExtCPageSupplierAccountingClass2` : Comptabilité classe 2 (LBU2FO, CPT2FO)
- `ExtCPageSupplierPaymentTerms` : Conditions de paiement (DEPAFO, JOSPFO, MTMIFO)
- `ExtCPageSupplierPublicProcurement` : Marchés publics (TCMPFO, GACHFO, ESCOFO)
- `ExtCPageSupplierChorus` : Informations Chorus (CHORFO, TIDCFO, IDCHFO)
- `ExtCPageSupplierInternalFlags` : Flags internes (EXTRFO, MAJ_FO)

### **CPageDebtorOrganization** (Débiteur)

Profil CPage pour un tiers débiteur. Hérite de **TiersOrganization** et ajoute les extensions issues de la table **ECO.DBT**.

**Extensions ajoutées** :
- `ExtCPageValidity` : Validité du débiteur (INVADT : V/I)
- `ExtCPageEUZone` : Zone Europe (EUROTI : F/O/A)
- `ExtCPageDebtorResidency` : Résidence (RESIDT : R/N/E)
- `ExtCPageDebtorAccount` : Compte tiers débiteur (LBTIDT, CPTIDT)
- `ExtCPageDebtorAsap` : Paramètres ASAP (ASAPDT, FCENDT)
- `ExtCPageDebtorExternalId` : Identifiant externe (IDEXDT)
- `ExtCPageDebtorAssociatedSupplier` : Fournisseur associé (NUFODT)

## Terminologies CPage

### CodeSystems

| CodeSystem | Codes | Description |
|------------|-------|-------------|
| **CPageValidityCodeSystem** | V, I | Validité d'un tiers CPage (Valide/Invalide) |
| **CPageResidencyCodeSystem** | R, N, E | Résidence d'un débiteur (Résident/Non-résident/Étranger) |
| **CPageEUZoneCodeSystem** | F, O, A | Zone Europe (France/Europe hors France/Autre) |

### ValueSets

- **CPageValidityValueSet** : Tous codes de CPageValidityCodeSystem
- **CPageResidencyValueSet** : Tous codes de CPageResidencyCodeSystem
- **CPageEUZoneValueSet** : Tous codes de CPageEUZoneCodeSystem

## Extensions Détaillées

### Extensions Communes

| Extension | Champs source | Description |
|-----------|---------------|-------------|
| **ExtCPageValidity** | VALITI, INVADT, VALIFO | Code validité V/I |
| **ExtCPageEUZone** | EUROTI | Zone Europe F/O/A |

### Extensions Fournisseur (FOU)

| Extension | Champs source | Description |
|-----------|---------------|-------------|
| **ExtCPageSupplierAccountingClass6** | LBU6FO, CPT6FO | Lettre budgétaire + compte classe 6 |
| **ExtCPageSupplierAccountingClass2** | LBU2FO, CPT2FO | Lettre budgétaire + compte classe 2 |
| **ExtCPageSupplierPaymentTerms** | DEPAFO, JOSPFO, MTMIFO | Délai paiement, jour spécifique, montant min |
| **ExtCPageSupplierPublicProcurement** | TCMPFO, GACHFO, ESCOFO | Marchés publics, groupement, escomptable |
| **ExtCPageSupplierChorus** | CHORFO, TIDCFO, IDCHFO | Assujetti Chorus + identifiants |
| **ExtCPageSupplierInternalFlags** | EXTRFO, MAJ_FO | Extractible, modifié depuis extraction |

### Extensions Débiteur (DBT)

| Extension | Champs source | Description |
|-----------|---------------|-------------|
| **ExtCPageDebtorResidency** | RESIDT | Résidence R/N/E |
| **ExtCPageDebtorAccount** | LBTIDT, CPTIDT | Lettre budgétaire + compte débiteur |
| **ExtCPageDebtorAsap** | ASAPDT, FCENDT | Désactiver ASAP, forcer impression CEN |
| **ExtCPageDebtorExternalId** | IDEXDT | Identifiant externe pour interfaces |
| **ExtCPageDebtorAssociatedSupplier** | NUFODT | Référence vers Organization fournisseur |

## Structure du Guide

| Section | Contenu |
|---------|---------|
| **Accueil** | Vue d'ensemble de l'IG CPage |
| **Artefacts** | Tous les profils, extensions, CodeSystems et ValueSets CPage |
| **IG Commun** | Lien vers l'IG Tiers générique parent |
| **Téléchargements** | Paquets et ressources téléchargeables |

## Comment Utiliser ce Guide

### Pour les Implémenteurs CPage

1. **Comprenez l'héritage** depuis IG Tiers générique (TiersOrganization)
2. **Choisissez le profil** :
   - CPageSupplierOrganization pour les fournisseurs (ECO.FOU)
   - CPageDebtorOrganization pour les débiteurs (ECO.DBT)
3. **Mappez vos données Oracle** vers les extensions CPage
4. **Utilisez les CodeSystems CPage** pour validité, résidence, zone EU
5. **Référencez les exemples** disponibles dans l'IG

### Mapping Détaillé Oracle → FHIR

**Base (hérité de TiersOrganization)** :
- ETIER.IDTITI → `identifier[etierId].value`
- ETIER.NORSTI → `name`
- ETIER.CSINTI → `identifier[siren].value` (FR Core)
- ETIER.CSIRTI → `identifier[siret].value` (FR Core)

**Fournisseur (ECO.FOU)** :
- FOU.VALIFO → `extension[cpageValidity].valueCoding`
- FOU.LBU6FO, FOU.CPT6FO → `extension[accountingClass6]`
- FOU.DEPAFO → `extension[paymentTerms].extension[paymentDelayDays]`
- FOU.CHORFO → `extension[chorus].extension[subjectToChorus]`

**Débiteur (ECO.DBT)** :
- DBT.INVADT → `extension[cpageValidity].valueCoding`
- DBT.RESIDT → `extension[residency].valueCoding`
- DBT.LBTIDT, DBT.CPTIDT → `extension[debtorAccount]`
- DBT.NUFODT → `extension[associatedSupplier].valueReference`

## Dépendances

- **ig.mdm.fhir.common** : dev (IG Tiers générique)
- **hl7.fhir.fr.core** : 2.1.0 (via IG Tiers générique)

## Exemple : Fournisseur CPage

```json
{
  "resourceType": "Organization",
  "meta": {
    "profile": ["https://www.cpage.fr/ig/masterdata/cpage/StructureDefinition/cpage-supplier-organization"]
  },
  "identifier": [{
    "system": "urn:oid:1.2.250.1.999.1.1.1",
    "type": { "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/v2-0203", "code": "RI" }] },
    "value": "000777"
  }, {
    "system": "https://sirene.fr",
    "type": { "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/v2-0203", "code": "PRN" }] },
    "value": "987654321"
  }],
  "name": "Fournitures Santé SAS",
  "active": true,
  "extension": [
    {
      "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/ext-tiers-role",
      "valueCoding": { "system": "https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/tiers-role-codesystem", "code": "supplier" }
    },
    {
      "url": "https://www.cpage.fr/ig/masterdata/cpage/StructureDefinition/ext-cpage-validity",
      "valueCoding": { "system": "https://www.cpage.fr/ig/masterdata/cpage/CodeSystem/cpage-validity-codesystem", "code": "V" }
    },
    {
      "url": "https://www.cpage.fr/ig/masterdata/cpage/StructureDefinition/ext-cpage-supplier-chorus",
      "extension": [{
        "url": "subjectToChorus",
        "valueBoolean": true
      }, {
        "url": "chorusIdentifier",
        "valueString": "98765432100012"
      }]
    }
  ]
}
```

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