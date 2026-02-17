Profile: TiersProfile
Parent: fr-core-organization
Id: tiers-profile
Title: "Tiers (générique)"
Description: "Profil générique Tiers, dérivé de FR Core Organization, avec ajout d'un identifiant interne ETIER et de la TVA intracom."

// FR Core définit déjà le slicing sur Organization.identifier + slices SIREN/SIRET/FINESS/etc.
// On ajoute uniquement nos slices supplémentaires (slicing déjà hérité).

* identifier contains
    etierId 1..1 MS and
    tvaIntracommunautaire     0..1 MS

// Identifiant interne (ECO.ETIER.IDTITI)
* identifier[etierId].type = $v2-0203#RI "Resource identifier"
* identifier[etierId].system = $id-etier (exactly)
* identifier[etierId].value 1..1

// TVA intracom (ECO.ETIER.TVAITI)
* identifier[tvaIntracommunautaire].type = $v2-0203#TAX "Tax ID number"
* identifier[tvaIntracommunautaire].system = $id-tva (exactly)
* identifier[tvaIntracommunautaire].value 1..1

// Rôles génériques (debtor/supplier)
* extension contains TiersRoleExtension named tiersRole 0..* MS