# ig-md-fhir-cpage

**IG FHIR Spécialisé pour CPage Masterdata**

| | |
|---|---|
| **Version** | 0.1.0 |
| **Statut** | Draft |
| **FHIR** | 4.0.1 |
| **Juridiction** | 🇫🇷 France |

## 📋 Vue d'ensemble

Cet **Implementation Guide (IG) FHIR Spécialisé** définit les ressources, profils et extensions **propres à CPage** pour son système **Masterdata**.

Cet IG **hérite du [IG Commun](https://github.com/NicolasMoreauCPage/ig-md-fhir-common)** et ajoute des spécialisations métier.

### Architecture Multi-IG

```
IG Commun              IG CPage (ce projet)
(Profiles communs) ──→ (Enrichissements métier)
                       └─ Codes internes
                       └─ Catégories CPage
                       └─ Données régionales
```

## 🎯 Fonctionnalités Principales

### 1. Fournisseurs CPage (`CPageSupplierProfile`)
Hérite de `SupplierProfile` du commun + ajoute :
- 🔹 **Code interne CPage** pour identification système
- 🔹 **Catégories** (local/national/spécialiste santé/IT/logistique)
- 🔹 **Mapping** systèmes legacy

### 2. Établissements CPage (`CPageEstablishmentProfile`)
Hérite de `EstablishmentProfile` du commun + ajoute :
- 🔹 **Région administrative** française
- 🔹 **Département** (numéro)
- 🔹 **Recherche géographique** enrichie

## 📦 Contenus du Projet

```
input/
├── fsh/
│   ├── extensions/              # 4 extensions CPage
│   │   ├── CPageSupplierInternalCodeExtension.fsh
│   │   ├── CPageSupplierCategoryExtension.fsh
│   │   ├── CPageEstablishmentRegionExtension.fsh
│   │   └── CPageEstablishmentDepartmentExtension.fsh
│   ├── codesystems/             # CodeSystems CPage
│   │   └── CPageSupplierCategoryCodeSystem.fsh
│   ├── valuesets/               # ValueSets CPage
│   │   └── CPageSupplierCategoryValueSet.fsh
│   └── profiles/                # Profils CPage
│       ├── CPageSupplierProfile.fsh
│       └── CPageEstablishmentProfile.fsh
└── pages/
    ├── index.md
    ├── cpage-supplier/cpage-supplier.md
    └── cpage-establishment/cpage-establishment.md
```

## 🔗 Dépendances

Dépend de **IG Commun** (`ig-md-fhir-common` v0.1.0):
- Profils : SupplierProfile, EstablishmentProfile
- CodeSystems : SupplierStatusCS, PostalCodeCS
- ValueSets : SupplierStatusVS, PostalCodeVS
- Extensions : SupplierStatusExtension, FinessNumberExtension, etc.

## 🚀 Utilisation

### Pour les Implémenteurs CPage
```bash
# 1. Consulter la documentation
# - Fournisseurs CPage: input/pages/cpage-supplier/cpage-supplier.md
# - Établissements CPage: input/pages/cpage-establishment/cpage-establishment.md

# 2. Implémenter les profils
# - CPageSupplierProfile
# - CPageEstablishmentProfile

# 3. Utiliser les extensions CPage
# - CPageSupplierInternalCodeExtension
# - CPageSupplierCategoryExtension
# - CPageEstablishmentRegionExtension
# - CPageEstablishmentDepartmentExtension
```

### Pour Construire l'IG

```bash
# Installer les dépendances (SUSHI, IG Publisher)
npm install -g fsh-sushi
npm install -g fhir

# Construire
sushi .

# Publier (générer HTML)
_updatePublisher.bat  # Windows
./_updatePublisher.sh # Linux/Mac
_genonce.bat          # Windows
./_genonce.sh         # Linux/Mac
```

## 📚 Extensions Créées

### Fournisseurs (2 extensions)
| Extension | Type | Obligatoire | Usage |
|-----------|------|-------------|--------|
| `CPageSupplierInternalCodeExtension` | String | Non | Code interne CPage (ex: SUP-CPA-0042) |
| `CPageSupplierCategoryExtension` | Code | Non | Classification (local/national/healthcare/IT) |

### Établissements (2 extensions)
| Extension | Type | Obligatoire | Usage |
|-----------|------|-------------|--------|
| `CPageEstablishmentRegionExtension` | String | Non | Région administrative (Île-de-France, PACA) |
| `CPageEstablishmentDepartmentExtension` | String | Non | Numéro de département (75, 93, 13) |

## 💡 Cas d'Usage Principaux

### Cas 1: Intégrer un Fournisseur
```json
{
  "resourceType": "Organization",
  "meta": {"profile": ["...cpage-supplier-profile"]},
  "identifier": [{"system": "...siret", "value": "123..."}],
  "name": "Pharmalogic",
  "extension": [
    {"url": "...cpage-supplier-internal-code-extension", "valueString": "SUP-CPA-0042"},
    {"url": "...cpage-supplier-category-extension", "valueCode": "healthcare-specialist"}
  ]
}
```

### Cas 2: Intégrer un Établissement
```json
{
  "resourceType": "Organization",
  "meta": {"profile": ["...cpage-establishment-profile"]},
  "identifier": [{"system": "...finess", "value": "75056000111"}],
  "name": "Hôpital Cochin",
  "extension": [
    {"url": "...cpage-establishment-region-extension", "valueString": "Île-de-France"},
    {"url": "...cpage-establishment-department-extension", "valueString": "75"}
  ]
}
```

## ✅ Checkliste

- [x] Structure de base créée
- [x] 4 Extensions CPage définies
- [x] CodeSystems & ValueSets
- [x] 2 Profils CPage (héritage du commun)
- [x] Documentation détaillée
- [x] Configuration SUSHI avec dépendances
- [x] Pages d'accueil et spécialisées
- [ ] Validation SUSHI
- [ ] Publication
- [ ] Exemples instances supplémentaires

## 📖 Documentation

| Section | Contenu |
|---------|---------|
| **Fournisseurs CPage** | Extensions, profil, cas d'usage |
| **Établissements CPage** | Région/Département, recherche géographique |
| **Artefacts** | Tous les profils et extensions |
| **IG Commun** | Lien vers le guide parent |

## 🔗 Liens

- 📦 **IG Commun**: https://github.com/NicolasMoreauCPage/ig-md-fhir-common
- 📦 **Repository CPage**: https://github.com/NicolasMoreauCPage/ig-md-fhir-cpage
- 🌐 **CPage**: https://www.cpage.fr
- 📚 **FHIR 4.0.1**: https://www.hl7.org/fhir/
- 🇫🇷 **INSEE**: https://www.insee.fr/

## 📞 Contact

- **Éditeur**: CPage
- **Email**: contact@cpage.fr
- **Web**: https://www.cpage.fr

---

**Créé**: 2026-02-11  
**Statut**: Draft 0.1.0  
**Licence**: À définir