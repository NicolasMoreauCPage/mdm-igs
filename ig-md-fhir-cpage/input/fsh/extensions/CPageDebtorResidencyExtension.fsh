// =============================================
// Extension Résidence débiteur CPage
// =============================================

Extension: CPageDebtorResidency
Id: cpage-debtor-residency
Title: "Résidence débiteur (CPage)"
Description: "Code résident / non résident / étranger du débiteur (DBT.RESIDT) : R (Résident), N (Non-résident), E (Étranger)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* value[x] only Coding
* valueCoding 1..1
* valueCoding from CPageResidencyValueSet (required)
