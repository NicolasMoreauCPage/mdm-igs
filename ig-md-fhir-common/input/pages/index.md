# IG FHIR Tiers MDM - Conformité GEF

**Version**: 0.1.0 | **Date**: 23 février 2026 | **Statut**: Draft

## Bienvenue

Cet **Implementation Guide FHIR** définit les profils et ressources FHIR pour la gestion des **Tiers** (organisations, fournisseurs, débiteurs) en conformité avec les **interfaces GEF (Gestion Économique et Financière)** utilisées dans le secteur hospitalier français.

Ce guide est **vendor-neutral** et **interopérable**, basé sur **FR Core Organization 2.1.0**, et sert de socle pour les IG spécialisés.

## Objectif : Interopérabilité GEF

Les **interfaces GEF** sont des formats d'échange standardisés utilisés entre systèmes hospitaliers pour synchroniser les données de tiers :
- **EFOU** : Extraction Fournisseurs (format texte fixe, 262 caractères)
- **KERD** : Intégration Débiteurs (format CSV)
- **EMAF** : Extraction Marchés Fournisseurs (contrats)

Ce guide fournit une **représentation FHIR complète** de ces formats pour permettre :
✅ Mapping bidirectionnel GEF ↔ FHIR  
✅ Validation des données selon nomenclatures GEF officielles  
✅ Interopérabilité entre systèmes hospitaliers  
✅ Modernisation progressive des échanges (GEF legacy → FHIR moderne)

## Architecture Multi-IG

```
┌──────────────────────────────────────────────┐
│  FR Core 2.1.0 (HL7 France)                 │
│  • FRCoreOrganizationProfile                │
│  • Slices SIREN, SIRET, FINESS               │
└────────┬─────────────────────────────────────┘
         │
         ├─▶ ┌───────────────────────────────────────────────┐
         │   │ ig-md-fhir-common (ce guide)                 │
         │   │ CONFORMITÉ GEF - Interopérabilité externe    │
         │   │ • TiersProfile (base GEF)                    │
         │   │ • FournisseurProfile (EFOU-compliant)        │
         │   │ • DebiteurProfile (KERD-compliant)           │
         │   │ • 12 Extensions GEF (banking, identifiers,   │
         │   │   debtor-specific)                           │
         │   │ • 8 CodeSystems GEF (46 codes totaux)        │
         │   │ • 2 NamingSystems (Tahiti, RIDET)            │
         │   └────────┬──────────────────────────────────────┘
         │            │
         └────────────┴─▶ ┌──────────────────────────────────┐
                          │ ig-md-fhir-cpage (spécialisé)    │
                          │ ENRICHISSEMENTS CPAGE - Interne   │
                          │ • CPageFournisseurProfile        │
                          │ • CPageDebiteurProfile           │
                          │ • Extensions métier CPage        │
                          │ • Chorus, comptabilité, ASAP     │
                          └──────────────────────────────────┘
```

**Principe de séparation** :
- **ig-md-fhir-common** = Conformité GEF stricte (interop externe, vendor-neutral)
- **ig-md-fhir-cpage** = Enrichissements propriétaires CPage (métier interne)

## Contenu de ce Guide

### Profils FHIR

#### [TiersProfile](StructureDefinition-tiers-profile.html)
Profil de base conforme GEF pour tout type de tiers. Hérite de FR Core Organization.
- **9 types d'identifiants** : SIRET, SIREN, FINESS, NIR, TVA, Hors UE, Tahiti, RIDET, En cours
- **Classification GEF** : Catégorie TG (24 codes), Nature juridique (12 codes)
- **Banking** : RIB/IBAN (6 sous-extensions)

#### [FournisseurProfile](StructureDefinition-fournisseur-profile.html)
Profil fournisseur conforme au message **EFOU** (Extraction Fournisseurs, positions 1-262).
- Hérite de TiersProfile
- Extensions qualifiant type identifiant GEF
- Mapping complet vers format texte fixe EFOU

#### [DebiteurProfile](StructureDefinition-debiteur-profile.html)
Profil débiteur conforme au message **KERD** (Intégration Débiteurs CSV).
- Hérite de TiersProfile
- **7 extensions spécifiques débitorat** :
  - Type débiteur (Occasionnel/Normal)
  - Compte contrepartie comptabilité publique
  - Code régie
  - Type identifiant CHORUS
  - Attributs débiteur (laboratoire, locataire, agent)
  - Détails personne physique (civilité, prénom)
  - Localisation adresse (France/Europe/Autre)
- RIB obligatoire (1..* MS)

### Terminologies GEF

#### Phase 1 - Fondations
- **GEFIdentifierTypeCS** (9 codes) : Types d'identifiants GEF 01-09
- **GEFTGCategoryCS** (24 codes) : Catégories tiers (État, régions, EPS, organismes sociaux, etc.)
- **GEFLegalNatureCS** (12 codes) : Natures juridiques (particulier, société, association, etc.)

#### Phase 2 - Débitorat
- **GEFDebtorTypeCS** (2 codes) : Occasionnel (O) / Normal (N)
- **GEFCivilityCS** (5 codes) : M, MME, MLLE, METMME, MOUMME
- **GEFChorusIdentifierTypeCS** (8 codes) : Types identifiants CHORUS 01-08 (sans 09)
- **GEFAddressLocalizationCS** (3 codes) : FRANCE, EUROPE, AUTRE

📊 **Total** : 8 CodeSystems, 54 codes, 12 extensions, 8 ValueSets

### NamingSystems Territoires d'Outre-Mer

#### [TahitiIdentifierNamingSystem](NamingSystem-tahiti-identifier-ns.html)
Système d'identification pour Polynésie française (PF).
- URI temporaire : `http://cpage.org/fhir/NamingSystem/tahiti-identifier`
- ⚠️ OID officiel à acquérir auprès de DGEN/ISPF

#### [RIDETIdentifierNamingSystem](NamingSystem-ridet-identifier-ns.html)
RIDET - Répertoire d'IDEntification des Entreprises et des Établissements (Nouvelle-Calédonie NC).
- URI temporaire : `http://cpage.org/fhir/NamingSystem/ridet-identifier`
- ⚠️ OID officiel à acquérir auprès de https://www.ridet.nc/

### Instances de Test

5 exemples fonctionnels illustrant tous les cas d'usage GEF :
- **ExempleFournisseurEPS** : CHU avec SIRET + RIB complet (Catégorie TG 27)
- **ExempleFournisseurTVA** : Société allemande avec TVA intracommunautaire
- **ExempleDebiteurPersonnePhysique** : Particulier avec NIR + Civilité M + Prénom (obligatoire TG 01)
- **ExempleDebiteurEPSPublic** : Hôpital avec FINESS + compte contrepartie + code régie (CHORUS)
- **ExempleFournisseurRIDET** : Société calédonienne avec RIDET (overseas NC)

### [Mapping GEF](mapping.html)

Tables complètes de correspondance :
- EFOU positions 1-262 → FournisseurProfile
- KERD colonnes CSV → DebiteurProfile
- Règles métier GEF (combinaisons Catégorie TG × Nature juridique)

## Implémentation

### Pour les Éditeurs de Logiciels Hospitaliers

1. **Lecture GEF → FHIR** : Parser EFOU/KERD → créer ressources Organization conformes aux profils
2. **Écriture FHIR → GEF** : Lire ressources FHIR → générer fichiers EFOU/KERD
3. **Validation** : Contrôler avec ValueSets GEF (bindings required)
4. **Extensions** : Implémenter toutes les extensions GEF pour couverture complète

### Pour les Intégrateurs

1. Consommer les profils comme contrat d'interface FHIR
2. Valider les données échangées contre les StructureDefinitions
3. Respecter les cardinalités (ex: RIB 1..* obligatoire pour débiteurs)
4. Implémenter règles métier (ex: civilité+prénom obligatoire si Catégorie TG=01)

## Conformité et Validation

✅ **SUSHI v3.16.3** : 0 erreurs, 0 warnings  
✅ **FHIR R4 4.0.1** : Full compliance  
✅ **FR Core 2.1.0** : Héritage correct  
✅ **GEF Coverage** : EFOU (100%), KERD (100%), EMAF (Phase 4)

## Liens et Ressources

- 📦 **Repository GitHub** : [github.com/NicolasMoreauCPage/mdm-igs](https://github.com/NicolasMoreauCPage/mdm-igs)
- 🔗 **IG Spécialisé CPage** : ig-md-fhir-cpage
- 🇫🇷 **FR Core 2.1.0** : [hl7.fr/ig/fhir/core](https://hl7.fr/ig/fhir/core/)
- 📚 **FHIR R4** : [hl7.org/fhir/R4](https://www.hl7.org/fhir/R4/)
- 📄 **Documentation GEF** : interfacesGEF.txt (172 pages)

## Statut et Roadmap

### Phase 1 ✅ Complétée (11 fév 2026)
- GEFIdentifierType, GEFBankAccount, GEFTGCategory, GEFLegalNature
- TiersProfile avec 6 identifier slices
- FournisseurProfile, DebiteurProfile
- NamingSystems Tahiti/RIDET

### Phase 2 ✅ Complétée (23 fév 2026)
- 7 extensions débitorat
- 4 terminologies (DebtorType, Civility, ChorusIdentifierType, AddressLocalization)
- Intégration complète dans DebiteurProfile

### Phase 3 ✅ Complétée (23 fév 2026)
- 5 instances de test fonctionnelles
- Compilation 0 erreurs / 0 warnings

### Phase 4 ⏳ À venir
- Support EMAF (contrats fournisseurs - Contract resource)
- Acquisition OIDs officiels Tahiti/RIDET
- Documentation mappings détaillée
- Génération snapshots IG Publisher

## Contact

**Équipe CPage MasterData**  
📧 contact@cpage.fr  
🌐 https://www.cpage.fr
