// =============================================
// CodeSystems et ValueSets spécifiques CPage
// =============================================

// ============ VALIDITÉ ============

CodeSystem: CSCPageValidity
Id: cpage-validity-codesystem
Title: "Validité (CPage)"
Description: "Codes de validité utilisés dans CPage (VALITI, INVADT, VALIFO)."
* ^status = #active
* ^content = #complete
* ^caseSensitive = true
* #V "Valide" "Le tiers est valide"
* #I "Invalide" "Le tiers est invalide"

ValueSet: VSCPageValidity
Id: cpage-validity-valueset
Title: "ValueSet Validité CPage"
Description: "Codes de validité : V (Valide) ou I (Invalide)."
* ^status = #active
* include codes from system CSCPageValidity

// ============ RÉSIDENCE (Débiteur) ============

CodeSystem: CSCPageResidency
Id: cpage-residency-codesystem
Title: "Résidence (CPage - Débiteur)"
Description: "Codes de résidence du débiteur selon la codification CPage (RESIDT)."
* ^status = #active
* ^content = #complete
* ^caseSensitive = true
* #R "Résident" "Débiteur résident"
* #N "Non-résident" "Débiteur non-résident"
* #E "Étranger" "Débiteur étranger"

ValueSet: VSCPageResidency
Id: cpage-residency-valueset
Title: "ValueSet Résidence CPage"
Description: "Codes RESIDT : R (Résident), N (Non-résident), E (Étranger)."
* ^status = #active
* include codes from system CSCPageResidency

// ============ ZONE EUROPE ============

CodeSystem: CSCPageEUZone
Id: cpage-euzone-codesystem
Title: "Zone Europe (CPage)"
Description: "Classification européenne du tiers selon CPage (EUROTI)."
* ^status = #active
* ^content = #complete
* ^caseSensitive = true
* #F "France" "Tiers situé en France"
* #O "Europe (hors France)" "Tiers situé en Europe hors France"
* #A "Autre" "Tiers situé hors Europe"

ValueSet: VSCPageEUZone
Id: cpage-euzone-valueset
Title: "ValueSet Zone Europe CPage"
Description: "Codes EUROTI : F (France), O (Europe hors France), A (Autre)."
* ^status = #active
* include codes from system CSCPageEUZone
