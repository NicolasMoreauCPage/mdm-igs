# Fournisseurs CPage - Extensions Spécialisées

## Contexte CPage

Ce document décrit les extensions spécifiques à CPage pour la modélisation des fournisseurs. Ces extensions enrichissent le **Profil Fournisseur Commun** avec les données métier propres au système CPage, incluant le **mapping du format legacy** vers FHIR.

## Héritage du Profil Commun

Le profil `CPageSupplierProfile` hérite de `SupplierProfile` (du IG commun) et **ajoute** :
- Code interne CPage pour identification propriétaire
- Code EH (établissement/entité) du format legacy
- Types d'identifiants fournisseur structurés
- Catégories de fournisseur selon la classification métier
- Contexte régional et organisationnel

```
SupplierProfile (IG Commun)
    ↓
    └─→ CPageSupplierProfile (IG CPage)
        + Code interne CPage (cpageInternalCode)
        + Code EH (cpageEHCode)
        + Types d'identifiants (identifierType)
        + Catégorie CPage (cpageCategory)
```

## Structure Legacy CPage → Modèle FHIR

### Tableau de Correspondance

La structure legacy CPage est transformée en FHIR comme suit:

| Position | Longueur | Champ Legacy | Mappage FHIR | Remarques |
|----------|----------|--------------|-------------|----------|
| 1 | 1 | Zone opération | Non utilisé | Spécifique au format transport |
| 2 | 2 | **Code EH** | **extension[cpageEHCode]** | Code établissement |
| 4 | 14 | **Numéro fournisseur** | **identifier[].value** | SIRET ou autre |
| 18 | 32 | **Nom du fournisseur** | **name** | Nom principal |
| 50 | 32 | **Raison sociale** | **name** (alias) | Nom juridique |
| 82 | 32 | **Numéro et rue** | **address[].line[0]** | Adresse ligne 1 |
| 114 | 32 | **Complément d'adresse** | **address[].line[1]** | Adresse ligne 2 |
| 146 | 5 | **Code postal** | **address[].postalCode** | Validé du ValueSet |
| 151 | 32 | **Bureau distributeur** | **address[].city** | Commune |
| 183 | 20 | **Téléphone** | **telecom[system=phone]** | Type téléphone |
| 203 | 20 | **Télécopie-Fax** | **telecom[system=fax]** | Type télécopie |
| 223 | 14 | **Code SIRET** | **identifier[system=siret]** | Numéro SIRET |
| 237 | 2 | **Code fournisseur** | **extension[cpageInternalCode]** | Code interne CPage |
| 239 | 5 | **Type identifiant** | **identifier[].extension[identifierType]** | Type d'ID: SIRET, SIREN, etc. |
| 244 | 18 | **Identifiant fournisseur** | **identifier[].value** | Valeur de l'identifiant |

## Extensions CPage Spécifiques

### 1. Code EH (`cpageEHCode`)

**Extension**: `CPageSupplierEHCodeExtension`  
**Type**: String (2 caractères)  
**Obligatoire**: Non (0..1)  
**Utilité**: Stocker le code établissement/entité du format CPage legacy

**Mapping Legacy**: Position 2-3 (2 caractères)

**Exemple**:
```xml
<extension url="https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-eh-code-extension">
  <valueString value="C"/>
</extension>
```

### 2. Type d'Identifiant Fournisseur (`identifierType`)

**Extension**: `CPageSupplierIdentifierTypeExtension`  
**Type**: Code  
**Obligatoire**: Non (0..1) sur chaque `identifier`  
**ValueSet**: `CPageSupplierIdentifierTypeVS`  
**Utilité**: Classifier le type d'identifiant utilisé (SIRET, SIREN, FINESS, etc.)

**Mapping Legacy**: Position 239-243 (5 caractères)

**Types d'Identifiants**:

| Code | Label | Longueur | Description |
|------|-------|----------|-------------|
| `01` | SIRET | 14 | Numéro SIRET (Système d'Identification du Répertoire des Établissements) |
| `02` | SIREN | 9 | Numéro SIREN (Système d'Identification du Répertoire des Entreprises Nationales) |
| `03` | FINESS | 11 | Numéro FINESS (Fichier National d'Identification des Structures) |
| `04` | NIR | Variable | Numéro d'Inscription au Répertoire (personnes physiques) |
| `05` | TVA | Variable | Numéro TVA intracommunautaire (UE) |
| `06` | FOREIGN | Variable | Identifiant hors Union Européenne |
| `07` | TAHITI | Variable | Numéro Tahiti (Polynésie française) |
| `08` | RIDET | Variable | RIDET (Répertoire informatisé Nouméa/Nouvelle-Calédonie) |
| `09` | PENDING | Variable | Fournisseurs en cours d'immatriculation |

**Exemple**:
```xml
<identifier>
  <system value="https://www.cpage.fr/fhir/CodeSystem/siret"/>
  <value value="12345678900145"/>
  <extension url="https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-identifier-type-extension">
    <valueCode value="01"/>
  </extension>
</identifier>
```

### 3. Code Interne CPage (`cpageInternalCode`)

**Extension**: `CPageSupplierInternalCodeExtension`  
**Type**: String  
**Obligatoire**: Non (0..1)  
**Utilité**: Stocker le code interne CPage pour identification propriétaire

**Mapping Legacy**: Position 237-238 (2 caractères)

**Format Suggéré**: `[CODE]-[NUMÉRO]` (ex: "C" + "01" = "C01" ou "SUP-CPA-0042")

**Exemple**:
```xml
<extension url="https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-internal-code-extension">
  <valueString value="C01"/>
</extension>
```

### 4. Catégorie CPage (`cpageCategory`)

**Extension**: `CPageSupplierCategoryExtension`  
**Type**: Code  
**Obligatoire**: Non (0..1)  
**ValueSet**: `CPageSupplierCategoryVS`  
**Utilité**: Classifier les fournisseurs selon les critères métier CPage

**Catégories disponibles**:

| Code | Label | Description |
|------|-------|-------------|
| `local` | Fournisseur Local | Implanté localement dans la région |
| `national` | Fournisseur National | Opérant au niveau national |
| `european` | Fournisseur Européen | Implanté en Europe |
| `international` | Fournisseur International | Implanté à l'international |
| `healthcare-specialist` | Spécialiste Santé | Produits de santé spécialisés |
| `it-provider` | Prestataire IT | Services informatiques/technologiques |
| `logistics` | Logistique | Services logistiques |

**Exemple**:
```xml
<extension url="https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-category-extension">
  <valueCode value="healthcare-specialist"/>
</extension>
```

## Extensions RIB - Informations Bancaires

Le RIB (Relevé d'Identité Bancaire) est un format legacy de CPage contenant les coordonnées bancaires du fournisseur. Ces extensions structurent cette information en FHIR.

### 5. Numéro d'Ordre RIB (`bankOrderNumber`)

**Extension**: `CPageSupplierBankOrderNumberExtension`  
**Type**: String (1-2 caractères)  
**Obligatoire**: Non (0..*)  
**Utilité**: Permettre plusieurs RIBs pour un même fournisseur via numéro d'ordre

**Mapping Legacy**: Position 18-19 (2 caractères)

**Exemple**:
```xml
<extension url="https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-bank-order-number-extension">
  <valueString value="01"/>
</extension>
```

### 6. Libellé Banque/Guichet (`bankLabel`)

**Extension**: `CPageSupplierBankLabelExtension`  
**Type**: String (max 40 caractères)  
**Obligatoire**: Non (0..*)  
**Utilité**: Stocker le libellé lisible de la banque/du guichet

**Mapping Legacy**: Position 20-51 (32 caractères, peut être tronqué)

**Remarque**: Le champ legacy fait 32 caractères mais peut être tronqué. En FHIR, nous supportons jusqu'à 40 caractères.

**Exemple**:
```xml
<extension url="https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-bank-label-extension">
  <valueString value="BNP Paribas Nantes Graslin"/>
</extension>
```

### 7. Code Banque et Code Guichet (`bankCode`)

**Extension**: `CPageSupplierBankCodeExtension`  
**Type**: Structure avec 2 sous-éléments  
**Obligatoire**: Non (0..*)  
**Utilité**: Stocker les codes numériques IBAN de banque et guichet

**Mapping Legacy**:
- Code banque: Position 52-56 (5 chiffres)
- Code guichet: Position 57-61 (5 chiffres)

**Structure**:
- `bankCode` (5 chiffres) : Code banque IBAN
- `branchCode` (5 chiffres) : Code guichet IBAN

**Exemple**:
```xml
<extension url="https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-bank-code-extension">
  <extension url="bankCode">
    <valueString value="30003"/>
  </extension>
  <extension url="branchCode">
    <valueString value="00200"/>
  </extension>
</extension>
```

### 8. Numéro de Compte Bancaire (`bankAccount`)

**Extension**: `CPageSupplierBankAccountExtension`  
**Type**: String (11 caractères)  
**Obligatoire**: Non (0..*)  
**Utilité**: Stocker le numéro de compte bancaire

**Mapping Legacy**: Position 62-72 (11 caractères alphanumériques)

**Format**: 11 caractères numériques ou alphanumériques

**Exemple**:
```xml
<extension url="https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-bank-account-extension">
  <valueString value="12345678901"/>
</extension>
```

### 9. Clé RIB (`ribKey`)

**Extension**: `CPageSupplierBankRIBKeyExtension`  
**Type**: String (2 chiffres)  
**Obligatoire**: Non (0..*)  
**Utilité**: Stocker la clé de contrôle RIB pour validation

**Mapping Legacy**: Position 73-74 (2 chiffres: 00-97)

**Format**: 2 chiffres numériques (00 à 97)

**Exemple**:
```xml
<extension url="https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-bank-rib-key-extension">
  <valueString value="45"/>
</extension>
```

### 10. Mode de Règlement (`paymentMode`)

**Extension**: `CPageSupplierPaymentModeExtension`  
**Type**: Code  
**Obligatoire**: Non (0..*)  
**ValueSet**: `CPageSupplierPaymentModeVS`  
**Utilité**: Indiquer le mode de paiement du fournisseur

**Mapping Legacy**: Position 75-77 (3 caractères)

**Modes disponibles**:

| Code | Label | Description | Cas d'usage |
|------|-------|-------------|-----------|
| `V` | Virement | Paiement par virement bancaire national (SEPA) | Fournisseurs France métropole |
| `Z` | Virement Étranger | Paiement par virement international (SWIFT) | Fournisseurs UE/Étrangers |
| `D` | Divers | Autre mode de paiement (chèque, virement spécifique) | Exceptions, modes anciens |

**Exemple**:
```xml
<extension url="https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-payment-mode-extension">
  <valueCode value="V"/>
</extension>
```

## Profil CPageSupplierProfile

### Vue d'ensemble
Étend `SupplierProfile` (commun) pour ajouter le support du format legacy CPage.

### Éléments Hérités du Commun
- ✅ Identifiants (`identifier`) - SIRET ou autre
- ✅ Nom (`name`) - Nom et raison sociale
- ✅ Statut (`status`) - active/inactive/suspended/terminated/pending
- ✅ Coordonnées (`telecom`) - Téléphone, fax, email
- ✅ Adresse (`address`) - Adresse avec code postal validé
- ✅ Contact (`contact`) - Personne de contact
- ✅ Statut fournisseur (`supplierStatus` extension)

### Éléments Spécifiques CPage (Ajoutés)
- ➕ Code EH (`cpageEHCode` extension)
- ➕ Code interne (`cpageInternalCode` extension)
- ➕ Type identifiant (`identifierType` extension sur identifier)
- ➕ Catégorie (`cpageCategory` extension)

## Cas d'Usage CPage

### Exemple 1: Importer un Fournisseur depuis Format Legacy (sans RIB)

**Format Legacy CPage (enregistrement fixe)**:
```
C    12345678900145Pharmalogic SARL         Pharmalogic              15 Rue de la Santé                 Nantes              44000Nantes            0243506070          0243506071          12345678900145C0 01  12345678900145
```

**Conversion en FHIR**:
```json
{
  "resourceType": "Organization",
  "meta": {
    "profile": ["https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-profile"]
  },
  "identifier": [
    {
      "system": "https://www.cpage.fr/fhir/CodeSystem/siret",
      "value": "12345678900145",
      "extension": [
        {
          "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-identifier-type-extension",
          "valueCode": "01"
        }
      ]
    }
  ],
  "name": "Pharmalogic SARL",
  "status": "active",
  "telecom": [
    {
      "system": "phone",
      "value": "0243506070"
    },
    {
      "system": "fax",
      "value": "0243506071"
    }
  ],
  "address": [
    {
      "line": ["15 Rue de la Santé"],
      "city": "Nantes",
      "postalCode": "44000",
      "country": "FRANCE"
    }
  ],
  "extension": [
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/supplier-status-extension",
      "valueCode": "active"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-eh-code-extension",
      "valueString": "C"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-internal-code-extension",
      "valueString": "C0"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-category-extension",
      "valueCode": "healthcare-specialist"
    }
  ],
  "contact": [
    {
      "name": {
        "text": "Service fournisseurs"
      },
      "telecom": [
        {
          "system": "phone",
          "value": "0243506070"
        }
      ]
    }
  ]
}
```

### Exemple 2: Fournisseur Complet avec RIB

**Format Legacy (Fournisseur + RIB - enregistrement fixe)**:
```
Fournisseur:
C    12345678900145Pharmalogic SARL         Pharmalogic              15 Rue de la Santé                 Nantes              44000Nantes            0243506070          0243506071          12345678900145C0 01  12345678900145

RIB:
C    1234567890014501BNP Paribas Nantes    30003 00200 12345678901 45 V   12345678900145
```

**Conversion Complète en FHIR**:
```json
{
  "resourceType": "Organization",
  "meta": {
    "profile": ["https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-profile"]
  },
  "identifier": [
    {
      "system": "https://www.cpage.fr/fhir/CodeSystem/siret",
      "value": "12345678900145",
      "extension": [
        {
          "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-identifier-type-extension",
          "valueCode": "01"
        }
      ]
    }
  ],
  "name": "Pharmalogic SARL",
  "status": "active",
  "telecom": [
    {
      "system": "phone",
      "value": "0243506070"
    },
    {
      "system": "fax",
      "value": "0243506071"
    }
  ],
  "address": [
    {
      "line": ["15 Rue de la Santé"],
      "city": "Nantes",
      "postalCode": "44000",
      "country": "FRANCE"
    }
  ],
  "extension": [
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/supplier-status-extension",
      "valueCode": "active"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-eh-code-extension",
      "valueString": "C"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-internal-code-extension",
      "valueString": "C0"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-category-extension",
      "valueCode": "healthcare-specialist"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-bank-order-number-extension",
      "valueString": "01"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-bank-label-extension",
      "valueString": "BNP Paribas Nantes"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-bank-code-extension",
      "extension": [
        {
          "url": "bankCode",
          "valueString": "30003"
        },
        {
          "url": "branchCode",
          "valueString": "00200"
        }
      ]
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-bank-account-extension",
      "valueString": "12345678901"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-bank-rib-key-extension",
      "valueString": "45"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-payment-mode-extension",
      "valueCode": "V"
    }
  ],
  "contact": [
    {
      "name": {
        "text": "Service fournisseurs"
      },
      "telecom": [
        {
          "system": "phone",
          "value": "0243506070"
        }
      ]
    }
  ]
}
```

### Exemple 3: Fournisseur Étranger avec Virement International

```json
{
  "resourceType": "Organization",
  "meta": {
    "profile": ["https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-profile"]
  },
  "identifier": [
    {
      "system": "https://www.cpage.fr/fhir/CodeSystem/iban",
      "value": "DE89370400440532013000",
      "extension": [
        {
          "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-identifier-type-extension",
          "valueCode": "06"
        }
      ]
    }
  ],
  "name": "Pharma International GmbH",
  "status": "active",
  "address": [
    {
      "line": ["Bahnhofstrasse 123"],
      "city": "Berlin",
      "postalCode": "10115",
      "country": "GERMANY"
    }
  ],
  "extension": [
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/supplier-status-extension",
      "valueCode": "active"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-category-extension",
      "valueCode": "european"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-bank-order-number-extension",
      "valueString": "01"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-bank-label-extension",
      "valueString": "Deutsche Bank Berlin"
    },
    {
      "url": "https://www.cpage.fr/fhir/StructureDefinition/cpage-supplier-payment-mode-extension",
      "valueCode": "Z"
    }
  ]
}
```

## Considérations d'Implémentation

### Migration Données Legacy

1. **Parsing du format fixe**: Respecter les positions et longueurs indiquées
2. **Conversion d'identifiants**: 
   - Position 239-243 → Extension `identifierType`
   - Position 244-261 → Valeur `identifier.value`
3. **Gestion du Code EH**: Position 2-3 → Extension `cpageEHCode`
4. **Code interne CPage**: Position 237-238 → Extension `cpageInternalCode`

### Validation Identifiants

| Type | Format | Validation |
|------|--------|-----------|
| SIRET | 14 chiffres | Clé de contrôle optionnelle |
| SIREN | 9 chiffres | Clé de contrôle optionnelle |
| FINESS | 11 chiffres (7+4) | Clé de contrôle proposée |
| TVA | Alphanumérique | Format pays + 12 caractères |
| Autres | Variable | Accepter tel quel |

### Performance et Indexation

- Indexer sur `identifier.value` pour recherche rapide
- Indexer sur `identifier.system` + type
- Prévoir recherche par code interne CPage
- Support pour recherche "fuzzy" sur nom

## Cas d'Erreur Courants

❌ **Mauvais**: Type identifiant "SIRET" au lieu de "01"  
✅ **Bon**: Type identifiant "01" (code standardisé)

❌ **Mauvais**: Code EH sur 3 caractères  
✅ **Bon**: Code EH sur exactement 2 caractères

❌ **Mauvais**: Identifiant SIRET de 13 chiffres  
✅ **Bon**: Identifiant SIRET de 14 chiffres

## Références
- [Profil Commun SupplierProfile](../supplier/supplier.html)
- [Profil CPageSupplierProfile](artifacts.html#Structure-Definition-cpage-supplier-profile)
- [CodeSystem Types Identifiants](artifacts.html#CodeSystem-cpage-supplier-identifier-type-cs)
- [ValueSet Types Identifiants](artifacts.html#ValueSet-cpage-supplier-identifier-type-vs)
