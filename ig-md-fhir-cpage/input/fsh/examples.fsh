// =============================================
// Exemples pour IG CPage
// =============================================

Instance: ExampleCPageSupplier
InstanceOf: CPageSupplierOrganization
Usage: #example
Title: "Exemple Fournisseur CPage"
Description: "Exemple d'un tiers fournisseur avec extensions CPage (comptabilité, Chorus, etc.)."

* identifier[etierId].system = "urn:oid:1.2.250.1.999.1.1.1"
* identifier[etierId].type = $v2-0203#RI
* identifier[etierId].value = "000777"

* identifier[+].system = "https://sirene.fr"
* identifier[=].type = $v2-0203#PRN
* identifier[=].value = "987654321"

* name = "Fournitures Santé SAS"
* active = true

* telecom[0].system = #phone
* telecom[0].value = "0145678901"
* telecom[0].use = #work

* telecom[1].system = #email
* telecom[1].value = "contact@fournitures-sante.test"
* telecom[1].use = #work

* address[0].use = #work
* address[0].line[0] = "5 avenue des Entrepreneurs"
* address[0].postalCode = "69000"
* address[0].city = "Lyon"
* address[0].country = "FR"

// Rôle générique
* extension[tiersRole].valueCoding = $cs-tiers-role#supplier

// Extensions CPage
* extension[cpageValidity].valueCoding = CSCPageValidity#V
* extension[cpageEUZone].valueCoding = CSCPageEUZone#F

* extension[accountingClass6].extension[lbu].valueString = "A"
* extension[accountingClass6].extension[cpt].valueString = "4010000001"

* extension[paymentTerms].extension[paymentDelayDays].valueUnsignedInt = 30
* extension[paymentTerms].extension[minimumOrderAmount].valueDecimal = 100.0

* extension[procurement].extension[publicProcurement].valueBoolean = true
* extension[procurement].extension[purchasingGroup].valueBoolean = false
* extension[procurement].extension[discountable].valueBoolean = true

* extension[chorus].extension[subjectToChorus].valueBoolean = true
* extension[chorus].extension[chorusIdType].valueString = "SIRET"
* extension[chorus].extension[chorusIdentifier].valueString = "98765432100012"


Instance: ExampleCPageDebtor
InstanceOf: CPageDebtorOrganization
Usage: #example
Title: "Exemple Débiteur CPage"
Description: "Exemple d'un tiers débiteur avec extensions CPage (résidence, compte, ASAP, etc.)."

* identifier[etierId].system = "urn:oid:1.2.250.1.999.1.1.1"
* identifier[etierId].type = $v2-0203#RI
* identifier[etierId].value = "000888"

* identifier[+].system = "http://finess.sante.gouv.fr"
* identifier[=].type = $v2-0203#PRN
* identifier[=].value = "690000123"

* name = "Clinique Exemple"
* active = true

* telecom[0].system = #phone
* telecom[0].value = "0478123456"
* telecom[0].use = #work

* address[0].use = #work
* address[0].line[0] = "15 rue de la Santé"
* address[0].postalCode = "69003"
* address[0].city = "Lyon"
* address[0].country = "FR"

// Rôle générique
* extension[tiersRole].valueCoding = $cs-tiers-role#debtor

// Extensions CPage
* extension[cpageValidity].valueCoding = CSCPageValidity#V
* extension[cpageEUZone].valueCoding = CSCPageEUZone#F

* extension[residency].valueCoding = CSCPageResidency#R

* extension[debtorAccount].extension[budgetLetter].valueString = "B"
* extension[debtorAccount].extension[thirdPartyAccount].valueString = "4110000002"

* extension[asap].extension[disableAsap].valueBoolean = false
* extension[asap].extension[forceCenPrint].valueBoolean = false

* extension[externalId].valueString = "EXT-DBT-42"

* extension[associatedSupplier].valueReference = Reference(ExampleCPageSupplier)
