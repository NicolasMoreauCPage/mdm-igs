# Structure du Projet - ig-md-fhir-cpage

## Vue d'ensemble du projet

```
ig-md-fhir-cpage/
├── input/
│   ├── fsh/                          # Fichiers FSH (FHIR Shorthand)
│   │   ├── extensions/               # Extensions CPage (4 fichiers)
│   │   │   ├── CPageSupplierInternalCodeExtension.fsh
│   │   │   ├── CPageSupplierCategoryExtension.fsh
│   │   │   ├── CPageEstablishmentRegionExtension.fsh
│   │   │   └── CPageEstablishmentDepartmentExtension.fsh
│   │   ├── codesystems/              # CodeSystems CPage (1 fichier)
│   │   │   └── CPageSupplierCategoryCodeSystem.fsh
│   │   ├── valuesets/                # ValueSets CPage (1 fichier)
│   │   │   └── CPageSupplierCategoryValueSet.fsh
│   │   └── profiles/                 # Profils CPage (2 fichiers)
│   │       ├── CPageSupplierProfile.fsh
│   │       └── CPageEstablishmentProfile.fsh
│   └── pages/                        # Pages de documentation markdown
│       ├── index.md                  # Page d'accueil
│       ├── downloads.md              # Téléchargements
│       ├── cpage-supplier/
│       │   └── cpage-supplier.md     # Doc Fournisseurs CPage
│       └── cpage-establishment/
│           └── cpage-establishment.md  # Doc Établissements CPage
└── sushi-config.yaml                 # Configuration SUSHI
```

## Ressources Créées

### 1. Extensions CPage (4 fichiers)

#### CPageSupplierInternalCodeExtension.fsh
**Objectif**: Stocker le code interne CPage d'un fournisseur
- **Type**: String
- **Contexte**: Organization
- **Obligatoire**: Non (0..1)
- **Exemple**: "SUP-CPA-0042"

#### CPageSupplierCategoryExtension.fsh
**Objectif**: Classifier les fournisseurs selon la métier CPage
- **Type**: Code
- **Contexte**: Organization
- **Obligatoire**: Non (0..1)
- **ValueSet**: CPageSupplierCategoryVS
- **Codes**: local, national, european, international, healthcare-specialist, it-provider, logistics

#### CPageEstablishmentRegionExtension.fsh
**Objectif**: Stocker la région administrative de l'établissement
- **Type**: String
- **Contexte**: Organization
- **Obligatoire**: Non (0..1)
- **Exemples**: "Île-de-France", "Provence-Alpes-Côte d'Azur"

#### CPageEstablishmentDepartmentExtension.fsh
**Objectif**: Stocker le numéro de département
- **Type**: String (2-3 chiffres)
- **Contexte**: Organization
- **Obligatoire**: Non (0..1)
- **Format**: ISO-3166-2 France
- **Exemples**: "75", "93", "13", "974"

### 2. CodeSystem CPage (1 fichier)

#### CPageSupplierCategoryCodeSystem.fsh
**URL**: `https://www.cpage.fr/fhir/CodeSystem/cpage-supplier-category`

**Codes**:
| Code | Label | Description |
|------|-------|-------------|
| `local` | Fournisseur Local | Implanté localement dans la région |
| `national` | Fournisseur National | Opérant au niveau national |
| `european` | Fournisseur Européen | Implanté en Europe |
| `international` | Fournisseur International | À l'international |
| `healthcare-specialist` | Spécialiste Santé | Produits/services de santé |
| `it-provider` | Prestataire IT | Services informatiques |
| `logistics` | Logistique | Services logistiques |

### 3. ValueSet CPage (1 fichier)

#### CPageSupplierCategoryValueSet.fsh
**URL**: `https://www.cpage.fr/fhir/ValueSet/cpage-supplier-category`
**Référence**: CPageSupplierCategoryCodeSystem

### 4. Profils CPage (2 fichiers)

#### CPageSupplierProfile.fsh
**Parent**: `SupplierProfile` (du IG Commun)
**Extensions**: 
- Hérite de: supplierStatus (du commun)
- Ajoute: cpageInternalCode, cpageCategory (CPage)

**Éléments**:
- `identifier` (1..*) : SIRET
- `name` (1..*) : Nom du fournisseur
- `status` : active/inactive/suspended/terminated
- `telecom` : Contact
- `address` : Adresse avec code postal validé
- `contact` : Personne de contact
- `extension[supplierStatus]` : Statut (du commun)
- `extension[cpageInternalCode]` : Code CPage (CPage)
- `extension[cpageCategory]` : Catégorie CPage (CPage)

#### CPageEstablishmentProfile.fsh
**Parent**: `EstablishmentProfile` (du IG Commun)
**Extensions**:
- Hérite de: establishmentType, finessNumber (du commun)
- Ajoute: cpageRegion, cpageDepartment (CPage)

**Éléments**:
- `identifier` (1..*) : FINESS (11 chiffres)
- `name` (1..*) : Nom de l'établissement [clé de recherche]
- `status` : active/inactive/terminated
- `address` : Adresse avec code postal validé
- `contact` : Personne de contact
- `extension[establishmentType]` : Type (du commun)
- `extension[finessNumber]` : FINESS structure (du commun)
- `extension[cpageRegion]` : Région administrative (CPage)
- `extension[cpageDepartment]` : Département (CPage)

## Configuration SUSHI (sushi-config.yaml)

La configuration a été mise à jour avec:
- **ID**: `ig-md-fhir-cpage`
- **Canonical URL**: `https://www.cpage.fr/ig/ig-md-fhir-cpage`
- **Title**: "IG FHIR CPage - Masterdata"
- **Dependencies**: `ig-md-fhir-common: 0.1.0`
- **Pages**: 
  - index.md (Accueil)
  - cpage-supplier/cpage-supplier.md (Fournisseurs CPage)
  - cpage-establishment/cpage-establishment.md (Établissements CPage)
  - downloads.md (Téléchargements)
- **Menu**: 
  - Accueil
  - Ressources de conformité (Artifacts)
  - Fournisseurs CPage
  - Établissements CPage
  - Lien vers IG Commun
  - Téléchargements

## Pages de Documentation

### index.md (Accueil)
- Vue d'ensemble du projet CPage
- Architecture multi-IG avec diagramme
- Concepts principaux (Fournisseurs, Établissements)
- Extensions CPage
- Caractéristiques clés
- Liens importants

### cpage-supplier/cpage-supplier.md
**Contenu**:
- Contexte CPage pour les fournisseurs
- Héritage du profil commun
- 2 Extensions CPage avec détails
- Profil CPageSupplierProfile
- 2 Cas d'usage (Pharmacien, Prestataire IT)
- Considérations d'implémentation
- Références

**Points clés**:
- Code interne CPage pour identification propriétaire
- Catégorisation des fournisseurs par rôle/secteur
- Mapping avec systèmes legacy

### cpage-establishment/cpage-establishment.md
**Contenu**:
- Contexte CPage pour les établissements
- Héritage du profil commun
- 2 Extensions CPage (Région, Département)
- Profil CPageEstablishmentProfile
- 2 Cas d'usage (Hôpital Parisien, EHPAD Provençal)
- Recherche améliorée (paramètres de recherche)
- Considérations d'implémentation
- Cas d'erreur courants
- Références

**Points clés**:
- Enrichissement géographique (région + département)
- Recherche par localisation
- Validation de cohérence géographique
- Support DOM-TOM

## Fichiers de Spécification

### sushi-config.yaml
Configuration SUSHI pour construire l'IG
- Version: 0.1.0
- FHIR: 4.0.1
- Dépendance: ig-md-fhir-common 0.1.0
- Pages et menu configurés

### README.md
Guide de démarrage pratique avec:
- Vue d'ensemble
- Architecture multi-IG
- Fonctionnalités principales
- Contenus du projet
- Dépendances
- Utilisation
- Extensions créées
- Cas d'usage
- Checkliste

## Prochaines Étapes

1. ✅ Structure créée
2. ✅ Extensions définies (4)
3. ✅ CodeSystems et ValueSets créés
4. ✅ Profils modélisés (2)
5. ✅ Documentation écrite
6. ✅ Configuration SUSHI avec dépendances
7. ⏳ Validation SUSHI (`sushi build`)
8. ⏳ Publication (générer HTML)
9. ⏳ Exemples instances supplémentaires
10. ⏳ Intégration avec systèmes CPage

## Commandes Utiles

```powershell
# Naviguer vers le projet
cd c:\Travail\MasterData\ig-md-fhir-cpage

# Valider et construire l'IG
sushi build

# Voir les fichiers FSH créés
Get-ChildItem -Recurse -Filter "*.fsh"

# Voir les pages de documentation
Get-ChildItem input/pages -Recurse -Filter "*.md"

# Nettoyer les fichiers générés
rm -r fsh-generated/
rm -r output/
```

## Dépendance sur l'IG Commun

La configuration déclare une dépendance sur `ig-md-fhir-common`:

```yaml
dependencies:
  ig-md-fhir-common: 0.1.0
```

Cela permet à l'IG CPage de:
- ✅ Référencer et hériter des profils communs
- ✅ Utiliser les CodeSystems communs
- ✅ Étendre les ValueSets communs
- ✅ Bénéficier des extensions de base commun

### Parent profils
Les profils CPage héritent directement:
- `CPageSupplierProfile` ← `SupplierProfile` (commun)
- `CPageEstablishmentProfile` ← `EstablishmentProfile` (commun)

## Notes Importantes

### URL Canonical
- IG Commun: `https://www.cpage.fr/ig/ig-md-fhir-common`
- IG CPage: `https://www.cpage.fr/ig/ig-md-fhir-cpage`

### Versioning
- Commun: 0.1.0
- CPage: 0.1.0
- À synchroniser lors des releases

### Imports FSH
Les profils CPage référencent les URL canoniques complètes:
```fsh
Parent: https://www.cpage.fr/fhir/StructureDefinition/supplier-profile
```

Cela assure la résolution correcte au moment du build.

---

**Créé le**: 2026-02-11  
**Version**: 0.1.0  
**Statut**: Draft  
**Auteur**: GitHub Copilot