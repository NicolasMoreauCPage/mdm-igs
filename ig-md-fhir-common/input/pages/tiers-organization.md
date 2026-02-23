# TiersProfile - Profil de Base GEF

## Vue d'ensemble

**TiersProfile** est le profil de base pour toutes les organisations conformes aux interfaces GEF (Gestion Économique et Financière). Il hérite de **FR Core Organization** et ajoute les extensions et identifiants nécessaires pour la conformité avec les messages EFOU et KERD.

## Héritage et architecture

```
Organization (FHIR R4)
    ↓
FRCoreOrganizationProfile (FR Core 2.1.0)
    ↓
TiersProfile (ce profil - base GEF)
    ↓
    ├── FournisseurProfile (conforme EFOU 262 chars)
    └── DebiteurProfile (conforme KERD CSV)
        ↓
        ├── CPageFournisseurProfile (extensions CPage métier)
        └── CPageDebiteurProfile (extensions CPage métier)
```

## Ce que FR Core apporte

TiersProfile **hérite automatiquement** de FR Core Organization :

### Slices identifier FR Core

| Slice | System | Format | Description | OID |
|-------|--------|--------|-------------|-----|
| **siren** | urn:oid:1.2.250.1.24.3.1 | 9 chiffres | Numéro SIREN | Officiel ANS |
| **siret** | urn:oid:1.2.250.1.24.3.2 | 14 chiffres | Numéro SIRET | Officiel ANS |
| **finess** | https://finess.esante.gouv.fr | 9 caractères | Identifiant FINESS | Officiel ANS |

Ces slices sont **déjà validés et contraints** par FR Core (format, cardinalité, type).

---

## Ce que TiersProfile ajoute (Phase 1 GEF)

### Nouveaux identifier slices (6 total)

| Slice | System | Type v2-0203 | Cardinality | Description | GEF Code | Juridiction | Source Oracle |
|-------|--------|--------------|-------------|-------------|----------|-------------|---------------|
| **etierId** | urn:oid:1.2.250.1.999.1.1.1 | RI (Resource Identifier) | 0..* MS | Identifiant interne ETIER | - | FR (interne) | ECO.ETIER.IDTITI |
| **tva** | (Selon pays UE) | TAX (Tax ID) | 0..1 MS | TVA intracommunautaire | GEF #05 | UE | ECO.ETIER.TVAITI |
| **nir** | urn:oid:1.2.250.1.213.1.4.8 | NI (National ID) | 0..1 MS | NIR personne physique (15 car) | GEF #04 | FR | KERD pos 15 |
| **horsUE** | (Selon pays) | TAX (Tax ID) | 0..1 MS | Identifiant hors Union Européenne | GEF #06 | Monde | KERD pos 15 |
| **tahiti** | http://cpage.org/fhir/NamingSystem/tahiti-identifier | TAX (Tax ID) | 0..1 MS | Identifiant Polynésie française | GEF #07 | PF | KERD pos 15 |
| **ridet** | http://cpage.org/fhir/NamingSystem/ridet-identifier | TAX (Tax ID) | 0..1 MS | RIDET Nouvelle-Calédonie (7 car) | GEF #08 | NC | KERD pos 15 |

#### Notes sur les identifiants

1. **etierId** : Identifiant interne CPage, hérité de l'ancien système Oracle ECO (ETIER.IDTITI). Peut apparaître plusieurs fois (historique, synchronisations).

2. **tva** : Numéro de TVA intracommunautaire. Le system dépend du pays UE (ex: France `urn:oid:1.2.250.1.24.1.3`, Allemagne `DE...`).

3. **nir** : Numéro d'Inscription au Répertoire (Sécurité sociale française, 15 caractères). Utilisé pour les personnes physiques (Catégorie TG #01).

4. **horsUE** : Pour les organisations hors Union Européenne. Le system dépend du pays (ex: Swiss UID, US TIN, etc.).

5. **tahiti** et **ridet** : URIs **temporaires** en attente d'OID officiels :
   - **Tahiti** : Contacter DGEN (Direction Générale de l'Économie Numérique) ou ISPF (Institut de la Statistique de la Polynésie Française)
   - **RIDET** : Contacter https://www.ridet.nc/

### Extensions GEF Phase 1 (4 extensions)

#### 1. Extension tiersRole

**Extension** : TiersRoleExtension  
**URL** : `https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/tiers-role-extension`  
**Cardinalité** : 0..* MS  
**Type** : Coding (NOT CodeableConcept - utiliser `valueCoding`)  
**ValueSet** : TiersRoleVS (supplier | debtor)

Qualifie le(s) rôle(s) métier d'une organisation (fournisseur, débiteur, ou les deux).

```fsh
* extension contains TiersRoleExtension named tiersRole 0..* MS
* extension[tiersRole].valueCoding = TiersRoleCS#supplier
```

#### 2. Extension tgCategory

**Extension** : GEFTGCategoryExtension  
**URL** : `https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/gef-tg-category`  
**Cardinalité** : 0..1 MS  
**Type** : CodeableConcept  
**ValueSet** : GEFTGCategoryVS (24 codes : 00, 01, 20-29, 50, 60-65, 70-74)

Catégorie de Tiers Géré selon les secteurs d'activité GEF (État, collectivités, EPS, organismes sociaux, retraite, etc.).

```fsh
* extension contains GEFTGCategory named tgCategory 0..1 MS
* extension[tgCategory].valueCodeableConcept = GEFTGCategoryCS#27 "EPS"
```

**Références GEF** :
- EFOU position 237 (1 caractère)
- KERD position 8 (2 caractères numériques 00-74)

#### 3. Extension legalNature

**Extension** : GEFLegalNatureExtension  
**URL** : `https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/gef-legal-nature`  
**Cardinalité** : 0..1 MS  
**Type** : CodeableConcept  
**ValueSet** : GEFLegalNatureVS (12 codes : 00-11)

Nature juridique de l'organisation (particulier, société, association, État, collectivité, etc.).

```fsh
* extension contains GEFLegalNature named legalNature 0..1 MS
* extension[legalNature].valueCodeableConcept = GEFLegalNatureCS#09 "Collectivité territoriale-EPL-EPS"
```

**Références GEF** :
- EFOU position 238 (2 caractères numériques 00-11)
- KERD position 9 (2 caractères numériques 00-11)

**Règle métier** : La combinaison Catégorie TG + Nature juridique est validée par le module métier GEF (voir [Terminologies - Règles métier](terminologies.html#règles-métier-globales)).

#### 4. Extension bankAccount

**Extension** : GEFBankAccountExtension  
**URL** : `https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/gef-bank-account`  
**Cardinalité** : 0..* MS (TiersProfile), **1..* MS** (DebiteurProfile - OBLIGATOIRE pour débiteurs)  
**Type** : Complex avec 6 sub-extensions

Informations bancaires complètes (RIB français et/ou IBAN international).

##### Sub-extensions

| Sub-extension | Type | MaxLength | Description | EFOU/KERD |
|---------------|------|-----------|-------------|-----------|
| **bankCode** | string | 5 | Code banque (RIB français) | EMAF RIB |
| **branchCode** | string | 5 | Code guichet (RIB français) | EMAF RIB |
| **accountNumber** | string | 11 | Numéro de compte (RIB français) | EMAF RIB |
| **ribKey** | string | 2 | Clé RIB (RIB français) | EMAF RIB |
| **iban** | string | 34 | IBAN international | KERD IBAN |
| **bic** | string | 11 | BIC/SWIFT | KERD BIC |

```fsh
* extension contains GEFBankAccount named bankAccount 0..* MS
* extension[bankAccount][0].extension[bankCode].valueString = "30002"
* extension[bankAccount][0].extension[branchCode].valueString = "00550"
* extension[bankAccount][0].extension[accountNumber].valueString = "00000123456"
* extension[bankAccount][0].extension[ribKey].valueString = "11"
* extension[bankAccount][0].extension[iban].valueString = "FR7630002005500000012345611"
* extension[bankAccount][0].extension[bic].valueString = "SOGEFRPPXXX"
```

**Notes** :
- **RIB complet** : Les 4 champs (bankCode + branchCode + accountNumber + ribKey) sont requis ensemble pour un RIB valide
- **IBAN seul** : Suffit pour les comptes étrangers UE (ex: Allemagne DE89...)
- **Multiple bankAccount** : Possible (0..*), indexer avec [0], [1], etc.

---

## Structure complète du TiersProfile

### Identifiants (6 slices FR Core + GEF)

```
identifier:
  - [etierId] (0..* MS) : Identifiant interne ETIER (urn:oid:1.2.250.1.999.1.1.1)
  - [siren] (0..1 MS) : SIREN 9 chiffres (hérité FR Core)
  - [siret] (0..1 MS) : SIRET 14 chiffres (hérité FR Core)
  - [finess] (0..1 MS) : FINESS 9 caractères (hérité FR Core)
  - [tva] (0..1 MS) : TVA intracommunautaire (GEF #05)
  - [nir] (0..1 MS) : NIR 15 caractères personne physique (GEF #04)
  - [horsUE] (0..1 MS) : Identifiant hors Union Européenne (GEF #06)
  - [tahiti] (0..1 MS) : Identifiant Polynésie française (GEF #07, URI temporaire)
  - [ridet] (0..1 MS) : RIDET 7 caractères Nouvelle-Calédonie (GEF #08, URI temporaire)
```

### Extension GEFIdentifierType sur identifier

Sur tous les identifier slices, une extension qualifie le type selon GEF :

```fsh
* identifier.extension contains GEFIdentifierType named gefType 0..1 MS
* identifier[siret].extension[gefType].valueCodeableConcept = GEFIdentifierTypeCS#01 "SIRET"
```

**Mapping GEF Identifier Codes** :
- #01 SIRET → identifier[siret]
- #02 SIREN → identifier[siren]
- #03 FINESS → identifier[finess]
- #04 NIR → identifier[nir]
- #05 TVA → identifier[tva]
- #06 Hors UE → identifier[horsUE]
- #07 Tahiti → identifier[tahiti]
- #08 RIDET → identifier[ridet]
- #09 En cours d'immatriculation → (à créer selon besoin)

### Éléments de base (Organization FHIR)

| Élément | Cardinalité | Description | Source Oracle ECO | GEF Références |
|---------|-------------|-------------|-------------------|----------------|
| **name** | 1..1 MS | Raison sociale | ETIER.NORSTI | EFOU pos 18-32, KERD nom |
| **alias** | 0..* MS | Nom complémentaire | ETIER.COMPTI | EFOU pos 50-32 |
| **active** | 0..1 MS | Tiers actif/inactif | ETIER.VALITI (V=true, I=false) | - |
| **address** | 0..* MS | Adresse du siège | AL1STI, AL2STI, AL3STI, CPOSTI, BDISTI, PAYSTI | EFOU pos 82-146, KERD adresse |
| **telecom** | 0..* MS | Contacts (phone/email/web) | TELETI, MAILTI, SITETI | EFOU pos 183-220 |

### Extensions métier GEF (4 extensions Phase 1)

```
extension[tiersRole] (0..* MS):
  - valueCoding.code in { "supplier", "debtor" }

extension[tgCategory] (0..1 MS):
  - valueCodeableConcept from GEFTGCategoryVS (24 codes : 00-74)

extension[legalNature] (0..1 MS):
  - valueCodeableConcept from GEFLegalNatureVS (12 codes : 00-11)

extension[bankAccount] (0..* MS):
  - extension[bankCode] (0..1) : string maxLength 5
  - extension[branchCode] (0..1) : string maxLength 5
  - extension[accountNumber] (0..1) : string maxLength 11
  - extension[ribKey] (0..1) : string maxLength 2
  - extension[iban] (0..1) : string maxLength 34
  - extension[bic] (0..1) : string maxLength 11
```

---

## Exemples d'instances

### Exemple 1 : Fournisseur EPS avec SIRET et RIB complet

```fsh
Instance: ExempleFournisseurEPS
InstanceOf: FournisseurProfile
Title: "Exemple Fournisseur EPS - CHU Paris"
Description: "Hôpital public fournisseur avec SIRET, Catégorie TG #27 EPS, RIB+IBAN+BIC complet"

* identifier[etierId].value = "ETIER123456"
* identifier[siret].value = "12345678901234"

* name = "Centre Hospitalier Universitaire de Paris"
* alias = "CHU Paris"
* active = true

* address.line = "1 Avenue de l'Hôpital"
* address.city = "Paris"
* address.postalCode = "75001"
* address.country = "FR"

* telecom[0].system = #phone
* telecom[0].value = "0140123456"
* telecom[1].system = #email
* telecom[1].value = "contact@chu-paris.fr"

* extension[tiersRole].valueCoding = TiersRoleCS#supplier
* extension[tgCategory].valueCodeableConcept = GEFTGCategoryCS#27 "EPS"
* extension[legalNature].valueCodeableConcept = GEFLegalNatureCS#09 "Collectivité territoriale-EPL-EPS"

* extension[bankAccount][0].extension[bankCode].valueString = "30002"
* extension[bankAccount][0].extension[branchCode].valueString = "00550"
* extension[bankAccount][0].extension[accountNumber].valueString = "00000123456"
* extension[bankAccount][0].extension[ribKey].valueString = "11"
* extension[bankAccount][0].extension[iban].valueString = "FR7630002005500000012345611"
* extension[bankAccount][0].extension[bic].valueString = "SOGEFRPPXXX"
```

**Conformité GEF** :
- ✅ EFOU position 223-14 SIRET
- ✅ EFOU position 237 Catégorie TG #27
- ✅ EFOU position 238 Nature juridique #09
- ✅ EMAF RIB complet (4 champs)

---

### Exemple 2 : Fournisseur TVA Union Européenne

```fsh
Instance: ExempleFournisseurTVA
InstanceOf: FournisseurProfile
Title: "Exemple Fournisseur TVA UE - MedTech GmbH"
Description: "Fournisseur allemand avec TVA intracommunautaire, Catégorie TG #50, IBAN DE"

* identifier[etierId].value = "ETIER789012"
* identifier[tva].value = "DE123456789"

* name = "MedTech Solutions GmbH"
* alias = "MedTech"
* active = true

* address.line = "Berliner Straße 123"
* address.city = "Berlin"
* address.postalCode = "10115"
* address.country = "DE"

* telecom[0].system = #phone
* telecom[0].value = "+4930123456"

* extension[tiersRole].valueCoding = TiersRoleCS#supplier
* extension[tgCategory].valueCodeableConcept = GEFTGCategoryCS#50 "Personne morale de droit privé"
* extension[legalNature].valueCodeableConcept = GEFLegalNatureCS#03 "Société"

* extension[bankAccount][0].extension[iban].valueString = "DE89370400440532013000"
* extension[bankAccount][0].extension[bic].valueString = "COBADEFFXXX"
```

**Conformité GEF** :
- ✅ KERD position 15 TVA intracommunautaire (GEF #05)
- ✅ KERD position 8 Catégorie TG #50
- ✅ KERD IBAN étranger mandatory pour UE

---

### Exemple 3 : Débiteur personne physique avec NIR

```fsh
Instance: ExempleDebiteurPersonnePhysique
InstanceOf: DebiteurProfile
Title: "Exemple Débiteur Personne Physique - Jean Dupont"
Description: "Personne physique débiteur avec NIR, Civilité M, Type débiteur N"

* identifier[etierId].value = "ETIER345678"
* identifier[nir].value = "123456789012345"

* name = "Monsieur Jean Dupont"
* active = true

* address.line = "15 Rue de la République"
* address.city = "Lyon"
* address.postalCode = "69001"
* address.country = "FR"
* address.extension[localization].valueCode = GEFAddressLocalizationCS#FRANCE

* telecom[0].system = #phone
* telecom[0].value = "0612345678"

* extension[tiersRole].valueCoding = TiersRoleCS#debtor
* extension[tgCategory].valueCodeableConcept = GEFTGCategoryCS#01 "Personne physique"
* extension[legalNature].valueCodeableConcept = GEFLegalNatureCS#01 "Particulier"

// Phase 2 Extensions (DebiteurProfile)
* extension[debtorType].valueCode = GEFDebtorTypeCS#N
* extension[personDetails].extension[civility].valueCode = GEFCivilityCS#M
* extension[personDetails].extension[firstName].valueString = "Jean"

* extension[bankAccount][0].extension[iban].valueString = "FR7612345678901234567890123"
* extension[bankAccount][0].extension[bic].valueString = "CRLYFRPPXXX"
```

**Conformité GEF** :
- ✅ KERD position 15 NIR (GEF #04) 15 caractères
- ✅ KERD position 8 Catégorie TG #01 (Personne physique)
- ✅ KERD position 10 Civilité M (OBLIGATOIRE si Catégorie TG #01)
- ✅ KERD position 11 Prénom "Jean"
- ✅ KERD position 2 Type débiteur N
- ✅ KERD IBAN mandatory (1..* MS sur DebiteurProfile)

---

### Exemple 4 : Fournisseur RIDET Nouvelle-Calédonie

```fsh
Instance: ExempleFournisseurRIDET
InstanceOf: FournisseurProfile
Title: "Exemple Fournisseur RIDET NC - SCME Nouméa"
Description: "Fournisseur Nouvelle-Calédonie avec RIDET, Catégorie TG #50"

* identifier[etierId].value = "ETIER567890"
* identifier[ridet].value = "1234567"

* name = "Société Calédonienne de Materiel Médical"
* alias = "SCMM"
* active = true

* address.line = "10 Avenue du Pacifique"
* address.city = "Nouméa"
* address.postalCode = "98800"
* address.country = "NC"

* telecom[0].system = #phone
* telecom[0].value = "+68712345"

* extension[tiersRole].valueCoding = TiersRoleCS#supplier
* extension[tgCategory].valueCodeableConcept = GEFTGCategoryCS#50 "Personne morale de droit privé"
* extension[legalNature].valueCodeableConcept = GEFLegalNatureCS#03 "Société"

* extension[bankAccount][0].extension[bankCode].valueString = "18506"
* extension[bankAccount][0].extension[accountNumber].valueString = "98765432101"
```

**Conformité GEF** :
- ✅ KERD position 15 RIDET (GEF #08) 7 caractères Nouvelle-Calédonie
- ✅ KERD country = "NC" (ISO 3166 Nouvelle-Calédonie)
- ⚠️ RIDET URI temporaire (attente OID officiel https://www.ridet.nc/)

---

## Profils dérivés

### FournisseurProfile (conforme EFOU)

Hérite de TiersProfile et ajoute :
- Extension GEFIdentifierType sur `identifier` (qualifier le type SIRET/SIREN/etc.)
- Documentation complète des positions EFOU 1-262

Voir [FournisseurProfile](StructureDefinition-fournisseur-profile.html)

### DebiteurProfile (conforme KERD)

Hérite de TiersProfile et ajoute :
- **bankAccount 1..* MS** (OBLIGATOIRE pour débiteurs)
- **7 extensions Phase 2** : debtorType (1..1 MS O/N), publicAccountingCounterpart, regieCode, chorusIdentifierType, debtorFlags, personDetails, addressLocalization
- Documentation complète des colonnes CSV KERD

Voir [DebiteurProfile](StructureDefinition-debiteur-profile.html)

---

## Règles métier importantes

### 1. Combinaison Catégorie TG + Nature juridique

Le module métier GEF valide les combinaisons autorisées. Exemples :

| Catégorie TG | Code | Natures juridiques autorisées | Codes |
|--------------|------|-------------------------------|-------|
| Inconnue | 00 | Toutes | 00-11 |
| Personne physique | 01 | Inconnue, Particulier, Artisan-Commerçant | 00, 01, 02 |
| EPS | 27 | Collectivité territoriale-EPL-EPS | 09 |
| Personne morale privé | 50 | Société, Association | 03, 06 |

Voir [Terminologies - Règles métier](terminologies.html#règles-métier-globales) pour la liste complète.

### 2. Identifiant obligatoire selon Catégorie TG

- **Catégorie TG #01** (Personne physique) → **NIR obligatoire** (identifier[nir])
- **Catégorie TG #27** (EPS) → **FINESS recommandé** (identifier[finess])
- **Catégorie TG #50** (Personne morale privé) → **SIRET/SIREN obligatoire** (identifier[siret] ou identifier[siren])

### 3. RIB vs IBAN

- **RIB complet** (bankCode + branchCode + accountNumber + ribKey) : Comptes français
- **IBAN seul** : Comptes étrangers UE (suffisant)
- **bankAccount 1..* MS** : OBLIGATOIRE pour DebiteurProfile (domiciliation recettes)

### 4. GEFPersonDetails obligatoire si Catégorie TG = 01

Si Catégorie TG #01 (Personne physique), l'extension GEFPersonDetails avec civility + firstName est **obligatoire** (règle métier KERD position 10-11).

Voir [DebiteurProfile - Extensions Phase 2](StructureDefinition-debiteur-profile.html#phase-2-extensions-debitorat).

---

## Liens vers ressources FHIR

### Profils
- **TiersProfile** : [StructureDefinition](StructureDefinition-tiers-profile.html)
- **FournisseurProfile** : [StructureDefinition](StructureDefinition-fournisseur-profile.html)
- **DebiteurProfile** : [StructureDefinition](StructureDefinition-debiteur-profile.html)

### Extensions Phase 1
- **TiersRoleExtension** : [StructureDefinition](StructureDefinition-tiers-role-extension.html)
- **GEFTGCategoryExtension** : [StructureDefinition](StructureDefinition-gef-tg-category.html)
- **GEFLegalNatureExtension** : [StructureDefinition](StructureDefinition-gef-legal-nature.html)
- **GEFBankAccountExtension** : [StructureDefinition](StructureDefinition-gef-bank-account.html)
- **GEFIdentifierTypeExtension** : [StructureDefinition](StructureDefinition-gef-identifier-type.html)

### Terminologies
- **GEFIdentifierTypeCS** (9 codes) : [CodeSystem](CodeSystem-gef-identifier-type-cs.html)
- **GEFTGCategoryCS** (24 codes) : [CodeSystem](CodeSystem-gef-tg-category-cs.html)
- **GEFLegalNatureCS** (12 codes) : [CodeSystem](CodeSystem-gef-legal-nature-cs.html)
- **TiersRoleCS** (2 codes) : [CodeSystem](CodeSystem-tiers-role-cs.html)

### NamingSystems
- **TahitiIdentifierNamingSystem** : [NamingSystem](NamingSystem-tahiti-identifier-ns.html) (URI temporaire)
- **RIDETIdentifierNamingSystem** : [NamingSystem](NamingSystem-ridet-identifier-ns.html) (URI temporaire)

### Instances de test
- **ExempleFournisseurEPS** : [Organization](Organization-ExempleFournisseurEPS.html)
- **ExempleFournisseurTVA** : [Organization](Organization-ExempleFournisseurTVA.html)
- **ExempleDebiteurPersonnePhysique** : [Organization](Organization-ExempleDebiteurPersonnePhysique.html)
- **ExempleDebiteurEPSPublic** : [Organization](Organization-ExempleDebiteurEPSPublic.html)
- **ExempleFournisseurRIDET** : [Organization](Organization-ExempleFournisseurRIDET.html)

### FR Core Organization
- **FRCoreOrganizationProfile** : [HL7 France](https://hl7.fr/ig/fhir/core/StructureDefinition-fr-core-organization.html)
