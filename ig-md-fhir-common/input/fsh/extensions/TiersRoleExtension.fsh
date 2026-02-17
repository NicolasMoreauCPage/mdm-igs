Extension: TiersRoleExtension
Id: tiers-role-extension
Title: "Rôle générique du tiers"
Description: "Rôle(s) générique(s) du tiers : débiteur / fournisseur."
* ^status = #active
* ^context.type = #element
* ^context.expression = "Organization"
* value[x] only Coding
* valueCoding from TiersRoleValueSet (required)
* valueCoding 1..1