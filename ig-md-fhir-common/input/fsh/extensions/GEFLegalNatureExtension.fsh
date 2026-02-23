// =============================================
// Extension GEF Legal Nature
// =============================================

Extension: GEFLegalNature
Id: gef-legal-nature
Title: "Nature juridique (GEF)"
Description: "Nature juridique du tiers selon la nomenclature GEF (codes 00-11). Structure juridique: particulier, société, association, établissement public, collectivité territoriale, etc."
* ^url = "http://cpage.org/fhir/StructureDefinition/gef-legal-nature"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* value[x] only CodeableConcept
* valueCodeableConcept 1..1 MS
* valueCodeableConcept from GEFLegalNatureVS (required)
* valueCodeableConcept ^short = "Nature juridique selon nomenclature GEF"
* valueCodeableConcept ^definition = "Code 00-11 qualifiant la structure juridique: 01=Particulier, 02=Artisan-Commerçant-Agriculteur, 03=Société, 06=Association, 07=État, 08=Établissement public national, 09=Collectivité territoriale, etc. Correspond au champ 'Nature juridique' position 9 du message KERD et position 238 du message EFOU."
