// =============================================
// CodeSystem Rôles Tiers (Générique)
// =============================================

CodeSystem: TiersRoleCodeSystem
Id: tiers-role-codesystem
Title: "Rôles Tiers (Générique)"
Description: "Rôles génériques d'un tiers (débiteur, fournisseur)."
* ^status = #active
* ^content = #complete
* ^caseSensitive = true
* #supplier "Fournisseur" "Le tiers est un fournisseur"
* #debtor "Débiteur" "Le tiers est un débiteur"
