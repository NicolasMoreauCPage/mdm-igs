# Établissements CPage - Extensions Spécialisées

## Contexte CPage

Ce document décrit les extensions spécifiques à CPage pour la modélisation des établissements de santé. Ces extensions enrichissent le **Profil Établissement Commun** avec des données de localisation et organisationnelles propres au système CPage.

## Héritage du Profil Commun

Le profil `CPageEstablishmentProfile` hérite de `EstablishmentProfile` (du IG commun) et **ajoute** :
- Région administrative française
- Département (numéro)
- Support amélioré de la recherche géographique

```
EstablishmentProfile (IG Commun)
    ↓
    └─→ CPageEstablishmentProfile (IG CPage)
        + Région administrative
        + Département
```

## Extensions CPage Spécifiques

### 1. Région Administrative (`cpageRegion`)

**Extension**: `CPageEstablishmentRegionExtension`  
**Type**: String  
**Obligatoire**: Non (0..1)  
**Utilité**: Stocker la région administrative où se situe l'établissement

**Exemples de régions**:
- Île-de-France
- Provence-Alpes-Côte d'Azur
- Auvergne-Rhône-Alpes
- Bretagne
- etc.

**Exemple**:
```xml
<extension url="https://www.cpage.fr/fhir/StructureDefinition/cpage-establishment-region-extension">
  <valueString value="Île-de-France"/>
</extension>
```

### 2. Département (`cpageDepartment`)

**Extension**: `CPageEstablishmentDepartmentExtension`  
**Type**: String  
**Obligatoire**: Non (0..1)  
**Format**: 2-3 chiffres (ex: "75", "974")  
**Utilité**: Stocker le numéro de département code

**Départements courants**:

| Code | Département |
|------|-------------|
| 75 | Paris |
| 92 | Hauts-de-Seine |
| 93 | Seine-Saint-Denis |
| 94 | Val-de-Marne |
| 13 | Bouches-du-Rhône |
| 69 | Rhône |
| 31 | Haute-Garonne |
| 59 | Nord |
| 974 | La Réunion |

**Exemple**:
```xml
<extension url="https://www.cpage.fr/fhir/StructureDefinition/cpage-establishment-department-extension">
  <valueString value="75"/>
</extension>
```

## Profil CPageEstablishmentProfile

### Vue d'ensemble
Étend `EstablishmentProfile` (commun) pour ajouter les spécificités CPage de localisation.

### Éléments Hérités du Commun
- ✅ FINESS (identifiant 11 chiffres)
- ✅ Nom de l'établissement (clé de recherche)
- ✅ Statut (actif/inactif)
- ✅ Type d'établissement (hôpital, clinique, etc.)
- ✅ Adresse complète
- ✅ Code postal (validé)
- ✅ Contact
- ✅ FINESS numéro (finessNumber extension)

### Éléments Spécifiques CPage (Ajoutés)
- ➕ Région administrative (`cpageRegion`)
- ➕ Département (`cpageDepartment`)

## Cas d'Usage CPage

### Exemple 1: Hôpital Parisien

```json
{
  "resourceType": "Organization",
  "meta": {
    "profile": ["https://www.cpage.fr/fhir/StructureDefinition/cpage-establishment-profile"]
  },
  "identifier": [
    {
      "system": "https://www.cpage.fr/fhir/CodeSystem/finess",
      "value": "75056000111"
    }
  ],
  "name": "Hôpital Cochin",
  "status": "active",
  "type": [
    {
      "coding": [
        {
          "system": "http://terminology.hl7.org/CodeSystem/organization-type",
          "code": "prov",
          "display": "Healthcare Provider"
        }
      ]
    }
  ],
  "address": [
    {
      "line": ["27 Rue du Faubourg Saint-Jacques"],
      "city": "Paris",
      "postalCode": "75014",
      "country": "FRANCE"
    }
  ],
  "extension": [
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/establishment-type-extension",
      "valueCodeableConcept": {
        "coding": [
          {
            "system": "http://terminology.hl7.org/CodeSystem/organization-type",
            "code": "prov",
            "display": "Healthcare Provider"
          }
        ]
      }
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/finess-number-extension",
      "valueString": "75056000111"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-establishment-region-extension",
      "valueString": "Île-de-France"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-establishment-department-extension",
      "valueString": "75"
    }
  ],
  "contact": [
    {
      "name": {
        "text": "Accueil principal"
      },
      "telecom": [
        {
          "system": "phone",
          "value": "+33 1 58 41 25 25"
        }
      ]
    }
  ]
}
```

### Exemple 2: EHPAD Provençal

```json
{
  "resourceType": "Organization",
  "meta": {
    "profile": ["https://www.cpage.fr/fhir/StructureDefinition/cpage-establishment-profile"]
  },
  "identifier": [
    {
      "system": "https://www.cpage.fr/fhir/CodeSystem/finess",
      "value": "13055000222"
    }
  ],
  "name": "EHPAD Les Lavandes",
  "status": "active",
  "address": [
    {
      "line": ["345 Avenue de la Provence"],
      "city": "Marseille",
      "postalCode": "13000",
      "country": "FRANCE"
    }
  ],
  "extension": [
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/finess-number-extension",
      "valueString": "13055000222"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-establishment-region-extension",
      "valueString": "Provence-Alpes-Côte d'Azur"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-establishment-department-extension",
      "valueString": "13"
    }
  ]
}
```

## Recherche Améliorée

Le profil CPage permet une recherche enrichie :

```
GET [base]/Organization?name=Cochin&_profile=cpage-establishment-profile
GET [base]/Organization?address-postalcode=75014
GET [base]/Organization?extension-cpage-establishment-region=Île-de-France
GET [base]/Organization?extension-cpage-establishment-department=75
```

### Paramètres Supportés
- `name` : Recherche textuelle (depuis le commun)
- `address-postalcode` : Code postal (depuis le commun)
- `extension-cpage-establishment-region` : Région (CPage)
- `extension-cpage-establishment-department` : Département (CPage)
- `identifier` : FINESS exact

## Considérations d'Implémentation

### Codes Départements
- Respecter le format ISO-3166-2 français
- Supporter les DOM-TOM (974, 971, etc.)
- Valider contre la liste officielle de l'INSEE

### Noms de Régions
- Utiliser les noms officiels des 18 régions
- Support diacritiques (accents, tirets)
- Exemples:
  - Île-de-France
  - Provence-Alpes-Côte d'Azur
  - Auvergne-Rhône-Alpes
  - Centre-Val de Loire

### Cohérence Géographique
- Le département doit correspondre au code postal
- La région doit correspondre au département
- Valider cette cohérence lors de la création/update

## Cas d'Erreur Courants

❌ **Mauvais**: Code postal 75014 + département "13"  
✅ **Bon**: Code postal 75014 + département "75"

❌ **Mauvais**: Département "974" + région "Île-de-France"  
✅ **Bon**: Département "974" + région "La Réunion"

## Références
- [Profil Commun EstablishmentProfile](../establishment/establishment.html)
- [Profil CPageEstablishmentProfile](artifacts.html#Structure-Definition-cpage-establishment-profile)
- [INSEE - Départements et régions](https://www.insee.fr/)
- [FINESS - Data.gouv.fr](https://www.data.gouv.fr/datasets/61e56eaea8882370c18ab1cc)
