# Mapping Oracle ECO vers FHIR

Cette page documente le mapping complet entre les tables Oracle ECO (schéma Master Data) et le profil FHIR TiersOrganization.

## Architecture Oracle ECO

```
┌──────────────────────────────┐
│  ECO.ETIER (Pivot Tiers)     │
│  • IDTITI (PK)               │
│  • NORSTI (raison sociale)   │
│  • CSINTI (SIREN)            │
│  • CSIRTI (SIRET)            │
│  • TVAITI (TVA)              │
│  • VALITI (validité)         │
│  • Adresses, contacts...     │
└──────────┬───────────────────┘
           │
           ├──▶ ECO.FOU (Rôle Fournisseur)
           │    • IDTITI (FK)
           │    • Données métier fournisseur
           │
           └──▶ ECO.DBT (Rôle Débiteur)
                • IDTITI (FK)
                • Données métier débiteur
```

---

## Table ETIER → TiersOrganization

### Identifiants

| Champ Oracle | Type | FHIR Target | Notes |
|--------------|------|-------------|-------|
| **IDTITI** | VARCHAR2(10) | `identifier[etierId].value` | **Obligatoire**, identifiant unique interne |
| **CSINTI** | VARCHAR2(9) | `identifier[siren].value` | Slice FR Core, 9 chiffres |
| **CSIRTI** | VARCHAR2(14) | `identifier[siret].value` | Slice FR Core, 14 chiffres |
| **CFINTI** | VARCHAR2(9) | `identifier[finess].value` | Slice FR Core |
| **CNIRTI** | VARCHAR2(15) | ⚠️ À éviter | NIR très sensible, RGPD |
| **TVAITI** | VARCHAR2(20) | `identifier[tva].value` | TVA intracommunautaire |

#### Exemple de mapping

```sql
-- Oracle ECO.ETIER
SELECT
    IDTITI,      -- "000123"
    CSINTI,      -- "123456789"
    CSIRTI,      -- "12345678900012"
    TVAITI       -- "FR12345678901"
FROM ECO.ETIER
WHERE IDTITI = '000123';
```

```json
// FHIR TiersOrganization
{
  "identifier": [
    {
      "system": "urn:oid:1.2.250.1.999.1.1.1",
      "type": { "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/v2-0203", "code": "RI" }] },
      "value": "000123"
    },
    {
      "system": "https://sirene.fr",
      "type": { "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/v2-0203", "code": "PRN" }] },
      "value": "123456789"
    },
    {
      "system": "https://sirene.fr",
      "type": { "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/v2-0203", "code": "PRN" }] },
      "value": "12345678900012"
    },
    {
      "system": "urn:oid:1.2.250.1.999.1.1.5",
      "type": { "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/v2-0203", "code": "TAX" }] },
      "value": "FR12345678901"
    }
  ]
}
```

### Données de base

| Champ Oracle | Type | FHIR Target | Notes |
|--------------|------|-------------|-------|
| **NORSTI** | VARCHAR2(100) | `name` | **Obligatoire**, raison sociale |
| **COMPTI** | VARCHAR2(100) | `alias[0]` | Nom complémentaire |
| **VALITI** | CHAR(1) | `active` | V → true, I → false |

#### Exemple

```sql
SELECT
    NORSTI,   -- "ACME Médical"
    COMPTI,   -- "ACME"
    VALITI    -- "V"
FROM ECO.ETIER
WHERE IDTITI = '000123';
```

```json
{
  "name": "ACME Médical",
  "alias": ["ACME"],
  "active": true
}
```

### Adresse

| Champ Oracle | Type | FHIR Target | Notes |
|--------------|------|-------------|-------|
| **AL1STI** | VARCHAR2(50) | `address.line[0]` | Ligne d'adresse 1 |
| **AL2STI** | VARCHAR2(50) | `address.line[1]` | Ligne d'adresse 2 |
| **AL3STI** | VARCHAR2(50) | `address.line[2]` | Ligne d'adresse 3 |
| **CPOSTI** | VARCHAR2(10) | `address.postalCode` | Code postal |
| **BDISTI** | VARCHAR2(50) | `address.city` | Ville/Commune |
| **PAYSTI** | VARCHAR2(50) | `address.country` | Code pays (ISO 3166) |

#### Exemple

```sql
SELECT
    AL1STI,   -- "10 rue de l'Hôpital"
    AL2STI,   -- "Bâtiment A"
    AL3STI,   -- NULL
    CPOSTI,   -- "75000"
    BDISTI,   -- "Paris"
    PAYSTI    -- "FR"
FROM ECO.ETIER
WHERE IDTITI = '000123';
```

```json
{
  "address": [{
    "use": "work",
    "type": "both",
    "line": ["10 rue de l'Hôpital", "Bâtiment A"],
    "postalCode": "75000",
    "city": "Paris",
    "country": "FR"
  }]
}
```

### Contacts

| Champ Oracle | Type | FHIR Target | Notes |
|--------------|------|-------------|-------|
| **TELETI** | VARCHAR2(20) | `telecom[].value` (system=phone) | Téléphone |
| **MAILTI** | VARCHAR2(100) | `telecom[].value` (system=email) | Email |
| **SITETI** | VARCHAR2(200) | `telecom[].value` (system=url) | Site web |

#### Exemple

```sql
SELECT
    TELETI,   -- "0123456789"
    MAILTI,   -- "contact@acme.test"
    SITETI    -- "https://acme.test"
FROM ECO.ETIER
WHERE IDTITI = '000123';
```

```json
{
  "telecom": [
    { "system": "phone", "value": "0123456789", "use": "work" },
    { "system": "email", "value": "contact@acme.test", "use": "work" },
    { "system": "url", "value": "https://acme.test" }
  ]
}
```

---

## Tables FOU / DBT → Extension tiersRole

### Détermination des rôles

| Table | Condition | FHIR Extension | Code |
|-------|-----------|----------------|------|
| **ECO.FOU** | EXISTS (SELECT 1 FROM ECO.FOU WHERE IDTITI = :id) | `extension[tiersRole]` | `supplier` |
| **ECO.DBT** | EXISTS (SELECT 1 FROM ECO.DBT WHERE IDTITI = :id) | `extension[tiersRole]` | `debtor` |

### Requête SQL complète

```sql
-- Déterminer les rôles d'un tiers
SELECT
    e.IDTITI,
    CASE WHEN EXISTS (SELECT 1 FROM ECO.FOU WHERE IDTITI = e.IDTITI) THEN 'supplier' ELSE NULL END AS role_supplier,
    CASE WHEN EXISTS (SELECT 1 FROM ECO.DBT WHERE IDTITI = e.IDTITI) THEN 'debtor' ELSE NULL END AS role_debtor
FROM ECO.ETIER e
WHERE e.IDTITI = '000123';
```

### Exemple FHIR

```json
{
  "extension": [
    {
      "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/ext-tiers-role",
      "valueCoding": {
        "system": "https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/tiers-role-codesystem",
        "code": "supplier",
        "display": "Fournisseur"
      }
    },
    {
      "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/ext-tiers-role",
      "valueCoding": {
        "system": "https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/tiers-role-codesystem",
        "code": "debtor",
        "display": "Débiteur"
      }
    }
  ]
}
```

---

## Champs Oracle non mappés dans l'IG générique

Les champs suivants de ECO.ETIER ne sont **pas mappés** dans TiersOrganization car trop spécifiques :

| Champ | Raison | Où le mapper |
|-------|--------|--------------|
| EUROTI | Spécifique CPage | IG CPage : ExtCPageEUZone |
| ROLETI | Obsolète(mono-rôle) | Remplacé par FOU/DBT |
| NOPATI | Trop spécifique santé | IG métier si nécessaire |

Ces champs doivent être gérés dans les **IGs dérivés** (comme IG CPage).

---

## Exemple complet de transformation

### Données Oracle

```sql
SELECT * FROM ECO.ETIER WHERE IDTITI = '000123';
-- IDTITI: 000123
-- NORSTI: ACME Médical
-- COMPTI: ACME
-- CSINTI: 123456789
-- CSIRTI: 12345678900012
-- TVAITI: FR12345678901
-- VALITI: V
-- AL1STI: 10 rue de l'Hôpital
-- CPOSTI: 75000
-- BDISTI: Paris
-- PAYSTI: FR
-- TELETI: 0123456789
-- MAILTI: contact@acme.test

-- Rôles
SELECT IDTITI FROM ECO.FOU WHERE IDTITI = '000123'; -- EXISTS → supplier
SELECT IDTITI FROM ECO.DBT WHERE IDTITI = '000123'; -- NOT EXISTS
```

### Ressource FHIR résultante

Voir l'exemple complet dans la page [Profil TiersOrganization](tiers-organization.html#exemple).

---

## Implémentation

### Serveur FHIR → Oracle

Lors de la création/mise à jour d'une Organization via FHIR :

1. Extraire `identifier[etierId].value` → `ETIER.IDTITI`
2. Mapper les champs standard → colonnes ETIER
3. Si `extension[tiersRole]` contient `supplier` → insérer/mettre à jour ECO.FOU
4. Si `extension[tiersRole]` contient `debtor` → insérer/mettre à jour ECO.DBT

### Oracle → Serveur FHIR

Lors de l'exposition d'un tiers via FHIR :

1. Lire ECO.ETIER
2. Mapper vers TiersOrganization
3. Déterminer rôles via EXISTS dans FOU/DBT
4. Ajouter extensions tiersRole

---

## Liens

- **Profil TiersOrganization** : [Documentation](tiers-organization.html)
- **Extension tiersRole** : [StructureDefinition](StructureDefinition-ext-tiers-role.html)
- **Terminologies** : [Documentation](terminologies.html)
