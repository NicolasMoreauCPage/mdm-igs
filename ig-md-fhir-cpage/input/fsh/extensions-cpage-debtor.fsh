// =============================================
// Extensions CPage Débiteur (issues de ECO.DBT)
// =============================================

Extension: ExtCPageDebtorResidency
Id: ext-cpage-debtor-residency
Title: "Résidence débiteur (CPage)"
Description: "Code résident / non résident / étranger du débiteur (DBT.RESIDT) : R (Résident), N (Non-résident), E (Étranger)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* value[x] only Coding
* valueCoding 1..1
* valueCoding from VSCPageResidency (required)

Extension: ExtCPageDebtorAccount
Id: ext-cpage-debtor-account
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

Extension: ExtCPageDebtorAsap
Id: ext-cpage-debtor-asap
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

Extension: ExtCPageDebtorExternalId
Id: ext-cpage-debtor-externalid
Title: "Identifiant externe débiteur (CPage)"
Description: "Identifiant externe du débiteur utilisé pour les interfaces (DBT.IDEXDT)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* value[x] only string
* valueString 1..1

Extension: ExtCPageDebtorAssociatedSupplier
Id: ext-cpage-debtor-associated-supplier
Title: "Fournisseur associé (CPage)"
Description: "Référence vers le fournisseur associé au débiteur (DBT.NUFODT). Pointe vers une Organization de profil CPageSupplierOrganization."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* value[x] only Reference(Organization)
* valueReference 1..1
* valueReference ^short = "Référence vers l'Organization fournisseur associé"
