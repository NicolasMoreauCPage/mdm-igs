// =============================================
// Extension Fournisseur associé (débiteur) CPage
// =============================================

Extension: CPageDebtorAssociatedSupplier
Id: cpage-debtor-associated-supplier
Title: "Fournisseur associé (CPage)"
Description: "Référence vers le fournisseur associé au débiteur (DBT.NUFODT). Pointe vers une Organization de profil CPageSupplierOrganization."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* value[x] only Reference(Organization)
* valueReference 1..1
* valueReference ^short = "Référence vers l'Organization fournisseur associé"
