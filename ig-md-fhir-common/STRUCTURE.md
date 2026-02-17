# Structure du Projet - ig-md-fhir-common

## vue d'ensemble du projet

```
ig-md-fhir-common/
├── input/
│   ├── fsh/                          # Fichiers FSH (FHIR Shorthand)
│   │   ├── codesystems/              # CodeSystems (systèmes de codes)
│   │   │   ├── SupplierStatusCodeSystem.fsh
│   │   │   └── PostalCodeCodeSystem.fsh
│   │   ├── valuesets/                # ValueSets (ensembles de valeurs)
│   │   │   ├── SupplierStatusValueSet.fsh
│   │   │   └── PostalCodeValueSet.fsh
│   │   └── profiles/                 # Profils et Extensions
│   │       ├── SupplierProfile.fsh
│   │       ├── EstablishmentProfile.fsh
│   │       ├── SupplierStatusExtension.fsh
│   │       ├── EstablishmentTypeExtension.fsh
│   │       └── FinessNumberExtension.fsh
│   └── pages/                        # Pages de documentation markdown
│       ├── index.md                  # Page d'accueil
│       ├── downloads.md              # Téléchargements
│       ├── supplier/
│       │   └── supplier.md           # Documentation des Fournisseurs
│       └── establishment/
│           └── establishment.md      # Documentation des Établissements
└── sushi-config.yaml                 # Configuration SUSHI
```

## Ressources Créées

### 1. CodeSystems

#### SupplierStatusCodeSystem.fsh
**Objectif**: Définir les différents statuts qu'un fournisseur peut avoir

**Codes**:
- `active` - Fournisseur actif
- `inactive` - Inactif temporairement
- `suspended` - Suspendu
- `terminated` - Fermé définitivement
- `pending` - En phase de validation

#### PostalCodeCodeSystem.fsh
**Objectif**: Définir les codes postaux français

**Contenu**: Liste des codes postaux (exemple: codes parisiens 75001-75020)
*Note: À enrichir avec la liste complète des codes postaux français*

### 2. ValueSets

#### SupplierStatusValueSet.fsh
**Objectif**: Regrouper tous les statuts de fournisseur
**Référence**: SupplierStatusCodeSystem

#### PostalCodeValueSet.fsh
**Objectif**: Regrouper tous les codes postaux
**Référence**: PostalCodeCodeSystem

### 3. Profils

#### SupplierProfile.fsh
**Ressource Parent**: Organization (FHIR)

**Éléments clés**:
- `identifier` (1..*) : SIRET du fournisseur
- `name` (1..*) : Raison sociale
- `status` : Statut FHIR (active/inactive/terminated/draft)
- `telecom` : Coordonnées de contact
- `address` : Adresse avec code postal
- `contact` : Personne de contact
- `extension[supplierStatus]` (1..1) : Extension du statut spécifique

**Cas d'usage**: Modéliser les fournisseurs de produits pour un marché d'approvisionnement

#### EstablishmentProfile.fsh
**Ressource Parent**: Organization (FHIR)

**Éléments clés**:
- `identifier` (1..*) : FINESS (11 chiffres: 7+4)
- `name` (1..*) : Nom de l'établissement **[clé de recherche]**
- `status` : Actif/Inactif
- `address` : Adresse avec code postal
- `contact` : Personne de contact
- `extension[establishmentType]` (1..1) : Type d'établissement
- `extension[finessNumber]` (1..1) : FINESS structuré

**Cas d'usage**: Modéliser les établissements de santé avec possibilité de recherche par nom

### 4. Extensions

#### SupplierStatusExtension.fsh
**URL**: `https://www.cpage.fr/fhir/StructureDefinition/supplier-status-extension`
**Type**: CodeableConcept
**ValueSet**: SupplierStatusVS
**Contexte**: Organization
**Objectif**: Tracker le statut avancé du fournisseur

#### EstablishmentTypeExtension.fsh
**URL**: `https://www.cpage.fr/fhir/StructureDefinition/establishment-type-extension`
**Type**: CodeableConcept
**ValueSet**: hl7.org:organization-type
**Contexte**: Organization
**Objectif**: Classifier le type d'établissement (hôpital, clinique, EHPAD, etc.)

#### FinessNumberExtension.fsh
**URL**: `https://www.cpage.fr/fhir/StructureDefinition/finess-number-extension`
**Type**: String (validé sur 11 chiffres)
**Pattern**: `^[0-9]{11}$`
**Contexte**: Organization
**Objectif**: Stocker le FINESS de manière structurée

## Configuration SUSHI (sushi-config.yaml)

La configuration a été mise à jour avec:
- **ID**: `ig-md-fhir-common`
- **Canonical URL**: `https://www.cpage.fr/ig/ig-md-fhir-common`
- **Title**: "IG FHIR Commun - CPage"
- **Pages**: Accueil, Fournisseurs, Établissements, Téléchargements
- **Menu**: Liens vers les sections principales

## Prochaines Étapes

1. ✅ **Struktur créée** - Dossiers et fichiers de base
2. ✅ **CodeSystems définis** - SupplierStatus et PostalCode
3. ✅ **ValueSets créés** - Pour chaque CodeSystem
4. ✅ **Profils modélisés** - Supplier et Establishment
5. ✅ **Extensions créées** - SupplierStatus, EstablishmentType, FinessNumber
6. ✅ **Documentation écrite** - Pages détaillées pour chaque concept
7. ⏳ **Validation SUSHI** - À exécuter avec `sushi build`
8. ⏳ **Enrichissement** - Codes postaux complets, exemples supplémentaires
9. ⏳ **Publication** - Générer le guide HTML pour publication

## Commandes Utiles

```powershell
# Naviguer vers le projet
cd c:\Travail\MasterData\ig-md-fhir-common

# Valider et construire l'IG (nécessite SUSHI et IG Publisher)
sushi build

# Voir les fichiers FSH créés
Get-ChildItem -Recurse -Filter "*.fsh"

# Afficher l'index des pages
Get-ChildItem input/pages -Recurse -Filter "*.md"
```

## Notes Importantes

### PostalCodeCodeSystem
La liste des codes postaux est actuellement partielle (Paris uniquement).
À compléter avec:
- All French postal codes (95,000+ codes)
- Ou utiliser une source externe comme data.gouv.fr
- Considérer créer un CodeSystem plus léger si la liste est très grande

### FINESS Validation
Le format FINESS (11 chiffres) est validé via regex dans l'extension.
À considérer pour futures implémentations:
- Validation de la clé de contrôle FINESS
- Synchronisation avec la base FINESS officielle (ASIP)

### Recherche d'Établissement
Le profil EstablishmentProfile a un alias `nameSearch` sur le champ `name`.
Les implémenteurs doivent supporter:
- Recherche textuelle CONTAINS ou MATCHES
- Recherche case-insensitive
- Support des diacritiques si nécessaire

## Architecture Future

Ce projet commun sera utilisé par:
- **ig-md-fhir-cpage** - IG spécialisé avec extensions CPage-spécifiques
- Autres logiciels du SIH - Utilisant les profils communs

```
┌──────────────────────────────────────────────────────────┐
│              ig-md-fhir-common (COMMUN)                  │
│  SupplierProfile, EstablishmentProfile, ValueSets, etc.  │
└───────────────────┬──────────────────────────────────────┘
                    │
         ┌──────────┴──────────┬─────────────────────┐
         │                     │                     │
    ┌────▼──────┐         ┌────▼──────┐        ┌────▼──────┐
    │  IG CPage │         │ IG Autre1  │        │ IG AutreN  │
    │(spécialisé)         │(spécialisé)        │(spécialisé)
    └───────────┘         └───────────┘        └───────────┘
```

---

**Créé le**: 2026-02-11  
**Version**: 0.1.0  
**Statut**: Draft  
**Auteur**: GitHub Copilot