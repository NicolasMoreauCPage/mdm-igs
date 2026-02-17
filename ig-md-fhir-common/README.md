# ig-md-fhir-common

**IG FHIR Commun pour le Système d'Information Hospitalier (SIH) - CPage**

| | |
|---|---|
| **Version** | 0.1.0 |
| **Statut** | Draft |
| **FHIR** | 4.0.1 |
| **Juridiction** | 🇫🇷 France |

## 📋 Vue d'ensemble

Cet **Implementation Guide (IG) FHIR Commun** définit les ressources et profils de base partagés par tous les logiciels du Système d'Information Hospitalier (SIH) de CPage.

### Architecture Multi-IG

```
IG Commun (ce projet)
  ├── Fournisseurs de Produits (Supplier)
  ├── Établissements de Santé (FINESS)
  ├── CodeSystems et ValueSets
  └── Extensions de base
       ↓
       └─→ IG Spécialisé CPage
           └── Extensions/profils spécifiques CPage
```

## 🎯 Ressources Modélisées

### 1. **Fournisseurs** (Supplier)
- Profil: `SupplierProfile` (Organization)
- Identifiant: SIRET
- Statuts: Actif/Inactif/Suspendu/Fermé/En attente
- 📖 [Documentation complète](input/pages/supplier/supplier.md)

### 2. **Établissements de Santé** (FINESS)
- Profil: `EstablishmentProfile` (Organization)
- Identifiant: FINESS (11 chiffres)
- **Recherche par nom d'établissement**
- 📖 [Documentation complète](input/pages/establishment/establishment.md)

## 📦 Contenus du Projet

```
input/
├── fsh/
│   ├── codesystems/
│   │   ├── SupplierStatusCodeSystem.fsh      # Statuts fournisseur
│   │   └── PostalCodeCodeSystem.fsh          # Codes postaux FR
│   ├── valuesets/
│   │   ├── SupplierStatusValueSet.fsh
│   │   └── PostalCodeValueSet.fsh
│   └── profiles/
│       ├── SupplierProfile.fsh               # Profil Fournisseur
│       ├── EstablishmentProfile.fsh          # Profil Établissement
│       ├── SupplierStatusExtension.fsh
│       ├── EstablishmentTypeExtension.fsh
│       └── FinessNumberExtension.fsh
└── pages/
    ├── index.md                              # Accueil
    ├── supplier/supplier.md                  # Docs Fournisseurs
    └── establishment/establishment.md        # Docs Établissements
```

## 🚀 Utilisation

### Pour les Implémenteurs
1. Consultez la **documentation des Fournisseurs** et **Établissements**
2. Téléchargez les profils FHIR et ValueSets
3. Implémentez selon les cas d'usage documentés

### Pour les Architectes
1. Comprenez l'architecture multi-IG
2. Planifiez l'implémentation des profils communs
3. Préparez les extensions spécifiques pour l'IG CPage

### Pour les Contributeurs
1. Consultez [STRUCTURE.md](STRUCTURE.md) pour les détails
2. Modifiez les fichiers `.fsh` dans `input/fsh/`
3. Construisez avec SUSHI

## 🛠️ Commandes

```bash
# Construire l'IG (nécessite SUSHI et IG Publisher)
sushi build

# Valider les fichiers FSH
sushi validate

# Voir la structure
tree input/
```

## 📚 Convention de Nommage

- **CodeSystems**: `[Concept]CodeSystem.fsh`
- **ValueSets**: `[Concept]ValueSet.fsh`
- **Profils**: `[Concept]Profile.fsh`
- **Extensions**: `[Concept]Extension.fsh`

## 🔗 Liens Importants

- 📖 **Documentation FHIR**: https://www.hl7.org/fhir/
- 🏥 **FINESS**: https://www.data.gouv.fr/
- 🇫🇷 **France**: ISO 3166 Code: FR
- 📦 **Repository**: https://github.com/NicolasMoreauCPage/ig-md-fhir-common

## 📞 Contact

- **Éditeur**: CPage
- **Email**: contact@cpage.fr
- **URL**: https://www.cpage.fr

## 📄 Fichiers Clés

| Fichier | Rôle |
|---------|------|
| `sushi-config.yaml` | Configuration SUSHI |
| `input/fsh/` | Définitions FHIR Shorthand |
| `input/pages/` | Documentation markdown |
| `STRUCTURE.md` | Architecture détaillée |

## 🎓 Ressources pour Apprendre

### FHIR 4.0.1
- [Organization Resource](https://www.hl7.org/fhir/organization.html)
- [StructureDefinition (Profiles)](https://www.hl7.org/fhir/structuredefinition.html)
- [CodeSystem & ValueSet](https://www.hl7.org/fhir/codesystem.html)
- [Extensions](https://www.hl7.org/fhir/extensibility.html)

### FHIR Shorthand (FSH)
- [FSH Documentation](https://fshschool.org/)
- [FSH Syntax](https://fshschool.org/docs/FSH-Syntax/)

### Conventions Françaises
- [Dossier ANS France](https://esante.gouv.fr/)
- [SIRET/SIREN](https://www.insee.fr/)
- [FINESS](https://www.data.gouv.fr/datasets/61e56eaea8882370c18ab1cc)

## ✅ Checkliste de Démarrage

- [x] Structure de base créée
- [x] CodeSystems définis
- [x] ValueSets créés
- [x] Profils modélisés
- [x] Extensions définies
- [x] Documentation écrite
- [ ] Validation SUSHI
- [ ] Codes postaux complets
- [ ] Exemples instances
- [ ] Publication

---

**Créé**: 2026-02-11  
**Statut**: Draft 0.1.0  
**Licence**: À définir