// =============================================
// Extension Compte tiers débiteur CPage
// =============================================

Extension: CPageDebtorAccount
Id: cpage-debtor-account
Title: "Compte tiers débiteur (CPage)"
Description: "Lettre budgétaire et compte de tiers débiteur (DBT.LBTIDT, DBT.CPTIDT)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* extension contains
    budgetLetter 0..1 and
    thirdPartyAccount 0..1
* extension[budgetLetter].value[x] only string
* extension[budgetLetter] ^short = "Lettre budgétaire débiteur (LBTIDT)"
* extension[thirdPartyAccount].value[x] only string
* extension[thirdPartyAccount] ^short = "Compte de tiers débiteur (CPTIDT)"
