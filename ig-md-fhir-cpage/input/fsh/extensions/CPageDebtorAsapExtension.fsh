// =============================================
// Extension ASAP débiteur CPage
// =============================================

Extension: CPageDebtorAsap
Id: cpage-debtor-asap
Title: "ASAP débiteur (CPage)"
Description: "Paramètres ASAP : désactiver génération ASAP dématérialisé, forcer impression CEN (DBT.ASAPDT, DBT.FCENDT)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* extension contains
    disableAsap 0..1 and
    forceCenPrint 0..1
* extension[disableAsap].value[x] only boolean
* extension[disableAsap] ^short = "Ne pas générer d'ASAP dématérialisé (ASAPDT)"
* extension[forceCenPrint].value[x] only boolean
* extension[forceCenPrint] ^short = "Forcer impression CEN (FCENDT)"
