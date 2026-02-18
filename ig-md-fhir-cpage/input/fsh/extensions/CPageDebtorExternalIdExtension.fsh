// =============================================
// Extension Identifiant externe débiteur CPage
// =============================================

Extension: CPageDebtorExternalId
Id: cpage-debtor-externalid
Title: "Identifiant externe débiteur (CPage)"
Description: "Identifiant externe du débiteur utilisé pour les interfaces (DBT.IDEXDT)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* value[x] only string
* valueString 1..1
