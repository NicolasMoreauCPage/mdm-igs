// =============================================
// Extension Validité CPage
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
* valueCoding from CPageValidityValueSet (required)
