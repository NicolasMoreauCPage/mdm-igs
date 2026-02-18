// =============================================
// Extension Conditions de paiement fournisseur
// =============================================

Extension: CPageSupplierPaymentTerms
Id: cpage-supplier-payment
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
