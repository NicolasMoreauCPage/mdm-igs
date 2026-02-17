// =============================================
// Extensions communes CPage
// =============================================

Extension: ExtCPageValidity
Id: ext-cpage-validity
Title: "Validité CPage"
Description: "Code validité CPage (VALITI / INVADT / VALIFO) : V (Valide) / I (Invalide)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* value[x] only Coding
* valueCoding 1..1
* valueCoding from VSCPageValidity (required)

Extension: ExtCPageEUZone
Id: ext-cpage-euzone
Title: "Zone Europe CPage"
Description: "Classification européenne du tiers : F (France) / O (Europe hors France) / A (Autre). Correspond au champ EUROTI."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* value[x] only Coding
* valueCoding 1..1
* valueCoding from VSCPageEUZone (required)
