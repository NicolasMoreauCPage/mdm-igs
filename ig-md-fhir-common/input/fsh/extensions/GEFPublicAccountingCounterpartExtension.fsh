// =============================================
// Extension: Compte Contrepartie Comptabilité Publique (GEF)
// =============================================

Extension: GEFPublicAccountingCounterpart
Id: gef-public-accounting-counterpart
Title: "Compte Contrepartie Comptabilité Publique (GEF)"
Description: "Extension pour les comptes de contrepartie en comptabilité publique. Correspond aux champs KERD positions 3-4 (Code lettre compte contrepartie + Numéro compte contrepartie). Utilisé pour les débiteurs du secteur public afin d'identifier le compte comptable associé dans le système de comptabilité publique."
Context: Organization
* ^url = "http://cpage.org/fhir/StructureDefinition/gef-public-accounting-counterpart"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* extension contains
    letterCode 0..1 MS and
    accountNumber 0..1 MS

* extension[letterCode] ^short = "Code lettre compte contrepartie"
* extension[letterCode] ^definition = "Code alphabétique identifiant le type de compte de contrepartie (1 caractère)"
* extension[letterCode].value[x] only string
* extension[letterCode].valueString 1..1 MS
* extension[letterCode].valueString ^maxLength = 1

* extension[accountNumber] ^short = "Numéro compte contrepartie"
* extension[accountNumber] ^definition = "Numéro du compte de contrepartie en comptabilité publique (10 caractères)"
* extension[accountNumber].value[x] only string
* extension[accountNumber].valueString 1..1 MS
* extension[accountNumber].valueString ^maxLength = 10
