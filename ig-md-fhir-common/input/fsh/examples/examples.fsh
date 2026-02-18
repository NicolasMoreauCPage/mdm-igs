// =============================================
// Exemples pour IG Tiers Générique
// =============================================

Instance: ExampleTiersGeneric
InstanceOf: CPageTiersProfile
Usage: #example
Title: "Exemple Tiers générique"
Description: "Exemple d'un tiers avec identifiants ETIER, SIREN, SIRET, FINESS et TVA."

* identifier[etierId].system = $id-etier
* identifier[etierId].value = "000123"

// FR Core slices (hérités automatiquement)
* identifier[+].system = "https://sirene.fr"
* identifier[=].type = https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-0203#SIREN
* identifier[=].value = "123456789"

* identifier[+].system = "https://sirene.fr"
* identifier[=].type = https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-0203#SIRET
* identifier[=].value = "12345678900012"

* identifier[+].system = "http://finess.sante.gouv.fr"
* identifier[=].type.coding.code ^short = "FINEJ | FINEG"
* identifier[=].type.coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-0203"
* identifier[=].value = "010000001"

* identifier[tva].system = $id-tva
* identifier[tva].value = "FR12345678901"

* name = "ACME Médical"
* alias[0] = "ACME"

* active = true

* telecom[0].system = #phone
* telecom[0].value = "0123456789"
* telecom[0].use = #work

* telecom[1].system = #email
* telecom[1].value = "contact@acme.test"
* telecom[1].use = #work

* address[0].use = #work
* address[0].type = #both
* address[0].line[0] = "10 rue de l'Hôpital"
* address[0].postalCode = "75000"
* address[0].city = "Paris"
* address[0].country = "FR"

* extension[tiersRole].valueCoding = TiersRoleCodeSystem#supplier
