// =============================================
// Extension Comptabilité Fournisseur - Classe 6
// =============================================

Extension: ExtCPageSupplierAccountingClass6
Id: ext-cpage-supplier-class6
Title: "Comptabilité Fournisseur - Classe 6"
Description: "Lettre budgétaire et compte tiers classe 6 (FOU.LBU6FO, FOU.CPT6FO)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* extension contains
    lbu 0..1 and
    cpt 0..1
* extension[lbu].value[x] only string
* extension[lbu] ^short = "Lettre budgétaire classe 6 (LBU6FO)"
* extension[cpt].value[x] only string
* extension[cpt] ^short = "Compte tiers classe 6 (CPT6FO)"
