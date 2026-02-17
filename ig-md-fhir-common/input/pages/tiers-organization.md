# Profil TiersOrganization

## Vue d'ensemble

**TiersOrganization** est le profil générique basé sur **FR Core Organization** pour représenter un tiers (organisation, fournisseur, débiteur) dans le contexte Master Data Management (MDM).

## Héritage

```
Organization (FHIR R4)
    ↓
fr-core-organization (FR Core 2.1.0)
    ↓
TiersOrganization (ce profil)
```

## Ce que FR Core apporte

TiersOrganization **hérite automatiquement** de FR Core Organization :

### Slices identifier

| Slice | System | Format | Description |
|-------|--------|--------|-------------|
| `siren` | `https://sirene.fr` | 9 chiffres | Numéro SIREN |
| `siret` | `https://sirene.fr` | 14 chiffres | Numéro SIRET |
| `finess` | `http://finess.sante.gouv.fr` | Variable | Identifiant FINESS |

Ces slices sont **déjà validés et contraints** par FR Core (format, cardinalité).

## Ce que TiersOrganization ajoute

### Nouveaux slices identifier

| Slice | System | Type | Description | Source Oracle |
|-------|--------|------|-------------|---------------|
| `etierId` | `urn:oid:1.2.250.1.999.1.1.1` | RI (Resource identifier) | Identifiant interne ETIER | ECO.ETIER.IDTITI |
| `tva` | `urn:oid:1.2.250.1.999.1.1.5` | TAX (Tax ID) | TVA intracommunautaire | ECO.ETIER.TVAITI |

### Extension tiersRole

**Extension** : `ExtTiersRole`
- **URL** : `https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/ext-tiers-role`
- **Cardinalité** : 0..*
- **Type** : Coding
- **ValueSet** : TiersRoleValueSet (supplier | debtor)

Cette extension permet de qualifier le(s) rôle(s) métier d'un tiers.

## Structure complète du profil

### Identifiants

```
identifier:
  - [etierId] (1..1 MS) : Identifiant interne ETIER
  - [siren] (0..1 MS) : SIREN (hérité FR Core)
  - [siret] (0..1 MS) : SIRET (hérité FR Core)
  - [finess] (0..1 MS) : FINESS (hérité FR Core)
  - [tva] (0..1 MS) : TVA intracommunautaire
```

### Éléments de base

| Élément | Cardinalité | Description | Source Oracle |
|---------|-------------|-------------|---------------|
| `name` | 1..1 MS | Raison sociale | ECO.ETIER.NORSTI |
| `alias` | 0..* MS | Nom complémentaire | ECO.ETIER.COMPTI |
| `active` | 0..1 MS | Tiers actif/inactif | ECO.ETIER.VALITI (V=true, I=false) |
| `address` | 0..* MS | Adresse du siège | AL1STI, AL2STI, AL3STI, CPOSTI, BDISTI, PAYSTI |
| `telecom` | 0..* MS | Contacts | TELETI, MAILTI, SITETI |

### Extension rôle

```
extension[tiersRole]:
  - valueCoding.system = "https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/tiers-role-codesystem"
  - valueCoding.code in { "supplier", "debtor" }
```

## Exemple

```json
{
  "resourceType": "Organization",
  "meta": {
    "profile": ["https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/tiers-organization"]
  },
  "identifier": [
    {
      "type": { "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/v2-0203", "code": "RI" }] },
      "system": "urn:oid:1.2.250.1.999.1.1.1",
      "value": "000123"
    },
    {
      "type": { "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/v2-0203", "code": "PRN" }] },
      "system": "https://sirene.fr",
      "value": "123456789"
    },
    {
      "type": { "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/v2-0203", "code": "PRN" }] },
      "system": "https://sirene.fr",
      "value": "12345678900012"
    },
    {
      "type": { "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/v2-0203", "code": "TAX" }] },
      "system": "urn:oid:1.2.250.1.999.1.1.5",
      "value": "FR12345678901"
    }
  ],
  "name": "ACME Médical",
  "alias": ["ACME"],
  "active": true,
  "telecom": [
    { "system": "phone", "value": "0123456789", "use": "work" },
    { "system": "email", "value": "contact@acme.test", "use": "work" }
  ],
  "address": [{
    "use": "work",
    "type": "both",
    "line": ["10 rue de l'Hôpital"],
    "postalCode": "75000",
    "city": "Paris",
    "country": "FR"
  }],
  "extension": [{
    "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/ext-tiers-role",
    "valueCoding": {
      "system": "https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/tiers-role-codesystem",
      "code": "supplier"
    }
  }]
}
```

## Usage

### Créer un tiers fournisseur

1. Instanciez Organization avec le profil TiersOrganization
2. Ajoutez `identifier[etierId]` obligatoire
3. Ajoutez les identifiants nationaux (SIREN/SIRET) si disponibles
4. Qualifiez avec `extension[tiersRole] = #supplier`

### Créer un tiers débiteur

1. Même structure que fournisseur
2. Qualifiez avec `extension[tiersRole] = #debtor`

### Tiers multi-rôle

Un tiers peut être à la fois fournisseur et débiteur :

```json
"extension": [
  {
    "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/ext-tiers-role",
    "valueCoding": { "system": "...", "code": "supplier" }
  },
  {
    "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/ext-tiers-role",
    "valueCoding": { "system": "...", "code": "debtor" }
  }
]
```

## Liens

- **Profil FHIR** : [TiersOrganization](StructureDefinition-tiers-organization.html)
- **Extension tiersRole** : [ExtTiersRole](StructureDefinition-ext-tiers-role.html)
- **FR Core Organization** : [fr-core-organization](https://hl7.fr/ig/fhir/core/StructureDefinition-fr-core-organization.html)
