# 📝 Mise à Jour - Support Format Legacy CPage

**Date**: 2026-02-11  
**Projet**: `ig-md-fhir-cpage`  
**Objectif**: Intégrer le format legacy CPage pour les fournisseurs

---

## 📦 Fichiers Créés/Modifiés

### ✨ Nouveaux Fichiers (2)

#### 📄 `input/fsh/codesystems/CPageSupplierIdentifierTypeCodeSystem.fsh`
**Objectif**: Classifier les types d'identifiants utilisés pour les fournisseurs  
**Codes**: 9 types (SIRET, SIREN, FINESS, NIR, TVA, FOREIGN, TAHITI, RIDET, PENDING)  
**URL**: `https://www.cpage.fr/fhir/CodeSystem/cpage-supplier-identifier-type`  

Format Legacy Mapping: Position 239-243 (5 caractères)

**Codes disponibles**:
- `01` = SIRET (14 chiffres)
- `02` = SIREN (9 chiffres)
- `03` = FINESS (11 chiffres)
- `04` = NIR
- `05` = TVA intracommunautaire
- `06` = Identifiant hors UE
- `07` = N° Tahiti
- `08` = RIDET (Nouméa)
- `09` = En cours d'immatriculation

#### 📄 `input/fsh/valuesets/CPageSupplierIdentifierTypeValueSet.fsh`
**Objectif**: Regrouper tous les types d'identifiants  
**URL**: `https://www.cpage.fr/fhir/ValueSet/cpage-supplier-identifier-type`  
**Référence**: CPageSupplierIdentifierTypeCodeSystem

#### 📄 `input/fsh/extensions/CPageSupplierEHCodeExtension.fsh`
**Objectif**: Stocker le code EH du format legacy  
**Type**: String (2 caractères)  
**URL**: `https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-eh-code-extension`  

Format Legacy Mapping: Position 2-3 (2 caractères)

**Exemple**: `valueString value="C"`

#### 📄 `input/fsh/extensions/CPageSupplierIdentifierTypeExtension.fsh`
**Objectif**: Clarifier le type d'identifiant sur chaque identifiant  
**Type**: Code (depuis CodeSystem)  
**URL**: `https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-identifier-type-extension`  
**Contexte**: `Organization.identifier`

Format Legacy Mapping: Position 239-243 (5 caractères)

**Usage**: Sur chaque élément `identifier` pour spécifier son type

---

## 🔄 Fichiers Modifiés (1)

### ✏️ `input/fsh/profiles/CPageSupplierProfile.fsh`

**Changements**:
1. Documentation enrichie du profil
2. Ajout de nouveaux éléments sur `identifier`:
   - Extension `identifierType` sur chaque identifier
   - Documentation clarifiée des systèmes et valeurs
3. Documentation des champs `telecom` et `address` alignée avec format legacy
4. Ajout de la nouvelle extension `cpageEHCode` (Code EH)

**Avant**: 3 extensions  
**Après**: 4 extensions (+cpageEHCode)

**Extensions du Profil**:
- `supplierStatus` (du commun) - 1..1 MS
- `cpageInternalCode` (CPage) - 0..1 MS
- `cpageCategory` (CPage) - 0..1 MS
- `cpageEHCode` (CPage) - 0..1 MS ← **NOUVEAU**

**Extensions sur identifier**:
- `identifierType` (CPage) - 0..1 MS ← **NOUVEAU**

### ✏️ `input/pages/cpage-supplier/cpage-supplier.md`

**Transformation complète** pour intégrer le format legacy:

1. **Tableau de Correspondance Legacy ↔ FHIR**
   - 14 lignes mapping positions/longueurs legacy vers éléments FHIR
   - Clarté sur comment transformer les données

2. **Sections pour chaque extension**:
   - Code EH (position 2-3)
   - Type identifiant (position 239-243)
   - Code interne CPage (position 237-238)
   - Catégorie CPage (nouvelle)

3. **Exemple détaillé de migration**:
   - Format legacy brut (enregistrement fixe)
   - Données JSON FHIR mappées (avec tous les champs)

4. **Tableau de validation** pour chaque type d'identifiant

5. **Cas d'erreur courants** avec mauvais/bon exemples

---

## 🔗 Architecture Legacy ↔ FHIR

### Format Legacy CPage (Enregistrement Fixe)

```
Position  Longueur  Champ                    Valeur Exemple
1         1         Zone opération           C
2-3       2         Code EH                  C
4-17      14        Numéro fournisseur       12345678900145 (SIRET)
18-49     32        Nom fournisseur          Pharmalogic SARL
50-81     32        Raison sociale          [idem]
82-113    32        Numéro et rue            15 Rue de la Santé
114-145   32        Complément adresse       [vide]
146-150   5         Code postal              44000
151-182   32        Bureau distributeur      Nantes
183-202   20        Téléphone                0243506070
203-222   20        Télécopie                0243506071
223-236   14        Code SIRET               12345678900145
237-238   2         Code fournisseur         C0
239-243   5         Type identifiant         01 (SIRET)
244-261   18        Identifiant fournisseur  12345678900145
```

### Mappage vers FHIR Organization

| Legacy | FHIR | Element | Mapping |
|--------|------|---------|---------|
| Zone opération | N/A | (transport) | Non utilisé |
| Code EH | extension[cpageEHCode] | String | `valueString="C"` |
| Numéro fournisseur | identifier[].value | 14 char | Premier identifiant |
| Nom fournisseur | name | String | `name="Pharmalogic SARL"` |
| Raison sociale | name | String | `name` (alias) |
| Num + rue | address[].line[0] | String | `line[0]="15 Rue de la Santé"` |
| Complément | address[].line[1] | String | `line[1]` |
| Code postal | address[].postalCode | Code | `postalCode="44000"` |
| Bureau distributeur | address[].city | String | `city="Nantes"` |
| Téléphone | telecom[system=phone] | String | `telecom[system="phone", value="0243506070"]` |
| Télécopie | telecom[system=fax] | String | `telecom[system="fax", value="0243506071"]` |
| Code SIRET | identifier[system=siret] | 14 char | `identifier[system="...siret", value="12345678900145"]` |
| Code fournisseur | extension[cpageInternalCode] | String | `valueString="C0"` |
| Type identifiant | identifier[].extension[identifierType] | Code | `extension[valueCode="01"]` |
| Identifiant fourni | identifier[].value | 18 char | Valeur complète |

---

## 📊 Statistiques Mises à Jour

### IG CPage - Avant

| Catégorie | Nombre |
|-----------|--------|
| CodeSystems | 1 |
| ValueSets | 1 |
| Extensions | 4 |
| Profils | 2 |
| **Total FSH** | **8** |

### IG CPage - Après

| Catégorie | Nombre | Delta |
|-----------|--------|-------|
| CodeSystems | **2** | +1 (**IdentifierType**) |
| ValueSets | **2** | +1 (**IdentifierType**) |
| Extensions | **6** | +2 (**EHCode** + **IdentifierType**) |
| Profils | 2 | - |
| **Total FSH** | **12** | **+4** |

---

## 🎯 Extensions CPage pour Fournisseurs

### Résumé Complet

| Extension | Type | Required | Usage | Legacy Mapping |
|-----------|------|----------|-------|---------|
| `cpageInternalCode` | String | Non | Code interne CPage | Pos 237-238 |
| `cpageEHCode` | String | Non | Code EH (2 car) | Pos 2-3 |
| `cpageCategory` | Code | Non | Classification métier | Nouvelle |
| `identifierType` | Code | Non | Type ID (SIRET, SIREN) | Pos 239-243 |

### Utilité de Chaque Extension

1. **cpageInternalCode**: Mapping système CPage ← → Legacy  
   Format: 2 caractères (ex: "C0", "A1")

2. **cpageEHCode**: Préservation structure legacy  
   Format: Code établissement 2 caractères (ex: "C")

3. **cpageCategory**: Classification métier **nouvelle**  
   Codes: local, national, healthcare-specialist, it-provider, logistics, etc.

4. **identifierType**: Clarifier QUEL identifiant (SIRET vs SIREN vs FINESS)  
   Codes: 01-09 pour standardiser les types

---

## 💡 Utilité du Nouveau CodeSystem

**Problème Legacy**: Position 239-243 contenait un code numérique (01-09) pour le type d'ID, mais ce n'était jamais forcément exploitable dans FHIR.

**Solution FHIR**: 
- CodeSystem `CPageSupplierIdentifierTypeCS` standardise les 9 types
- Extension `CPageSupplierIdentifierTypeExtension` sur chaque `identifier`
- Permet requête: "chercher tous les fournisseurs avec SIRET" et non "tous les fournisseurs avec position 239-243 = '01'"

**Avantage**: Exploitabilité programmatique + sémantique claire

---

## 🔍 Exemple Complet de Conversion

### Données Legacy (Format Fixe)

```
C    1234567890014Pharmalogic SARL         Pharmalogic              15 Rue de la Santé                 Nantes              44000Nantes            0243506070          0243506071          1234567890014C  01  1234567890014
```

### Conversion Étape par Étape

1. **Extraction des champs**:
   - Zone opération: `C`
   - Code EH: `C` (pos 2-3)
   - Numéro fournisseur: `1234567890014` (pos 4-17)
   - Nom: `Pharmalogic SARL` (pos 18-49)
   - ... etc ...
   - Type ID: `01` (pos 239-243)
   - Identifiant: `1234567890014` (pos 244-261)

2. **Mappage FHIR**:
   ```json
   {
     "resourceType": "Organization",
     "meta": {
       "profile": ["...cpage-supplier-profile"]
     },
     "identifier": [
       {
         "system": "...siret",
         "value": "1234567890014",
         "extension": [
           {
             "url": "...cpage-supplier-identifier-type-extension",
             "valueCode": "01"
           }
         ]
       }
     ],
     "name": "Pharmalogic SARL",
     "status": "active",
     "address": [...],
     "telecom": [...],
     "extension": [
       {
         "url": "...cpage-supplier-eh-code-extension",
         "valueString": "C"
       },
       {
         "url": "...cpage-supplier-internal-code-extension",
         "valueString": "C"
       }
     ]
   }
   ```

---

## 🚀 Prochaines Étapes

1. **Valider SUSHI**: `sushi build` dans ig-md-fhir-cpage/
2. **Tester le mappage**: Écrire conversions legacy → FHIR
3. **Documenter les cas**: Plus de 9 types d'ID supportés
4. **Performance**: Indexer sur `identifier.value` + extension
5. **Migration**: Scriptlets de conversion pour données existantes

---

## 📖 Ressources de Référence

- **Profil Mis à Jour**: [CPageSupplierProfile](artifacts.html#Structure-Definition-cpage-supplier-profile)
- **CodeSystem Types ID**: [CPageSupplierIdentifierTypeCS](artifacts.html#CodeSystem-cpage-supplier-identifier-type-cs)
- **Documentation Fournisseurs**: [cpage-supplier.md](cpage-supplier.html)
- **Format Legacy Mapping**: Voir tableau de correspondance dans documentation

---

**Status**: ✅ Support Legacy Intégré  
**Version**: 0.1.0  
**Prêt pour**: Validation SUSHI + Tests de migration