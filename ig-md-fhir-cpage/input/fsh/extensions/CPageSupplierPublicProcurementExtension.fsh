// =============================================
// Extension Marchés publics / groupement d'achat
// =============================================

Extension: CPageSupplierPublicProcurement
Id: cpage-supplier-procurement
Title: "Marchés publics / groupement d'achat"
Description: "Assujetti code marchés publics, groupement d'achat, escomptable (FOU.TCMPFO, FOU.GACHFO, FOU.ESCOFO)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* extension contains
    publicProcurement 0..1 and
    purchasingGroup 0..1 and
    discountable 0..1
* extension[publicProcurement].value[x] only boolean
* extension[publicProcurement] ^short = "Assujetti code marchés publics (TCMPFO)"
* extension[purchasingGroup].value[x] only boolean
* extension[purchasingGroup] ^short = "Groupement d'achat (GACHFO)"
* extension[discountable].value[x] only boolean
* extension[discountable] ^short = "Escomptable (ESCOFO)"
