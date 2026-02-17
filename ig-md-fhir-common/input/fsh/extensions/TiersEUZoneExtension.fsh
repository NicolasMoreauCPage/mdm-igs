Extension: TiersEUZoneExtension
Id: tiers-euzone-extension
Title: "Zone Europe CPage"
Description: "Zone Europe : France / Europe / Autre (EUROTI)."
* ^status = #active
* ^context.type = #element
* ^context.expression = "Organization"
* value[x] only Coding
* valueCoding from TiersEUZoneValueSet (required)
* valueCoding 1..1