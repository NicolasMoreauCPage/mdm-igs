// =============================================
// CodeSystems et ValueSets pour IG Tiers Générique
// =============================================

CodeSystem: CSTiersRole
Id: tiers-role-codesystem
Title: "Rôles Tiers (Générique)"
Description: "Rôles génériques d'un tiers (débiteur, fournisseur)."
* ^status = #active
* ^content = #complete
* ^caseSensitive = true
* #supplier "Fournisseur" "Le tiers est un fournisseur"
* #debtor "Débiteur" "Le tiers est un débiteur"

ValueSet: VSTiersRole
Id: tiers-role-valueset
Title: "ValueSet Rôles Tiers"
Description: "Rôles génériques d'un tiers."
* ^status = #active
* include codes from system CSTiersRole
