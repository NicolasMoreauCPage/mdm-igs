# Modélisation des Fournisseurs

## Contexte

Les fournisseurs sont les entités responsables de la fourniture de produits dans le cadre d'un marché d'approvisionnement. Ils doivent être identifiés de manière unique et leur statut doit être tracé dans le système.

## Vue d'ensemble

### Définition
Un **fournisseur** est une organisation capable de fournir des produits et des services. Dans ce IG, les fournisseurs sont modélisés à l'aide du profil `SupplierProfile` basé sur la ressource FHIR `Organization`.

### Objectifs
- Identifier uniquement chaque fournisseur
- Tracker le statut opérationnel du fournisseur
- Disposer des informations de contact et d'adresse
- Savoir qui contacter au sein de l'organisation

## Profil Fournisseur (SupplierProfile)

### Description
Le profil `SupplierProfile` est une spécialisation de la ressource FHIR `Organization` conçue pour représenter les fournisseurs de produits.

### Éléments clés

#### Identifiants (`identifier`)
- **Obligatoire** et répétable
- Contient le **numéro SIRET** et autres identifiants uniques
- Chaque identifiant doit spécifier son système (ex: `https://www.cpage.fr/fhir/CodeSystem/siret`)

#### Nom (`name`)
- **Obligatoire** et peut être répété
- Contient la raison sociale du fournisseur
- Peut inclure des alias commerciaux

#### Statut (`status`)
- **Obligatoire**
- Utilise les valeurs FHIR standard : `active`, `inactive`, `terminated`, `draft`

#### Coordonnées (`telecom`)
- Contact téléphonique et/ou email
- Peut inclure un site web

#### Adresse (`address`)
- Adresse physique du fournisseur
- Le code postal doit être sélectionné dans la ValueSet `PostalCodeVS`

#### Extension : Statut du Fournisseur (`supplierStatus`)
- **Obligatoire**
- Utilise la CodeSystem `SupplierStatusCS`
- Valeurs possibles :
  - `active` : Fournisseur actif
  - `inactive` : Fournisseur inactif temporairement
  - `suspended` : Fournisseur suspendu
  - `terminated` : Fournisseur fermé définitivement
  - `pending` : Fournisseur en phase de validation

#### Contacts
- Personne de contact principal au sein du fournisseur
- Nom et moyens de communication

## CodeSystem et ValueSet

### SupplierStatusCS
CodeSystem permettant de définir les différents statuts qu'un fournisseur peut avoir.

**Système URL**: `https://www.cpage.fr/fhir/CodeSystem/supplier-status`

**Codes disponibles**:
| Code | Description |
|------|-------------|
| `active` | Le fournisseur est actif et peut fournir des produits |
| `inactive` | Le fournisseur est inactif temporairement |
| `suspended` | Le fournisseur est suspendu et ne peut plus fournir |
| `terminated` | Le fournisseur a fermé définitivement |
| `pending` | Le fournisseur est en phase de validation |

### SupplierStatusVS
ValueSet agrégeant tous les codes de statut du fournisseur.

**Système URL**: `https://www.cpage.fr/fhir/ValueSet/supplier-status`

## Cas d'usage

### Exemple 1: Créer un nouveau fournisseur
```json
{
  "resourceType": "Organization",
  "meta": {
    "profile": ["https://www.cpage.fr/fhir/StructureDefinition/supplier-profile"]
  },
  "identifier": [
    {
      "system": "https://www.cpage.fr/fhir/CodeSystem/siret",
      "value": "12345678900145"
    }
  ],
  "name": "Pharma Plus SARL",
  "status": "active",
  "telecom": [
    {
      "system": "phone",
      "value": "+33 1 23 45 67 89"
    },
    {
      "system": "email",
      "value": "contact@pharmaplus.fr"
    }
  ],
  "address": [
    {
      "type": "physical",
      "line": ["123 Rue de la Paix"],
      "city": "Paris",
      "postalCode": "75001",
      "country": "FRANCE"
    }
  ],
  "contact": [
    {
      "name": {
        "text": "Jean Dupont"
      },
      "telecom": [
        {
          "system": "phone",
          "value": "+33 1 23 45 67 89"
        }
      ]
    }
  ],
  "extension": [
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/supplier-status-extension",
      "valueCode": "active"
    }
  ]
}
```

## Considérations d'implémentation

- **Validation des identifiants** : Le système doit valider le format SIRET (14 chiffres)
- **Unicité** : Chaque SIRET doit être unique dans le système
- **Historique** : Suivre les changements de statut du fournisseur
- **Recherche** : Les systèmes doivent permettre la recherche par SIRET, nom, adresse

## Références
- [FHIR Organization Resource](https://www.hl7.org/fhir/organization.html)
- [Profil SupplierProfile](artifacts.html#Structure-Definition-supplier-profile)
