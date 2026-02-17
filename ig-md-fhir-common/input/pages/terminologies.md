# Terminologies

Cette page documente les **CodeSystems** et **ValueSets** définis dans l'IG Tiers Générique.

## TiersRoleCodeSystem

**ID** : `tiers-role-codesystem`
**URL** : `https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/tiers-role-codesystem`
**Status** : Active
**Content** : Complete

### Description

CodeSystem définissant les rôles génériques qu'un tiers peut avoir dans le contexte Master Data Management.

### Codes

| Code | Display | Définition |
|------|---------|------------|
| `supplier` | Fournisseur | Le tiers est un fournisseur (présence dans ECO.FOU) |
| `debtor` | Débiteur | Le tiers est un débiteur (présence dans ECO.DBT) |

### Usage

Ces codes sont utilisés dans l'extension **ExtTiersRole** pour qualifier le(s) rôle(s) d'une Organization.

### Détermination du rôle

Dans le contexte Oracle ECO :

```sql
-- Un tiers est fournisseur si présent dans FOU
SELECT DISTINCT IDTITI
FROM ECO.FOU
WHERE IDTITI = :tiers_id
-- → extension[tiersRole].valueCoding.code = "supplier"

-- Un tiers est débiteur si présent dans DBT
SELECT DISTINCT IDTITI
FROM ECO.DBT
WHERE IDTITI = :tiers_id
-- → extension[tiersRole].valueCoding.code = "debtor"
```

### Exemple d'utilisation

```json
{
  "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/ext-tiers-role",
  "valueCoding": {
    "system": "https://www.cpage.fr/ig/masterdata/tiers/CodeSystem/tiers-role-codesystem",
    "code": "supplier",
    "display": "Fournisseur"
  }
}
```

---

## TiersRoleValueSet

**ID** : `tiers-role-valueset`
**URL** : `https://www.cpage.fr/ig/masterdata/tiers/ValueSet/tiers-role-valueset`
**Status** : Active

### Description

ValueSet incluant tous les codes du CodeSystem TiersRoleCodeSystem.

### Composition

```
include codes from system TiersRoleCodeSystem
```

Soit **2 codes** :
- `supplier`
- `debtor`

### Utilisation

Ce ValueSet est référencé dans la contrainte de l'extension ExtTiersRole :

```fsh
Extension: ExtTiersRole
* valueCoding from TiersRoleValueSet (required)
```

---

## Extensibilité

### Ajouter des rôles spécifiques

Les IGs dérivés (comme IG CPage) **ne doivent pas** étendre ce CodeSystem.

Pour des rôles métier supplémentaires :
1. Créez un CodeSystem spécifique dans votre IG
2. Créez une extension distincte
3. Maintenez la séparation générique vs spécifique

**Exemple** (à ne pas faire) :
```fsh
// ❌ Ne pas étendre TiersRoleCodeSystem
* #patient "Patient" // NON, trop spécifique
```

**Bonne pratique** :
```fsh
// ✅ Créer son propre CodeSystem dans l'IG dérivé
CodeSystem: CPageRoleCodeSystem
* #clinic-patient "Patient de la clinique"
```

---

## Liens

- **CodeSystem FHIR** : [TiersRoleCodeSystem](CodeSystem-tiers-role-codesystem.html)
- **ValueSet FHIR** : [TiersRoleValueSet](ValueSet-tiers-role-valueset.html)
- **Extension ExtTiersRole** : [StructureDefinition](StructureDefinition-ext-tiers-role.html)
