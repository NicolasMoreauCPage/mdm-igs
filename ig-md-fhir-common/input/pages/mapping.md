# Mapping GEF vers FHIR

Cette page documente les mappings complets entre les **interfaces GEF** (EFOU, KERD, EMAF) et les profils FHIR TiersProfile, FournisseurProfile, DebiteurProfile.

## Vue d'ensemble des interfaces GEF

L'interfaçage GEF (Gestion Économique et Financière) utilise 3 messages principaux :

| Message | Format | Direction | Contenu | Profil FHIR |
|---------|--------|-----------|---------|-------------|
| **EFOU** (Extraction Fournisseurs) | Fixe 262 caractères | Oracle ECO → GEF | Données fournisseurs (suppliers) | FournisseurProfile |
| **KERD** (Intégration Débiteurs) | CSV | GEF → Oracle ECO | Données débiteurs (debtors/buyers) | DebiteurProfile |
| **EMAF** (Extraction Marchés) | Fixe positions | Oracle ECO → GEF | Contrats fournisseurs | ⏳ Phase 4 (à venir) |

---

## Architecture de mapping

```
┌────────────────────────────────────────────────────────────────┐
│                     Oracle ECO Database                        │
│  ┌──────────────────┐  ┌──────────────────┐                   │
│  │  ECO.ETIER       │  │  ECO.FOU         │                   │
│  │  (Tiers pivot)   │  │  (Fournisseurs)  │                   │
│  └────────┬─────────┘  └──────────────────┘                   │
│           │                       │                             │
└───────────┼───────────────────────┼─────────────────────────────┘
            │                       │
            ↓ EFOU 262 chars        ↓ EMAF (Phase 4)
    ┌───────────────────────────────────────────┐
    │          GEF System                       │
    │  (Gestion Économique et Financière)       │
    └───────────────────────────────────────────┘
            ↓ KERD CSV
┌───────────────────────────────────────────────────────────────┐
│                  FHIR R4 Profiles                             │
│  ┌──────────────────┐  ┌──────────────────┐                  │
│  │ TiersProfile     │  │ FournisseurProfile│                  │
│  │ (Base GEF)       │  │ (EFOU-compliant) │                  │
│  └────────┬─────────┘  └──────────────────┘                  │
│           │                       │                            │
│           └───────────┬───────────┘                            │
│                       │                                        │
│           ┌───────────▼───────────┐                            │
│           │  DebiteurProfile     │                            │
│           │  (KERD-compliant)    │                            │
│           └──────────────────────┘                            │
└───────────────────────────────────────────────────────────────┘
```

---

## Mapping EFOU (Extraction Fournisseurs) → FournisseurProfile

### Spécifications EFOU

- **Format** : Texte fixe 262 caractères par enregistrement
- **Encodage** : ASCII 7 bits
- **Document** : Spécification INT.201.010
- **Direction** : Oracle ECO → GEF (export fournisseurs)

### Table de mapping EFOU positions → FHIR

| Position | Longueur | Champ EFOU | FHIR Path | Extension/Slice | Notes |
|----------|----------|------------|-----------|-----------------|-------|
| **1-4** | 4 | Type enregistrement | (metadata) | - | Toujours "EFOU" |
| **4-14** | 11 | Numéro fournisseur | `identifier[etierId].value` | etierId slice | Code interne ETIER.IDTITI |
| **15-17** | 3 | Code identifiant TG | `identifier.extension[gefType]` | GEFIdentifierTypeExtension | 01=SIRET, 02=SIREN, 03=FINESS, etc. (voir GEFIdentifierTypeCS) |
| **18-32** | 15 | Nom du fournisseur | `name` | - | Raison sociale principale |
| **33-49** | 17 | Complément nom | `alias[0]` | - | Nom complémentaire |
| **50-32** | 32 | Raison sociale | `alias[1]` | - | Autre alias (si différent de nom) |
| **82-38** | 38 | Adresse ligne 1 | `address.line[0]` | - | Voie, numéro |
| **120-26** | 26 | Adresse ligne 2 | `address.line[1]` | - | Complément adresse |
| **146-38** | 38 | Ville | `address.city` | - | Commune |
| **184-5** | 5 | Code postal | `address.postalCode` | - | CP français ou étranger |
| **189-3** | 3 | Code pays | `address.country` | - | ISO 3166-1 alpha-2 (FR, DE, etc.) |
| **192-14** | 14 | Téléphone | `telecom[].value` (system=phone) | - | Numéro téléphone principal |
| **206-14** | 14 | Fax | `telecom[].value` (system=fax) | - | Numéro fax (obsolète) |
| **220-40** | 40 | Email | `telecom[].value` (system=email) | - | Adresse email principale |
| **260-3** | 3 | (Réservé) | - | - | Champ GEF réservé |
| **223-14** | 14 | Code SIRET | `identifier[siret].value` | siret slice (si Type TG = 01) | SIRET 14 chiffres |
| **237-1** | 1 | Catégorie TG | `extension[tgCategory]` | GEFTGCategoryExtension | Codes 00-74 (voir GEFTGCategoryCS) |
| **238-2** | 2 | Nature juridique | `extension[legalNature]` | GEFLegalNatureExtension | Codes 00-11 (voir GEFLegalNatureCS) |
| **240-10** | 10 | Code comptable classe 6 | ⚠️ CPage IG | CPageFournisseurProfile | Spécifique CPage, non dans TiersProfile |
| **250-12** | 12 | Identifiant externe | ⚠️ CPage IG | CPageFournisseurProfile | Spécifique CPage |

### Exemple de mapping EFOU

#### Enregistrement EFOU (extrait)

```
EFOU0001234567801Centre Hospit...75001Paris      FR        0140123456    contact@chu.fr  12345678901234270910 ...
    └─┬─┘└────┬────┘└┬┘└──────┬──────┘...└──┬──┘└───┬───┘...└─────────┬────────┘└┬┘└┬┘...
    Type   N°fournisseur│  Nom        ...   CP    Pays     ...      SIRET       TG LN
                        01 (SIRET)
```

#### FournisseurProfile FHIR résultant

```json
{
  "resourceType": "Organization",
  "meta": {
    "profile": ["https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/fournisseur-profile"]
  },
  "identifier": [
    {
      "system": "urn:oid:1.2.250.1.999.1.1.1",
      "value": "0001234567",
      "type": {
        "coding": [{"system": "http://terminology.hl7.org/CodeSystem/v2-0203", "code": "RI"}]
      }
    },
    {
      "system": "urn:oid:1.2.250.1.24.3.2",
      "value": "12345678901234",
      "type": {
        "coding": [{"system": "http://terminology.hl7.org/CodeSystem/v2-0203", "code": "PRN"}]
      },
      "extension": [{
        "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/gef-identifier-type",
        "valueCodeableConcept": {
          "coding": [{
            "system": "https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/gef-identifier-type-cs",
            "code": "01",
            "display": "SIRET"
          }]
        }
      }]
    }
  ],
  "name": "Centre Hospitalier Universitaire",
  "address": [{
    "line": ["1 Avenue de l'Hôpital"],
    "city": "Paris",
    "postalCode": "75001",
    "country": "FR"
  }],
  "telecom": [
    {"system": "phone", "value": "0140123456"},
    {"system": "email", "value": "contact@chu.fr"}
  ],
  "extension": [
    {
      "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/tiers-role-extension",
      "valueCoding": {
        "system": "https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/tiers-role-cs",
        "code": "supplier"
      }
    },
    {
      "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/gef-tg-category",
      "valueCodeableConcept": {
        "coding": [{
          "system": "https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/gef-tg-category-cs",
          "code": "27",
          "display": "EPS"
        }]
      }
    },
    {
      "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/gef-legal-nature",
      "valueCodeableConcept": {
        "coding": [{
          "system": "https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/gef-legal-nature-cs",
          "code": "09",
          "display": "Collectivité territoriale-EPL-EPS"
        }]
      }
    }
  ]
}
```

---

## Mapping KERD (Intégration Débiteurs) → DebiteurProfile

### Spécifications KERD

- **Format** : CSV (Comma-Separated Values) avec séparateur ";"
- **Encodage** : ISO-8859-1 (Latin-1)
- **Document** : Spécification INT.300.960
- **Direction** : GEF → Oracle ECO (import débiteurs)

### Table de mapping KERD colonnes → FHIR

| Position CSV | Champ KERD | FHIR Path | Extension/Slice | Cardinality | Notes |
|--------------|------------|-----------|-----------------|-------------|-------|
| **1** | Code débiteur | `identifier[etierId].value` | etierId slice | 1..1 | Code interne ETIER.IDTITI |
| **2** | Type débiteur | `extension[debtorType]` | GEFDebtorTypeExtension | **1..1 MS** | **O** (Occasionnel) ou **N** (Normal), OBLIGATOIRE |
| **3-4** | Compte contrepartie (lettre + numéro) | `extension[publicAccountingCounterpart]` | GEFPublicAccountingCounterpartExtension | 0..1 | Complex: letterCode (A/B/C) + accountNumber (10 digits) |
| **5** | Nom débiteur | `name` | - | 1..1 | Raison sociale ou nom complet personne |
| **6** | Complément nom | `alias[0]` | - | 0..1 | Nom complémentaire |
| **7** | Code régie | `extension[regieCode]` | GEFRegieCodeExtension | 0..1 | Code régie secteur public (10 car max) |
| **8** | Catégorie TG | `extension[tgCategory]` | GEFTGCategoryExtension | 0..1 | Codes 00-74 (voir GEFTGCategoryCS) |
| **9** | Nature juridique | `extension[legalNature]` | GEFLegalNatureExtension | 0..1 | Codes 00-11 (voir GEFLegalNatureCS) |
| **10** | Civilité | `extension[personDetails].extension[civility]` | GEFPersonDetailsExtension | **0..1 (obligatoire si TG=01)** | M, MME, MLLE, METMME, MOUMME |
| **11** | Prénom | `extension[personDetails].extension[firstName]` | GEFPersonDetailsExtension | **0..1 (obligatoire si TG=01)** | Prénom personne physique (38 car max) |
| **12** | Adresse ligne 1 | `address.line[0]` | - | 0..1 | Voie, numéro |
| **13** | Adresse ligne 2 | `address.line[1]` | - | 0..1 | Complément adresse |
| **14** | Ville | `address.city` | - | 0..1 | Commune |
| **15** | Code postal | `address.postalCode` | - | 0..1 | CP français ou étranger |
| **16** | Localisation adresse | `address.extension[localization]` | GEFAddressLocalizationExtension | 0..1 | **FRANCE**, **EUROPE**, **AUTRE** |
| **17** | Type identifiant TG | `identifier.extension[gefType]` | GEFIdentifierTypeExtension | 0..1 | 01=SIRET, 02=SIREN, 03=FINESS, 04=NIR, etc. (voir GEFIdentifierTypeCS) |
| **18** | Identifiant TG | `identifier[*].value` | Slice déduit du type (siret/siren/finess/nir/tva/etc.) | 0..1 | Valeur identifiant (SIRET 14 car, NIR 15 car, etc.) |
| **19** | Code banque | `extension[bankAccount].extension[bankCode]` | GEFBankAccountExtension | **1..1 (au moins 1 bankAccount)** | Code banque RIB (5 car) |
| **20** | Code guichet | `extension[bankAccount].extension[branchCode]` | GEFBankAccountExtension | 0..1 | Code guichet RIB (5 car) |
| **21** | Numéro de compte | `extension[bankAccount].extension[accountNumber]` | GEFBankAccountExtension | 0..1 | Numéro compte RIB (11 car) |
| **22** | Clé RIB | `extension[bankAccount].extension[ribKey]` | GEFBankAccountExtension | 0..1 | Clé RIB (2 car) |
| **23** | IBAN | `extension[bankAccount].extension[iban]` | GEFBankAccountExtension | **1..1 (au moins 1 bankAccount)** | IBAN international (34 car max) |
| **24** | BIC | `extension[bankAccount].extension[bic]` | GEFBankAccountExtension | 0..1 | BIC/SWIFT (11 car) |
| **25** | Est débiteur laboratoire | `extension[debtorFlags].extension[isLaboratory]` | GEFDebtorFlagsExtension | 0..1 | Boolean O/N → true/false |
| **26** | Est débiteur locataire | `extension[debtorFlags].extension[isTenant]` | GEFDebtorFlagsExtension | 0..1 | Boolean O/N → true/false |
| **27** | Est débiteur agent | `extension[debtorFlags].extension[isAgent]` | GEFDebtorFlagsExtension | 0..1 | Boolean O/N → true/false |
| **28** | Numéro matricule agent | `extension[debtorFlags].extension[agentRegistrationNumber]` | GEFDebtorFlagsExtension | 0..1 | String (20 car max) |
| **29** | Type identifiant CHORUS | `identifier.extension[chorusIdentifierType]` | GEFChorusIdentifierTypeExtension | 0..1 | Codes 01-08 (subset de GEFIdentifierTypeCS, sans 09) |

### Exemple de mapping KERD

#### Enregistrement KERD CSV (extrait)

```csv
0001234567;N;A;4110000000;CH Marseille;;REG001;27;09;;;1 Rue Paradis;Bâtiment A;Marseille;13001;FRANCE;03;750712184;30002;00550;00000123456;11;FR7630006000011234567890789;BDFEFRPPCCT;N;N;N;;03
```

**Décomposition** :
- `0001234567` : Code débiteur → identifier[etierId].value
- `N` : Type débiteur Normal → extension[debtorType] = N
- `A` : Compte contrepartie lettre → extension[publicAccountingCounterpart].extension[letterCode] = "A"
- `4110000000` : Compte contrepartie numéro → extension[publicAccountingCounterpart].extension[accountNumber] = "4110000000"
- `CH Marseille` : Nom → name
- `REG001` : Code régie → extension[regieCode] = "REG001"
- `27` : Catégorie TG EPS → extension[tgCategory] = #27
- `09` : Nature juridique Collectivité → extension[legalNature] = #09
- `03` : Type identifiant FINESS → identifier[finess].extension[gefType] = #03
- `750712184` : FINESS → identifier[finess].value
- `FR76300...` : IBAN → extension[bankAccount].extension[iban]
- `BDFEFRPPCCT` : BIC → extension[bankAccount].extension[bic]
- `03` (fin) : Type identifiant CHORUS → identifier[finess].extension[chorusIdentifierType] = #03

#### DebiteurProfile FHIR résultant

```json
{
  "resourceType": "Organization",
  "meta": {
    "profile": ["https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/debiteur-profile"]
  },
  "identifier": [
    {
      "system": "urn:oid:1.2.250.1.999.1.1.1",
      "value": "0001234567",
      "type": {
        "coding": [{"system": "http://terminology.hl7.org/CodeSystem/v2-0203", "code": "RI"}]
      }
    },
    {
      "system": "https://finess.esante.gouv.fr",
      "value": "750712184",
      "type": {
        "coding": [{"system": "http://terminology.hl7.org/CodeSystem/v2-0203", "code": "FI"}]
      },
      "extension": [
        {
          "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/gef-identifier-type",
          "valueCodeableConcept": {
            "coding": [{
              "system": "https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/gef-identifier-type-cs",
              "code": "03",
              "display": "FINESS"
            }]
          }
        },
        {
          "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/gef-chorus-identifier-type",
          "valueCodeableConcept": {
            "coding": [{
              "system": "https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/gef-chorus-identifier-type-cs",
              "code": "03",
              "display": "FINESS"
            }]
          }
        }
      ]
    }
  ],
  "name": "CH Marseille",
  "address": [{
    "line": ["1 Rue Paradis", "Bâtiment A"],
    "city": "Marseille",
    "postalCode": "13001",
    "country": "FR",
    "extension": [{
      "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/gef-address-localization",
      "valueCode": "FRANCE"
    }]
  }],
  "extension": [
    {
      "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/tiers-role-extension",
      "valueCoding": {
        "system": "https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/tiers-role-cs",
        "code": "debtor"
      }
    },
    {
      "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/gef-debtor-type",
      "valueCode": "N"
    },
    {
      "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/gef-public-accounting-counterpart",
      "extension": [
        {"url": "letterCode", "valueString": "A"},
        {"url": "accountNumber", "valueString": "4110000000"}
      ]
    },
    {
      "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/gef-regie-code",
      "valueString": "REG001"
    },
    {
      "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/gef-tg-category",
      "valueCodeableConcept": {
        "coding": [{
          "system": "https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/gef-tg-category-cs",
          "code": "27",
          "display": "EPS"
        }]
      }
    },
    {
      "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/gef-legal-nature",
      "valueCodeableConcept": {
        "coding": [{
          "system": "https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/gef-legal-nature-cs",
          "code": "09",
          "display": "Collectivité territoriale-EPL-EPS"
        }]
      }
    },
    {
      "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/gef-bank-account",
      "extension": [
        {"url": "bankCode", "valueString": "30002"},
        {"url": "branchCode", "valueString": "00550"},
        {"url": "accountNumber", "valueString": "00000123456"},
        {"url": "ribKey", "valueString": "11"},
        {"url": "iban", "valueString": "FR7630006000011234567890789"},
        {"url": "bic", "valueString": "BDFEFRPPCCT"}
      ]
    },
    {
      "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/gef-debtor-flags",
      "extension": [
        {"url": "isLaboratory", "valueBoolean": false},
        {"url": "isTenant", "valueBoolean": false},
        {"url": "isAgent", "valueBoolean": false}
      ]
    }
  ]
}
```

---

## Mapping EMAF (Extraction Marchés Fournisseurs) → Phase 4

### Spécifications EMAF

- **Format** : Texte fixe positions (longueur totale à documenter)
- **Document** : Spécification INT.201.010 (section marchés)
- **Direction** : Oracle ECO → GEF (export contrats fournisseurs)
- **Statut** : ⏳ **Phase 4 en attente** (analyse ressource Contract FHIR)

### Champs identifiés EMAF (documentation préliminaire)

| Champ EMAF | FHIR Candidat | Notes |
|------------|---------------|-------|
| Code fournisseur | `Contract.subject` référence Organization (FournisseurProfile) | Lien fournisseur-contrat |
| Numéro marché | `Contract.identifier[marketNumber]` | Identifiant unique marché |
| Dates contrat (début, fin) | `Contract.period.start`, `Contract.period.end` | Période validité |
| Montant marché | `Contract.totalValue` (Money) | Montant total TTC |
| RIB marché | Extension custom ou `Contract.term.offer.party.extension` | RIB spécifique marché (si différent du RIB fournisseur principal) |
| Identifiant externe marché | `Contract.identifier[externalId]` | Identifiant dans système GEF |

**Action Phase 4** : 
1. Analyser spécification EMAF complète (positions, longueurs)
2. Décider : 
   - **Option A** : Créer ContratFournisseurProfile (extends Contract)
   - **Option B** : Extension complexe sur FournisseurProfile (MarketAssociationExtension)
3. Mapper tous les champs EMAF → FHIR Contract ou Extension
4. Créer instances de test (contract examples)

---

## Mapping Oracle ECO → FHIR (legacy)

Cette section documente le mapping Oracle ECO (système interne CPage) vers TiersProfile pour référence historique.

### Table ETIER → TiersProfile

| Champ Oracle | Type | FHIR Path | Notes |
|--------------|------|-----------|-------|
| **IDTITI** | VARCHAR2(10) | `identifier[etierId].value` | **Obligatoire**, identifiant unique interne |
| **CSINTI** | VARCHAR2(9) | `identifier[siren].value` | Slice FR Core, 9 chiffres |
| **CSIRTI** | VARCHAR2(14) | `identifier[siret].value` | Slice FR Core, 14 chiffres |
| **CFINTI** | VARCHAR2(9) | `identifier[finess].value` | Slice FR Core |
| **CNIRTI** | VARCHAR2(15) | `identifier[nir].value` | ⚠️ NIR très sensible, RGPD, utiliser avec précautions |
| **TVAITI** | VARCHAR2(20) | `identifier[tva].value` | TVA intracommunautaire |
| **NORSTI** | VARCHAR2(100) | `name` | **Obligatoire**, raison sociale |
| **COMPTI** | VARCHAR2(100) | `alias[0]` | Nom complémentaire |
| **VALITI** | CHAR(1) | `active` | V → true, I → false |
| **AL1STI** | VARCHAR2(50) | `address.line[0]` | Ligne d'adresse 1 |
| **AL2STI** | VARCHAR2(50) | `address.line[1]` | Ligne d'adresse 2 |
| **AL3STI** | VARCHAR2(50) | `address.line[2]` | Ligne d'adresse 3 |
| **CPOSTI** | VARCHAR2(10) | `address.postalCode` | Code postal |
| **BDISTI** | VARCHAR2(50) | `address.city` | Ville/Commune |
| **PAYSTI** | VARCHAR2(50) | `address.country` | Code pays (ISO 3166) |
| **TELETI** | VARCHAR2(20) | `telecom[].value` (system=phone) | Téléphone |
| **MAILTI** | VARCHAR2(100) | `telecom[].value` (system=email) | Email |
| **SITETI** | VARCHAR2(200) | `telecom[].value` (system=url) | Site web |

### Détermination des rôles (Tables FOU / DBT)

| Table | Condition | FHIR Extension | Code |
|-------|-----------|----------------|------|
| **ECO.FOU** | EXISTS (SELECT 1 FROM ECO.FOU WHERE IDTITI = :id) | `extension[tiersRole].valueCoding` | `supplier` |
| **ECO.DBT** | EXISTS (SELECT 1 FROM ECO.DBT WHERE IDTITI = :id) | `extension[tiersRole].valueCoding` | `debtor` |

#### Requête SQL complète

```sql
-- Transformer ECO.ETIER + FOU/DBT → TiersProfile
SELECT
    e.IDTITI,
    e.NORSTI AS name,
    e.COMPTI AS alias,
    e.CSINTI AS siren,
    e.CSIRTI AS siret,
    e.TVAITI AS tva,
    e.VALITI AS active_flag,
    e.AL1STI, e.AL2STI, e.AL3STI,
    e.CPOSTI, e.BDISTI, e.PAYSTI,
    e.TELETI, e.MAILTI, e.SITETI,
    CASE WHEN EXISTS (SELECT 1 FROM ECO.FOU WHERE IDTITI = e.IDTITI) THEN 'supplier' ELSE NULL END AS role_supplier,
    CASE WHEN EXISTS (SELECT 1 FROM ECO.DBT WHERE IDTITI = e.IDTITI) THEN 'debtor' ELSE NULL END AS role_debtor
FROM ECO.ETIER e
WHERE e.IDTITI = :tiers_id;
```

---

## Règles de transformation importantes

### 1. Identifiants GEF : Mapping Type → Slice

Le champ **Type identifiant TG** (EFOU position 15-17, KERD position 17) détermine le slice identifier :

| Code GEF | GEFIdentifierTypeCS | Slice identifier | System |
|----------|---------------------|------------------|--------|
| **01** | SIRET | identifier[siret] | urn:oid:1.2.250.1.24.3.2 |
| **02** | SIREN | identifier[siren] | urn:oid:1.2.250.1.24.3.1 |
| **03** | FINESS | identifier[finess] | https://finess.esante.gouv.fr |
| **04** | NIR | identifier[nir] | urn:oid:1.2.250.1.213.1.4.8 |
| **05** | TVA intracommunautaire | identifier[tva] | (Selon pays UE) |
| **06** | Hors UE | identifier[horsUE] | (Selon pays) |
| **07** | Tahiti | identifier[tahiti] | http://cpage.org/fhir/NamingSystem/tahiti-identifier |
| **08** | RIDET | identifier[ridet] | http://cpage.org/fhir/NamingSystem/ridet-identifier |
| **09** | En cours d'immatriculation | (À créer selon besoin) | - |

**Règle** : Lire le code TG, créer le slice correspondant, puis ajouter l'extension GEFIdentifierTypeExtension sur `identifier.extension[gefType]`.

### 2. Compte contrepartie comptabilité publique (KERD position 3-4)

Le champ KERD "Compte contrepartie" est **composé de 2 sous-champs** :
- **Lettre** (position 3, 1 caractère : A, B, C)
- **Numéro** (position 4, 10 caractères numériques)

**Transformation** :
```
KERD: "A;4110000000"
      ↓
FHIR: extension[publicAccountingCounterpart]
        .extension[letterCode].valueString = "A"
        .extension[accountNumber].valueString = "4110000000"
```

### 3. GEFPersonDetails obligatoire si Catégorie TG = 01

**Règle métier KERD** : Si Catégorie TG #01 (Personne physique), les champs position 10 (Civilité) et position 11 (Prénom) sont **OBLIGATOIRES**.

**Validation FHIR** :
```fsh
Profile: DebiteurProfile
* extension[personDetails] 0..1 MS
* extension[personDetails] ^short = "OBLIGATOIRE si Catégorie TG = 01"
// TODO: Ajouter FHIRPath invariant
// * obeys debtor-person-details-mandatory-if-tg-01
```

**FHIRPath invariant candidat** :
```
extension.where(url='gef-tg-category').valueCodeableConcept.coding.code = '01' 
  implies 
extension.exists(url='gef-person-details')
```

### 4. Compte bancaire (bankAccount) obligatoire pour débiteurs

**Règle KERD** : Tout débiteur **DOIT** avoir au moins un compte bancaire (IBAN minimum).

**Validation FHIR** :
```fsh
Profile: DebiteurProfile
* extension[bankAccount] 1..* MS // MANDATORY
* extension[bankAccount].extension[iban] 1..1 MS // IBAN obligatoire
```

**KERD positions 19-24** :
- Si **RIB complet** : 4 champs (bankCode, branchCode, accountNumber, ribKey) + IBAN + BIC
- Si **IBAN seul** (étranger UE) : Uniquement IBAN + BIC

### 5. Combinaison Catégorie TG + Nature juridique

Le module métier GEF valide les combinaisons autorisées (voir [Terminologies - Règles métier](terminologies.html#règles-métier-globales)).

**Validation recommandée** : Créer un FHIRPath invariant vérifiant les combinaisons légales :

```
// Exemple : Si Catégorie TG = 01 (Personne physique), Nature juridique doit être 00, 01 ou 02
extension.where(url='gef-tg-category').valueCodeableConcept.coding.code = '01'
  implies
extension.where(url='gef-legal-nature').valueCodeableConcept.coding.code.memberOf('00' | '01' | '02')
```

### 6. GEFChorusIdentifierType : Subset de GEFIdentifierType

**Attention** : GEFChorusIdentifierTypeCS utilise **uniquement les codes 01-08** (exclut le code 09 "En cours d'immatriculation").

**Règle** : Sur les débiteurs publics (EPS, collectivités) interfacés avec CHORUS, utiliser GEFChorusIdentifierTypeExtension au lieu de GEFIdentifierTypeExtension pour qualification CHORUS-spécifique.

---

## Couverture de mapping

### EFOU (Extraction Fournisseurs)

| Statut | Champs | Mapping FHIR |
|--------|--------|--------------|
| ✅ **Complet** | Positions 1-262 | FournisseurProfile + extensions Phase 1 |
| ⚠️ **Partiel CPage** | Positions 240-262 | Nécessite CPageFournisseurProfile (IG dérivé) |

**Positions non mappées dans TiersProfile** (spécifiques CPage) :
- Position 240-10 : Code comptable classe 6 → CPageFournisseurProfile.extension[accountingClass6]
- Position 250-12 : Identifiant externe → CPageFournisseurProfile.extension[externalId]

### KERD (Intégration Débiteurs)

| Statut | Champs | Mapping FHIR |
|--------|--------|--------------|
| ✅ **Complet** | Positions 1-29 CSV | DebiteurProfile + extensions Phase 1 + Phase 2 |
| ✅ **Complet** | Banking (RIB/IBAN) | GEFBankAccountExtension (6 sub-extensions) |
| ✅ **Complet** | Comptabilité publique | GEFPublicAccountingCounterpartExtension, GEFRegieCodeExtension, GEFChorusIdentifierTypeExtension |
| ✅ **Complet** | Personne physique | GEFPersonDetailsExtension (civility + firstName) |
| ✅ **Complet** | Flags métier | GEFDebtorFlagsExtension (isLaboratory, isTenant, isAgent, agentRegistrationNumber) |

**Tous les champs KERD sont mappés** (0 champs non mappés dans ig-md-fhir-common).

### EMAF (Extraction Marchés Fournisseurs)

| Statut | Analyse |
|--------|---------|
| ⏳ **Phase 4** | Spécifications en cours d'analyse |
| ⏳ **Décision** | Contract resource vs Extension custom |
| ⏳ **Mapping** | À définir (positions, longueurs, champs) |

---

## Liens vers ressources FHIR

### Profils
- **TiersProfile** : [StructureDefinition](StructureDefinition-tiers-profile.html)
- **FournisseurProfile** (EFOU) : [StructureDefinition](StructureDefinition-fournisseur-profile.html)
- **DebiteurProfile** (KERD) : [StructureDefinition](StructureDefinition-debiteur-profile.html)

### Extensions Phase 1 (Fondations)
- **GEFIdentifierTypeExtension** : [StructureDefinition](StructureDefinition-gef-identifier-type.html)
- **GEFBankAccountExtension** : [StructureDefinition](StructureDefinition-gef-bank-account.html)
- **GEFTGCategoryExtension** : [StructureDefinition](StructureDefinition-gef-tg-category.html)
- **GEFLegalNatureExtension** : [StructureDefinition](StructureDefinition-gef-legal-nature.html)
- **TiersRoleExtension** : [StructureDefinition](StructureDefinition-tiers-role-extension.html)

### Extensions Phase 2 (Débitorat)
- **GEFDebtorTypeExtension** : [StructureDefinition](StructureDefinition-gef-debtor-type.html)
- **GEFPublicAccountingCounterpartExtension** : [StructureDefinition](StructureDefinition-gef-public-accounting-counterpart.html)
- **GEFRegieCodeExtension** : [StructureDefinition](StructureDefinition-gef-regie-code.html)
- **GEFChorusIdentifierTypeExtension** : [StructureDefinition](StructureDefinition-gef-chorus-identifier-type.html)
- **GEFDebtorFlagsExtension** : [StructureDefinition](StructureDefinition-gef-debtor-flags.html)
- **GEFPersonDetailsExtension** : [StructureDefinition](StructureDefinition-gef-person-details.html)
- **GEFAddressLocalizationExtension** : [StructureDefinition](StructureDefinition-gef-address-localization.html)

### Terminologies
- [Terminologies GEF (8 CodeSystems)](terminologies.html)

### Instances de test
- [ExempleFournisseurEPS](Organization-ExempleFournisseurEPS.html) (EFOU: SIRET + RIB)
- [ExempleFournisseurTVA](Organization-ExempleFournisseurTVA.html) (EFOU: TVA UE + IBAN)
- [ExempleDebiteurPersonnePhysique](Organization-ExempleDebiteurPersonnePhysique.html) (KERD: NIR + Civilité)
- [ExempleDebiteurEPSPublic](Organization-ExempleDebiteurEPSPublic.html) (KERD: FINESS + comptabilité publique)
- [ExempleFournisseurRIDET](Organization-ExempleFournisseurRIDET.html) (EFOU: RIDET NC)

---

**Documentation mise à jour** : 23 février 2026  
**Couverture** : EFOU 100% (hors CPage), KERD 100%, EMAF Phase 4
