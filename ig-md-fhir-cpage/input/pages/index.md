# IG FHIR CPage - Masterdata

**Version**: 0.1.0 | **Publié**: 2026-02-11 | **Statut**: Draft

## Bienvenue

Cet **Implementation Guide (IG) FHIR Spécialisé pour CPage** définit les ressources, profils et extensions **spécifiques à CPage** pour son système **Masterdata**.

## Architecture Multi-IG

Cet IG s'appuie sur une **architecture multi-niveaux** :

```
┌─────────────────────────────────────────────────────┐
│  IG FHIR COMMUN (ig-md-fhir-common)                 │
│  • Fournisseurs (Supplier)                          │
│  • Établissements (FINESS)                          │
│  • CodeSystems & ValueSets partagés                 │
│  • Extensions de base                              │
└────────────────┬────────────────────────────────────┘
                 │
                 │ (héritage + spécialisations)
                 ↓
        ┌────────────────────┐
        │  IG FHIR CPage  ◄──┤ CE GUIDE
        │        (spécialisé) │
        │ • Fournisseurs CPage│
        │ • Établissements CPage
        │ • Extensions CPage  │
        │ • Codes internes    │
        │ • Données régionales│
        └────────────────────┘
```

## Vue d'ensemble

### Concepts Principaux

L'IG CPage hérite et étend deux concepts clés du commun :

#### 1. **Fournisseurs CPage** 
Hérite de `SupplierProfile` (commun) et ajoute :
- ✅ Code interne CPage (identification propriétaire)
- ✅ Catégories CPage (local, national, spécialiste santé, IT, logistique, etc.)
- [📖 Voir documentation](cpage-supplier.html)

#### 2. **Établissements CPage**
Hérite de `EstablishmentProfile` (commun) et ajoute :
- ✅ Région administrative française
- ✅ Numéro de département
- ✅ Recherche géographique enrichie
- [📖 Voir documentation](cpage-establishment.html)

## Ressources Modélisées

| Ressource | Profil | Héritage | Extensions CPage |
|-----------|--------|----------|-----------------|
| **Fournisseur** | CPageSupplierProfile | SupplierProfile | Code interne, Catégorie |
| **Établissement** | CPageEstablishmentProfile | EstablishmentProfile | Région, Département |

## Fichiers et Structure

```
input/fsh/
├── extensions/                           # Extensions CPage
│   ├── CPageSupplierInternalCodeExtension.fsh
│   ├── CPageSupplierCategoryExtension.fsh
│   ├── CPageEstablishmentRegionExtension.fsh
│   └── CPageEstablishmentDepartmentExtension.fsh
├── codesystems/                          # CodeSystems CPage
│   └── CPageSupplierCategoryCodeSystem.fsh
├── valuesets/                            # ValueSets CPage
│   └── CPageSupplierCategoryValueSet.fsh
└── profiles/                             # Profils CPage
    ├── CPageSupplierProfile.fsh
    └── CPageEstablishmentProfile.fsh
```

## Dépendances

Cet IG dépend de :
- **ig-md-fhir-common** v0.1.0
  - Profils communs
  - CodeSystems partagés
  - ValueSets partagés

## Comment Utiliser ce Guide

### Pour les Implémenteurs CPage
1. Consultez **Fournisseurs CPage** pour implémenter la gestion CPage
2. Consultez **Établissements CPage** pour les spécificités géographiques
3. Référencez le **IG Commun** pour les modèles de base
4. Téléchargez les ressources et exemples

### Pour l'Architecture
1. Comprendre l'héritage depuis le commun
2. Identifier les extensions CPage-spécifiques
3. Planifier l'intégration avec d'autres modules

### Pour les Profils
- `CPageSupplierProfile` → pour créer/modifier des fournisseurs CPage
- `CPageEstablishmentProfile` → pour créer/modifier des établissements CPage

## Extensions CPage

### Fournisseurs
- `CPageSupplierInternalCodeExtension` - Code interne CPage (ex: SUP-CPA-0042)
- `CPageSupplierCategoryExtension` - Classification (local/national/healthcare/IT/logistics)

### Établissements  
- `CPageEstablishmentRegionExtension` - Région administrative (Île-de-France, PACA, etc.)
- `CPageEstablishmentDepartmentExtension` - Département (75, 93, 13, etc.)

## Caractéristiques Clés

✅ **Héritage du Commun** - Réutilisation des profils et CodeSystems  
✅ **Spécialisation CPage** - Extensions métier propriétaires  
✅ **Cohérence** - Alignement avec IG Commun  
✅ **Extensibilité** - Ajout facile de nouvelles extensions  
✅ **Traçabilité** - Codes internes + identifiants uniques  
✅ **Recherche Enrichie** - Filtrage géographique pour établissements  

## Liens Importants

- 📦 **IG Commun**: [ig-md-fhir-common](https://www.cpage.fr/ig/ig-md-fhir-common/)
- 📦 **Ce Repository**: [github.com/NicolasMoreauCPage/ig-md-fhir-cpage](https://github.com/NicolasMoreauCPage/ig-md-fhir-cpage)
- 📚 **FHIR**: [hl7.org/fhir](https://www.hl7.org/fhir/)
- 🇫🇷 **INSEE**: [insee.fr](https://www.insee.fr/)
- 🏥 **FINESS**: [data.gouv.fr](https://www.data.gouv.fr/)

## Exemple Rapide

### Créer un Fournisseur CPage avec Code Interne

```json
{
  "resourceType": "Organization",
  "meta": {
    "profile": ["https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-profile"]
  },
  "identifier": [{
    "system": "https://www.cpage.fr/fhir/CodeSystem/siret",
    "value": "12345678900000"
  }],
  "name": "Pharmalogic",
  "status": "active",
  "extension": [
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-internal-code-extension",
      "valueString": "SUP-CPA-0042"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-category-extension",
      "valueCode": "healthcare-specialist"
    }
  ]
}
```

## Prochaines Étapes

- [ ] Validation SUSHI de l'IG
- [ ] Enrichissement avec plus d'exemples
- [ ] Guides d'implémentation détaillés
- [ ] Outils de validation
- [ ] Publication et indexing

## Questions?

📧 **Contact**: contact@cpage.fr  
🌐 **Web**: https://www.cpage.fr

---

**Créé**: 2026-02-11  
**Statut**: Draft 0.1.0  
**Édité par**: CPage