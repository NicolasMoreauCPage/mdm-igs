// =============================================
// Extensions CPage Fournisseur (issues de ECO.FOU)
// =============================================

Extension: ExtCPageSupplierAccountingClass6
Id: ext-cpage-supplier-class6
Title: "Comptabilité Fournisseur - Classe 6"
Description: "Lettre budgétaire et compte tiers classe 6 (FOU.LBU6FO, FOU.CPT6FO)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* extension contains
    lbu 0..1 and
    cpt 0..1
* extension[lbu].value[x] only string
* extension[lbu] ^short = "Lettre budgétaire classe 6 (LBU6FO)"
* extension[cpt].value[x] only string
* extension[cpt] ^short = "Compte tiers classe 6 (CPT6FO)"

Extension: ExtCPageSupplierAccountingClass2
Id: ext-cpage-supplier-class2
Title: "Comptabilité Fournisseur - Classe 2"
Description: "Lettre budgétaire et compte tiers classe 2 (FOU.LBU2FO, FOU.CPT2FO)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* extension contains
    lbu 0..1 and
    cpt 0..1
* extension[lbu].value[x] only string
* extension[lbu] ^short = "Lettre budgétaire classe 2 (LBU2FO)"
* extension[cpt].value[x] only string
* extension[cpt] ^short = "Compte tiers classe 2 (CPT2FO)"

Extension: ExtCPageSupplierPaymentTerms
Id: ext-cpage-supplier-payment
Title: "Conditions de paiement fournisseur"
Description: "Délai de paiement, jour spécifique de paiement, montant minimum de commande (FOU.DEPAFO, FOU.JOSPFO, FOU.MTMIFO)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* extension contains
    paymentDelayDays 0..1 and
    specificPaymentDay 0..1 and
    minimumOrderAmount 0..1
* extension[paymentDelayDays].value[x] only unsignedInt
* extension[paymentDelayDays] ^short = "Délai de paiement en jours (DEPAFO)"
* extension[specificPaymentDay].value[x] only unsignedInt
* extension[specificPaymentDay] ^short = "Jour spécifique de paiement (JOSPFO)"
* extension[minimumOrderAmount].value[x] only decimal
* extension[minimumOrderAmount] ^short = "Montant minimum de commande (MTMIFO)"

Extension: ExtCPageSupplierPublicProcurement
Id: ext-cpage-supplier-procurement
Title: "Marchés publics / groupement d'achat"
Description: "Assujetti code marchés publics, groupement d'achat, escomptable (FOU.TCMPFO, FOU.GACHFO, FOU.ESCOFO)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* extension contains
    publicProcurement 0..1 and
    purchasingGroup 0..1 and
    discountable 0..1
* extension[publicProcurement].value[x] only boolean
* extension[publicProcurement] ^short = "Assujetti code marchés publics (TCMPFO)"
* extension[purchasingGroup].value[x] only boolean
* extension[purchasingGroup] ^short = "Groupement d'achat (GACHFO)"
* extension[discountable].value[x] only boolean
* extension[discountable] ^short = "Escomptable (ESCOFO)"

Extension: ExtCPageSupplierChorus
Id: ext-cpage-supplier-chorus
Title: "Chorus fournisseur"
Description: "Informations Chorus : assujetti, type d'identifiant, identifiant (FOU.CHORFO, FOU.TIDCFO, FOU.IDCHFO)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* extension contains
    subjectToChorus 0..1 and
    chorusIdType 0..1 and
    chorusIdentifier 0..1
* extension[subjectToChorus].value[x] only boolean
* extension[subjectToChorus] ^short = "Assujetti Chorus (CHORFO)"
* extension[chorusIdType].value[x] only string
* extension[chorusIdType] ^short = "Type d'identifiant Chorus (TIDCFO)"
* extension[chorusIdentifier].value[x] only string
* extension[chorusIdentifier] ^short = "Identifiant Chorus (IDCHFO)"

Extension: ExtCPageSupplierInternalFlags
Id: ext-cpage-supplier-internal
Title: "Flags internes CPage fournisseur"
Description: "Drapeaux internes d'exploitation (FOU.EXTRFO, FOU.MAJ_FO, etc.)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* extension contains
    extractable 0..1 and
    changedSinceLastExtract 0..1
* extension[extractable].value[x] only boolean
* extension[extractable] ^short = "Extractible vers système externe (EXTRFO)"
* extension[changedSinceLastExtract].value[x] only boolean
* extension[changedSinceLastExtract] ^short = "Modifié depuis dernière extraction (MAJ_FO)"
