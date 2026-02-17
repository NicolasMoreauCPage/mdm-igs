// =============================================
// Extension Chorus fournisseur
// =============================================

Extension: ExtCPageSupplierChorus
Id: ext-cpage-supplier-chorus
Title: "Chorus fournisseur"
Description: "Informations Chorus : assujetti, type d'identifiant, identifiant (FOU.CHORFO, FOU.TIDCFO, FOU.IDCHFO)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* extension contains
    subjectToChorus 0..1 and
    chorusIdType 0..1 and
    chorusIdentifier 0..1
* extension[subjectToChorus].value[x] only boolean
* extension[subjectToChorus] ^short = "Assujetti Chorus (CHORFO)"
* extension[chorusIdType].value[x] only string
* extension[chorusIdType] ^short = "Type d'identifiant Chorus (TIDCFO)"
* extension[chorusIdentifier].value[x] only string
* extension[chorusIdentifier] ^short = "Identifiant Chorus (IDCHFO)"
