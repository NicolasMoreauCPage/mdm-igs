# Terminologies GEF

Cette page documente les **8 CodeSystems** et **8 ValueSets** définis dans l'IG Tiers MDM pour la conformité aux interfaces GEF (Gestion Économique et Financière).

## Navigation rapide

- [Phase 1 - Terminologies Fondations](#phase-1---terminologies-fondations)
  - [GEFIdentifierTypeCS](#gefidentifiertypecs---types-didentifiants-gef-9-codes) (9 codes)
  - [GEFTGCategoryCS](#geftgcategorycs---catégories-tg-24-codes) (24 codes)
  - [GEFLegalNatureCS](#geflegalnaturecs---natures-juridiques-12-codes) (12 codes)
  - [TiersRoleCS](#tiersrolecs---rôles-tiers-2-codes) (2 codes)
- [Phase 2 - Terminologies Débitorat](#phase-2---terminologies-débitorat)
  - [GEFDebtorTypeCS](#gefdebtortypecs---types-débiteur-2-codes) (2 codes)
  - [GEFCivilityCS](#gefcivilitycs---civilités-5-codes) (5 codes)
  - [GEFChorusIdentifierTypeCS](#gefchorusidentifiertypecs---types-identifiant-chorus-8-codes) (8 codes)
  - [GEFAddressLocalizationCS](#gefaddresslocalizationcs---localisation-adresse-3-codes) (3 codes)

---

## Phase 1 - Terminologies Fondations

### GEFIdentifierTypeCS - Types d'identifiants GEF (9 codes)

**ID** : `gef-identifier-type-cs`  
**URL** : `https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/gef-identifier-type-cs`  
**Status** : Active  
**Content** : Complete

#### Description

Types d'identifiants organisationnels et personnels utilisés dans les messages GEF (EFOU, KERD).

#### Codes

| Code | Libellé | Longueur | Références | Système OID/URI | Juridiction |
|------|---------|----------|------------|----------------|-------------|
| **01** | SIRET | 14 caractères | EFOU position 223, KERD position 15 | urn:oid:1.2.250.1.24.3.2 | FR |
| **02** | SIREN | 9 caractères | KERD position 15 | urn:oid:1.2.250.1.24.3.1 | FR |
| **03** | FINESS | 9 caractères | KERD position 15 | https://finess.esante.gouv.fr | FR |
| **04** | NIR | 15 caractères | KERD position 15, personne physique | urn:oid:1.2.250.1.213.1.4.8 | FR |
| **05** | TVA Intracommunautaire | Variable | KERD position 15, UE hors France | (Selon pays UE) | UE |
| **06** | Hors UE | Variable | KERD position 15, hors Europe | (Selon pays) | Monde |
| **07** | Tahiti | Variable | KERD position 15, Polynésie française | http://cpage.org/fhir/NamingSystem/tahiti-identifier (temp) | PF |
| **08** | RIDET | 7 caractères | KERD position 15, Nouvelle-Calédonie | http://cpage.org/fhir/NamingSystem/ridet-identifier (temp) | NC |
| **09** | En cours d'immatriculation | - | KERD position 15, provisoire | - | - |

#### Notes importantes

- **Codes 07 et 08** : URIs temporaires en attente d'OID officiels (Tahiti : DGEN/ISPF, RIDET : https://www.ridet.nc/)
- **Code 09** : Exclut de GEFChorusIdentifierTypeCS (non valide pour CHORUS)
- **Usage** : Extension GEFIdentifierTypeExtension sur `identifier.extension`

#### Exemple d'utilisation

```fsh
// Fournisseur avec SIRET
* identifier[siret].value = "12345678901234"
* identifier[siret].extension contains GEFIdentifierType named gefType 0..1
* identifier[siret].extension[gefType].valueCodeableConcept = GEFIdentifierTypeCS#01

// Débiteur avec NIR
* identifier[nir].value = "123456789012345"
* identifier[nir].extension contains GEFIdentifierType named gefType 0..1
* identifier[nir].extension[gefType].valueCodeableConcept = GEFIdentifierTypeCS#04
```

---

### GEFTGCategoryCS - Catégories TG (24 codes)

**ID** : `gef-tg-category-cs`  
**URL** : `https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/gef-tg-category-cs`  
**Status** : Active  
**Content** : Complete

#### Description

Classification des organisations par **Catégorie de Tiers Gérés (TG)** selon les secteurs d'activité et statuts juridiques du système GEF.

#### Codes par secteur

##### Secteur : Inconnu / Générique

| Code | Libellé | Description |
|------|---------|-------------|
| **00** | Catégorie TG inconnue | Catégorie non renseignée ou indéterminée |
| **01** | Personne physique | Individu (patient, personne privée) |
| **50** | Personne morale de droit privé | Société, entreprise, association, etc. |

##### Secteur : État et collectivités (20-29)

| Code | Libellé | Description |
|------|---------|-------------|
| **20** | État | Ministères, services de l'État français |
| **21** | Région | Conseils régionaux |
| **22** | Département | Conseils départementaux |
| **23** | Commune | Mairies, communes françaises |
| **24** | CCAS | Centre Communal d'Action Sociale |
| **25** | Autre établissement public local | EPL hors santé |
| **26** | Centre de rééducation fonctionnelle | CRF spécialisés |
| **27** | EPS | Établissement Public de Santé (hôpitaux publics) |
| **28** | ENSP | École Nationale de la Santé Publique |
| **29** | Autre établissement public de l'État | EPA, EPIC |

##### Secteur : Organismes sociaux (60-65)

| Code | Libellé | Description |
|------|---------|-------------|
| **60** | Caisse de sécurité sociale régime général | CPAM, CNAM |
| **61** | Caisse de sécurité sociale du régime agricole | MSA (Mutualité Sociale Agricole) |
| **62** | Caisse de sécurité sociale des travailleurs non-salariés | TNS |
| **63** | Mutuelle | Mutuelles complémentaires santé |
| **64** | Tiers payant | Organismes tiers payant |
| **65** | Autres organismes sociaux | CAF, autres |

##### Secteur : Retraite (70-74)

| Code | Libellé | Description |
|------|---------|-------------|
| **70** | CNRACL | Caisse Nationale de Retraite des Agents des Collectivités Locales |
| **71** | IRCANTEC | Institution de Retraite Complémentaire des Agents Non Titulaires de l'État et des Collectivités |
| **72** | ASSEDIC | Association pour l'Emploi dans l'Industrie et le Commerce (chômage) |
| **73** | Caisses mutuelles | Caisses mutuelles de retraite |
| **74** | Autres organismes de retraite | Autres caisses |

#### Références

- **EFOU** : Position 237 (1 caractère → "0"-"9" dizaines puis unités)
- **KERD** : Position 8 (2 caractères numériques 00-74)

#### Règle métier

La combinaison Catégorie TG + Nature Juridique (GEFLegalNatureCS) est validée dans le module métier GEF. Exemples de combinaisons valides :

- **Catégorie #01** (Personne physique) → Natures juridiques autorisées : 00 (Inconnue), 01 (Particulier), 02 (Artisan-Commerçant-Agriculteur)
- **Catégorie #27** (EPS) → Natures juridiques autorisées : 09 (Collectivité territoriale-EPL-EPS)
- **Catégorie #50** (Personne morale privé) → Natures juridiques autorisées : 03 (Société), 06 (Association)

#### Exemple d'utilisation

```fsh
// EPS (hôpital public)
* extension contains GEFTGCategory named tgCategory 0..1 MS
* extension[tgCategory].valueCodeableConcept = GEFTGCategoryCS#27 "EPS"
* extension contains GEFLegalNature named legalNature 0..1 MS
* extension[legalNature].valueCodeableConcept = GEFLegalNatureCS#09 "Collectivité territoriale-EPL-EPS"

// Personne physique
* extension[tgCategory].valueCodeableConcept = GEFTGCategoryCS#01 "Personne physique"
* extension[legalNature].valueCodeableConcept = GEFLegalNatureCS#01 "Particulier"
```

---

### GEFLegalNatureCS - Natures juridiques (12 codes)

**ID** : `gef-legal-nature-cs`  
**URL** : `https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/gef-legal-nature-cs`  
**Status** : Active  
**Content** : Complete

#### Description

Classification des organisations par **nature juridique** selon le droit français et les statuts administratifs GEF.

#### Codes

| Code | Libellé | Description | Exemples |
|------|---------|-------------|----------|
| **00** | Nature juridique inconnue | Non renseignée | - |
| **01** | Particulier | Personne physique | Patient, individu |
| **02** | Artisan-Commerçant-Agriculteur | Personne physique profession libérale/indépendante | Auto-entrepreneur, médecin libéral |
| **03** | Société | Personne morale droit privé | SA, SARL, SAS, EURL, SCI |
| **04** | CAM | Caisse d'Assurance Maladie | CPAM locale |
| **05** | Caisse complémentaire | Organisme complémentaire santé | Mutuelle, surcomplémentaire |
| **06** | Association | Association loi 1901 | Association humanitaire, culturelle |
| **07** | État | Services de l'État français | Ministères, préfectures |
| **08** | EPA ou EPIC | Établissement Public Administratif ou Industriel et Commercial | France Télévisions, SNCF |
| **09** | Collectivité territoriale-EPL-EPS | Collectivités et établissements publics locaux/santé | Région, Département, Hôpital public (EPS) |
| **10** | État étranger-Ambassade | Représentations diplomatiques | Ambassade d'Allemagne, Consulat |
| **11** | CAF | Caisse d'Allocations Familiales | CAF départementale |

#### Références

- **EFOU** : Position 238 (2 caractères numériques 00-11)
- **KERD** : Position 9 (2 caractères numériques 00-11)

#### Règle métier

La combinaison avec Catégorie TG (GEFTGCategoryCS) est contrôlée par le module métier GEF (voir section précédente).

#### Exemple d'utilisation

```fsh
// Hôpital public EPS
* extension contains GEFLegalNature named legalNature 0..1 MS
* extension[legalNature].valueCodeableConcept = GEFLegalNatureCS#09 "Collectivité territoriale-EPL-EPS"

// Société privée
* extension[legalNature].valueCodeableConcept = GEFLegalNatureCS#03 "Société"
```

---

### TiersRoleCS - Rôles Tiers (2 codes)

**ID** : `tiers-role-cs`  
**URL** : `https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/tiers-role-cs`  
**Status** : Active  
**Content** : Complete

#### Description

Rôle générique d'une organisation dans le contexte Master Data Management (fournisseur, débiteur, ou les deux).

#### Codes

| Code | Libellé | Définition | Profil associé |
|------|---------|------------|----------------|
| **supplier** | Fournisseur | Fournit des biens/services (présence dans ECO.FOU, message EFOU) | FournisseurProfile |
| **debtor** | Débiteur | Client ou acheteur (présence dans ECO.DBT, message KERD) | DebiteurProfile |

#### Usage

- **Extension** : TiersRoleExtension sur Organization
- **Type** : Coding (NOT CodeableConcept - corriger avec `valueCoding`)
- **Cardinality** : 0..* MS (une organisation peut avoir les deux rôles)

#### Exemple d'utilisation

```fsh
// Fournisseur
* extension contains TiersRoleExtension named tiersRole 0..* MS
* extension[tiersRole].valueCoding = TiersRoleCS#supplier

// Débiteur
* extension[tiersRole].valueCoding = TiersRoleCS#debtor

// Les deux (ex: hôpital fournisseur et débiteur)
Instance: HopitalBidirectionnel
InstanceOf: TiersProfile
* extension[tiersRole][0].valueCoding = TiersRoleCS#supplier
* extension[tiersRole][1].valueCoding = TiersRoleCS#debtor
```

---

## Phase 2 - Terminologies Débitorat

### GEFDebtorTypeCS - Types débiteur (2 codes)

**ID** : `gef-debtor-type-cs`  
**URL** : `https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/gef-debtor-type-cs`  
**Status** : Active  
**Content** : Complete

#### Description

Classification de la fréquence/régularité d'un débiteur dans le message KERD.

#### Codes

| Code | Libellé | Description | Usage |
|------|---------|-------------|-------|
| **O** | Occasionnel | Débiteur ponctuel, transaction unique ou rare | Patient externe ponctuel |
| **N** | Normal | Débiteur régulier, transactions récurrentes | Organisme social, entreprise partenaire |

#### Références

- **KERD** : Position 2 (1 caractère : "O" ou "N")

#### Règle métier

- **Cardinality** : 1..1 MS sur DebiteurProfile (OBLIGATOIRE)
- Détermine la fréquence de mise à jour des données débiteur dans GEF

#### Exemple d'utilisation

```fsh
// Débiteur normal (régulier)
Profile: DebiteurProfile
* extension contains GEFDebtorType named debtorType 1..1 MS

Instance: CPAMDebiteur
InstanceOf: DebiteurProfile
* extension[debtorType].valueCode = GEFDebtorTypeCS#N
```

---

### GEFCivilityCS - Civilités (5 codes)

**ID** : `gef-civility-cs`  
**URL** : `https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/gef-civility-cs`  
**Status** : Active  
**Content** : Complete

#### Description

Civilités pour les personnes physiques (débiteurs de Catégorie TG = 01).

#### Codes

| Code | Libellé | Description |
|------|---------|-------------|
| **M** | Monsieur | Personne de sexe masculin |
| **MME** | Madame | Personne de sexe féminin |
| **MLLE** | Mademoiselle | Jeune femme non mariée (usage traditionnel) |
| **METMME** | Monsieur et Madame | Couple (compte joint, courrier commun) |
| **MOUMME** | Monsieur ou Madame | Indéterminé ou neutre |

#### Références

- **KERD** : Position 10 (6 caractères max, valeurs : "M", "MME", "MLLE", "METMME", "MOUMME")

#### Règle métier

- **OBLIGATOIRE** si Catégorie TG = 01 (Personne physique)
- Utilisée dans GEFPersonDetailsExtension (sub-extension `civility`)
- Si Catégorie TG ≠ 01, cette extension est omise

#### Exemple d'utilisation

```fsh
// Personne physique avec civilité
Instance: JeanDupont
InstanceOf: DebiteurProfile
* extension[tgCategory].valueCodeableConcept = GEFTGCategoryCS#01 "Personne physique"
* extension contains GEFPersonDetails named personDetails 0..1 MS
* extension[personDetails].extension[civility].valueCode = GEFCivilityCS#M
* extension[personDetails].extension[firstName].valueString = "Jean"
```

---

### GEFChorusIdentifierTypeCS - Types identifiant CHORUS (8 codes)

**ID** : `gef-chorus-identifier-type-cs`  
**URL** : `https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/gef-chorus-identifier-type-cs`  
**Status** : Active  
**Content** : Complete

#### Description

Types d'identifiants pour le système CHORUS (Comptabilité Publique de l'État). **Sous-ensemble de GEFIdentifierTypeCS excluant le code 09** ("En cours d'immatriculation").

#### Codes

| Code | Libellé (identique à GEFIdentifierTypeCS) |
|------|-------------------------------------------|
| **01** | SIRET |
| **02** | SIREN |
| **03** | FINESS |
| **04** | NIR |
| **05** | TVA Intracommunautaire |
| **06** | Hors UE |
| **07** | Tahiti |
| **08** | RIDET |

**Code exclu** : ~~09 "En cours d'immatriculation"~~ (non valide pour CHORUS)

#### Références

- **KERD** : Champ "Type identifiant CHORUS" (2 caractères numériques 01-08)
- **Contexte** : Débiteurs publics interfacés avec le système CHORUS de l'État

#### Usage

- **Extension** : GEFChorusIdentifierTypeExtension sur `identifier.extension`
- **Cardinality** : 0..1 MS sur DebiteurProfile (optionnel, uniquement si CHORUS)

#### Exemple d'utilisation

```fsh
// Hôpital public avec FINESS pour CHORUS
Instance: CHMarseille
InstanceOf: DebiteurProfile
* identifier[finess].value = "750712184"
* identifier[finess].extension contains GEFChorusIdentifierType named chorusIdentifierType 0..1
* identifier[finess].extension[chorusIdentifierType].valueCodeableConcept = GEFChorusIdentifierTypeCS#03
```

---

### GEFAddressLocalizationCS - Localisation adresse (3 codes)

**ID** : `gef-address-localization-cs`  
**URL** : `https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/gef-address-localization-cs`  
**Status** : Active  
**Content** : Complete

#### Description

Classification géographique de l'adresse d'un débiteur selon les zones GEF.

#### Codes

| Code | Libellé | Description | ISO 3166 |
|------|---------|-------------|----------|
| **FRANCE** | France | Territoire métropolitain et DROM | FR |
| **EUROPE** | Europe | Union Européenne hors France | UE (AT, BE, DE, IT, ES, etc.) |
| **AUTRE** | Autre | Hors Union Européenne | Monde hors UE |

#### Références

- **KERD** : Champ "Localisation adresse" (6 caractères max : "FRANCE", "EUROPE", "AUTRE")

#### Usage

- **Extension** : GEFAddressLocalizationExtension sur `address.extension`
- **Cardinality** : 0..1 MS sur DebiteurProfile (recommandé pour tous les débiteurs)

#### Exemple d'utilisation

```fsh
// Débiteur en France
* address.extension contains GEFAddressLocalization named localization 0..1 MS
* address.extension[localization].valueCode = GEFAddressLocalizationCS#FRANCE
* address.city = "Lyon"
* address.country = "FR"

// Débiteur en Europe (Allemagne)
* address.extension[localization].valueCode = GEFAddressLocalizationCS#EUROPE
* address.city = "Berlin"
* address.country = "DE"
```

---

## Règles métier globales

### Combinaisons Catégorie TG + Nature Juridique

Le module métier GEF valide les combinaisons suivantes (rejets métier si non conformes) :

| Catégorie TG | Codes | Natures juridiques autorisées | Codes |
|--------------|-------|-------------------------------|-------|
| Inconnue | 00 | Toutes | 00-11 |
| Personne physique | 01 | Inconnue, Particulier, Artisan-Commerçant-Agriculteur | 00, 01, 02 |
| État | 20 | État | 07 |
| Région, Département, Commune | 21-23 | Collectivité territoriale-EPL-EPS | 09 |
| CCAS, EPL | 24-25 | Collectivité territoriale-EPL-EPS | 09 |
| EPS, ENSP | 27-28 | Collectivité territoriale-EPL-EPS, EPA ou EPIC | 08, 09 |
| Autre établissement public | 29 | EPA ou EPIC | 08 |
| Personne morale privé | 50 | Société, Association | 03, 06 |
| CPAM, MSA, TNS | 60-62 | CAM, Caisse complémentaire | 04, 05 |
| Mutuelle, Tiers payant | 63-64 | Caisse complémentaire, Association | 05, 06 |
| CNRACL, IRCANTEC | 70-71 | EPA ou EPIC | 08 |
| CAF | 65, 11 | CAF | 11 |

### Règle d'obligation GEFPersonDetails

**Si Catégorie TG = 01 (Personne physique)** :
- **OBLIGATOIRE** : extension GEFPersonDetails avec :
  - `civility` (valueCode from GEFCivilityCS)
  - `firstName` (valueString)

**Sinon** (Catégorie TG ≠ 01) :
- **Omis** : GEFPersonDetails non utilisé

---

## Liens vers ressources FHIR

### CodeSystems
- [GEFIdentifierTypeCS](CodeSystem-gef-identifier-type-cs.html)
- [GEFTGCategoryCS](CodeSystem-gef-tg-category-cs.html)
- [GEFLegalNatureCS](CodeSystem-gef-legal-nature-cs.html)
- [TiersRoleCS](CodeSystem-tiers-role-cs.html)
- [GEFDebtorTypeCS](CodeSystem-gef-debtor-type-cs.html)
- [GEFCivilityCS](CodeSystem-gef-civility-cs.html)
- [GEFChorusIdentifierTypeCS](CodeSystem-gef-chorus-identifier-type-cs.html)
- [GEFAddressLocalizationCS](CodeSystem-gef-address-localization-cs.html)

### ValueSets
- [GEFIdentifierTypeVS](ValueSet-gef-identifier-type-vs.html)
- [GEFTGCategoryVS](ValueSet-gef-tg-category-vs.html)
- [GEFLegalNatureVS](ValueSet-gef-legal-nature-vs.html)
- [TiersRoleVS](ValueSet-tiers-role-vs.html)
- [GEFDebtorTypeVS](ValueSet-gef-debtor-type-vs.html)
- [GEFCivilityVS](ValueSet-gef-civility-vs.html)
- [GEFChorusIdentifierTypeVS](ValueSet-gef-chorus-identifier-type-vs.html)
- [GEFAddressLocalizationVS](ValueSet-gef-address-localization-vs.html)

### Extensions utilisant ces terminologies
- [GEFIdentifierTypeExtension](StructureDefinition-gef-identifier-type.html) (9 codes)
- [GEFTGCategoryExtension](StructureDefinition-gef-tg-category.html) (24 codes)
- [GEFLegalNatureExtension](StructureDefinition-gef-legal-nature.html) (12 codes)
- [TiersRoleExtension](StructureDefinition-tiers-role-extension.html) (2 codes)
- [GEFDebtorTypeExtension](StructureDefinition-gef-debtor-type.html) (2 codes)
- [GEFPersonDetailsExtension](StructureDefinition-gef-person-details.html) → sub-extension civility (5 codes)
- [GEFChorusIdentifierTypeExtension](StructureDefinition-gef-chorus-identifier-type.html) (8 codes)
- [GEFAddressLocalizationExtension](StructureDefinition-gef-address-localization.html) (3 codes)

---

**Total terminologies GEF** : **8 CodeSystems**, **8 ValueSets**, **54 codes**
