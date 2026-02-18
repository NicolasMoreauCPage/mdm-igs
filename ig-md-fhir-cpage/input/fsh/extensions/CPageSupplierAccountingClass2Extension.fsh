// =============================================
// Extension Comptabilité Fournisseur - Classe 2
// =============================================

Extension: CPageSupplierAccountingClass2
Id: cpage-supplier-class2
Title: "Comptabilité Fournisseur - Classe 2"
Description: "Lettre budgétaire et compte tiers classe 2 (FOU.LBU2FO, FOU.CPT2FO)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* extension contains
    lbu 0..1 and
    cpt 0..1
* extension[lbu].value[x] only string
* extension[lbu] ^short = "Lettre budgétaire classe 2 (LBU2FO)"
* extension[cpt].value[x] only string
* extension[cpt] ^short = "Compte tiers classe 2 (CPT2FO)"
