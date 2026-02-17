// =============================================
// Extension Rôle Tiers (Générique)
// =============================================

Extension: ExtTiersRole
Id: ext-tiers-role
Title: "Rôle générique du tiers"
Description: "Rôle(s) générique(s) du tiers : débiteur / fournisseur. Cette extension permet de qualifier la fonction d'une organisation dans le contexte métier (ECO.FOU, ECO.DBT)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* value[x] only Coding
* valueCoding 1..1
* valueCoding from TiersRoleValueSet (required)
