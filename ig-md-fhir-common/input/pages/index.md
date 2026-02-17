# IG FHIR Commun - CPage

**Version**: 0.1.0 | **Publié**: 2026-02-11 | **Statut**: Draft

## Bienvenue

Cet **Implementation Guide (IG) FHIR Commun** définit les ressources et profils de base pour tous les logiciels du **Système d'Information Hospitalier (SIH)** de CPage.

## Architecture

Ce projet suit une **architecture multi-IG**:

```
┌─────────────────────────────────────┐
│  IG FHIR Commun (ig-md-fhir-common) │
│  • Profils et ressources partagées   │
│  • Fournisseurs (Suppliers)          │
│  • Établissements de santé (FINESS)  │
│  • CodeSystems et ValueSets communs  │
└────────┬────────────────────────────┘
         │
         └─▶ IG Spécialisé (ig-md-fhir-cpage)
            • Extensions spécifiques CPage
            • Profils enrichis
            • Cas d'usage CPage-spécifiques
```

## Ressources Modélisées

### 1. **Fournisseurs** (Supplier)
Entités responsables de la fourniture de produits dans le cadre d'un marché d'approvisionnement.

- **Ressource FHIR**: Organization
- **Profil**: [SupplierProfile](supplier.html)
- **Identifiant**: SIRET
- **Statut**: Actif/Inactif/Suspendu/Fermé/En attente
- **[En savoir plus →](supplier.html)**

### 2. **Établissements de Santé** (Establishment - FINESS)
Structures opérantes du système de santé français identifiées par leur numéro **FINESS**.

- **Ressource FHIR**: Organization
- **Profil**: [EstablishmentProfile](establishment.html)
- **Identifiant**: FINESS (11 chiffres)
- **Recherche**: Par nom d'établissement, adresse, code postal
- **[En savoir plus →](establishment.html)**

## Structure du Guide

| Section | Contenu |
|---------|---------|
| **Fournisseurs** | Modélisation complète des fournisseurs de produits |
| **Établissements** | Modélisation des établissements de santé avec FINESS |
| **Artefacts** | Tous les profils, extensions, CodeSystems et ValueSets |
| **Téléchargements** | Paquets et ressources téléchargeables |

## Concepts Clés

### CodeSystems
- **SupplierStatusCS**: Statuts possibles d'un fournisseur
- **PostalCodeCS**: Codes postaux français

### ValueSets
- **SupplierStatusVS**: Ensemble des statuts de fournisseur
- **PostalCodeVS**: Ensemble des codes postaux

### Extensions
- **SupplierStatusExtension**: Statut avancé du fournisseur
- **EstablishmentTypeExtension**: Type d'établissement de santé
- **FinessNumberExtension**: Numéro FINESS structuré

## Comment Utiliser ce Guide

### Pour les Implémenteurs
1. Consultez la section **Fournisseurs** pour implémenter la gestion des fournisseurs
2. Consultez la section **Établissements** pour implémenter la recherche de FINESS
3. Téléchargez les ressources FHIR depuis la section **Artefacts**
4. Utilisez les exemples fournis dans la documentation

### Pour les Architectes
1. Comprenez l'architecture multi-IG
2. Planifiez l'implémentation des profils communs
3. Préparez l'extension pour les besoins spécifiques via l'IG CPage

### Pour les Contributeurs
1. Consultez la section **Ressources de conformité** pour voir tous les artefacts
2. Les fichiers FSH sont disponibles dans le repository GitHub
3. Proposez des améliorations ou des extensions

## Principe de Conception

✅ **Réutilisabilité** - Ressources communes pour tous les logiciels du SIH  
✅ **Extensibilité** - Les IGs spécialisés héritent et étendent ces profils  
✅ **Maintenabilité** - Un seul lieu de définition pour les ressources communes  
✅ **Cohérence** - Interopérabilité garantie entre systèmes  
✅ **Francisation** - CodeSystems et documentation en français  

## Liens Importants

- 📦 **Repository**: [github.com/NicolasMoreauCPage/ig-md-fhir-common](https://github.com/NicolasMoreauCPage/ig-md-fhir-common)
- 🔗 **IG Spécialisé CPage**: [ig-md-fhir-cpage](https://www.cpage.fr/ig/ig-md-fhir-cpage/)
- 📚 **Ressources FHIR**: [hl7.org/fhir](https://www.hl7.org/fhir/)
- 🏥 **FINESS**: [data.gouv.fr](https://www.data.gouv.fr/)

## Questions?

Contactez l'équipe CPage: [contact@cpage.fr](mailto:contact@cpage.fr)