# Modélisation des Établissements de Santé (FINESS)

## Contexte

Les établissements de santé sont les structures opérantes du système de santé français. Chaque établissement est identifié par un numéro **FINESS** (Fichier National d'Identification des Structures d'Établissements Sanitaires et Sociaux) qui est l'identifiant unique permettant de le localiser et le retrouver.

L'objectif principal est de permettre la **recherche et l'identification rapide** d'un établissement par son nom, adresse, ou numéro FINESS.

## Vue d'ensemble

### Définition
Un **établissement de santé** est une structure de santé organisée avec ses propres droits, obligations et responsabilités. Il peut s'agir d'un hôpital, une clinique, un EHPAD, un centre de santé, etc.

Chaque établissement est uniquement identifié par son numéro **FINESS** public (7 chiffres) et peut gérer plusieurs structures internes avec leurs propres FINESS d'entité géographique (4 chiffres supplémentaires = 11 chiffres au total).

### Objectifs
- Identifier uniquement chaque établissement par son FINESS
- Permettre la **recherche par nom d'établissement**
- Disposer des informations complètes de localisation (adresse, commune, code postal)
- Tracker le type d'établissement (hôpital, clinique, maison de retraite, etc.)
- Faciliter le contact et la communication

## Profil Établissement (EstablishmentProfile)

### Description
Le profil `EstablishmentProfile` est une spécialisation de la ressource FHIR `Organization` conçue pour représenter les établissements de santé français.

### Identifiants (`identifier`)
- **Obligatoire** et répétable
- Doit contenir le **numéro FINESS complet** (11 chiffres)
- Format FINESS: `[7 chiffres établissement][4 chiffres structure] = 11 chiffres`
- Système URL pour FINESS: `https://www.cpage.fr/fhir/CodeSystem/finess`

**Exemple**:
```
identifier:
  - system: "https://www.cpage.fr/fhir/CodeSystem/finess"
    value: "75056000111"
```

### Nom de l'Établissement (`name`)
- **Obligatoire**
- **Clé pour la recherche** : Le nom doit permettre une recherche textuelle
- Doit contenir le nom complet et officiel de l'établissement
- Les alias ou variantes de noms peuvent être inclus

**Points importants**:
- Les systèmes implémantant ce profil DOIVENT supporter la recherche par nom
- Les accents et caractères spéciaux doivent être gérés
- La recherche doit être case-insensitive

### Statut (`status`)
- **Obligatoire**
- Valeurs : `active`, `inactive`, `terminated`, `draft`
- Indique si l'établissement est actuellement opérationnel

### Adresse (`address`)
- **Obligatoire**
- Adresse complète avec :
  - Ligne(s) d'adresse (rue, numéro)
  - Ville
  - **Code postal** (5 chiffres) - Doit être sélectionné dans la ValueSet `PostalCodeVS`
  - Pays (par défaut: FRANCE)

### Extension : Type d'Établissement (`establishmentType`)
- **Obligatoire**
- Utilise les types FHIR d'organisation
- Exemples : hôpital, clinique, EHPAD, centre de santé, laboratoire, etc.

### Extension : Numéro FINESS (`finessNumber`)
- **Obligatoire**
- Contient le numéro FINESS structuré (11 chiffres)
- Format validé : uniquement des chiffres, longueur exacte 11

### Contacts
- Personne de contact principal
- Moyens de communication (téléphone, fax, email)

## Recherche d'Établissement

### Par nom d'établissement
Le profil supporte **la recherche textuelle par nom**, ce qui est essentiel pour l'utilisation en production.

**Considérations pour les implémentations**:
- Implémenter une recherche **CONTAINS** ou **MATCHES** pour le paramètre `name`
- Supporter les recherches partielles (ex: "Hôpital Saint" find "Hôpital Saint-Louis")
- Ignorer les accents et caractères spéciaux si nécessaire
- Recherche case-insensitive

### Par FINESS
Recherche directe par numéro FINESS via le paramètre `identifier`.

### Par localisation
Recherche par code postal, ville, ou adresse.

## CodeSystem et ValueSet

### PostalCodeCS
CodeSystem contenant l'ensemble des codes postaux français.

**Système URL**: `https://www.cpage.fr/fhir/CodeSystem/postal-code`

**Exemple de codes**:
| Code | Description |
|------|-------------|
| `75001` | 75001 - Paris 1er arrondissement |
| `75002` | 75002 - Paris 2e arrondissement |
| ... | ... |
| `75020` | 75020 - Paris 20e arrondissement |

### PostalCodeVS
ValueSet agrégeant tous les codes postaux français.

**Système URL**: `https://www.cpage.fr/fhir/ValueSet/postal-code`

## Cas d'usage

### Exemple 1: Créer un nouvel établissement
```json
{
  "resourceType": "Organization",
  "meta": {
    "profile": ["https://www.cpage.fr/fhir/StructureDefinition/establishment-profile"]
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
  "telecom": [
    {
      "system": "phone",
      "value": "+33 1 58 41 25 25"
    },
    {
      "system": "email",
      "value": "contact@cochin.aphp.fr"
    }
  ],
  "address": [
    {
      "type": "physical",
      "line": ["27 Rue du Faubourg Saint-Jacques"],
      "city": "Paris",
      "postalCode": "75014",
      "country": "FRANCE"
    }
  ],
  "contact": [
    {
      "name": {
        "text": "Accueil général"
      },
      "telecom": [
        {
          "system": "phone",
          "value": "+33 1 58 41 25 25"
        }
      ]
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
    }
  ]
}
```

### Exemple 2: Recherche d'établissement
```
GET [base]/Organization?name=Cochin&address-postalcode=75014
```

Retournerait tous les établissements contenant "Cochin" dans le nom et situés dans le code postal 75014.

## Considérations d'implémentation

### Validation FINESS
- Format strictement validé : 11 chiffres uniquement
- Vérification de la clé de contrôle du FINESS si possible

### Unicité
- Chaque FINESS doit être unique dans le système
- Impossible d'avoir deux établissements avec le même FINESS

### Recherche
- **Capacité de recherche par nom OBLIGATOIRE**
- Support pour les recherches partielles
- Optimiser les index sur le nom de l'établissement
- Support diacritique (accents) selon les besoins régionaux

### Historique
- Tracker les modifications de statut
- Conserver l'historique des changements d'adresse
- Audit trail des mises à jour

### Intégration
- Lien possible vers d'autres ressources (Département, Région, Autorités de tutelle)
- Lien vers les ressources Practitioner (médecins, staff médical)
- Lien vers les structures internes (Services, Départements)

## Références
- [FHIR Organization Resource](https://www.hl7.org/fhir/organization.html)
- [Profil EstablishmentProfile](artifacts.html#Structure-Definition-establishment-profile)
- [FINESS - Fichier National d'Identification des Structures](https://www.data.gouv.fr/datasets/61e56eaea8882370c18ab1cc)
