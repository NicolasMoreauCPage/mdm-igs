// =============================================
// Profil CPage Supplier Organization
// =============================================

Profile: CPageSupplierOrganization
Parent: $tiers-organization
Id: cpage-supplier-organization
Title: "Tiers Fournisseur (CPage)"
Description: "Profil CPage pour un tiers fournisseur. Hérite du profil TiersOrganization générique et ajoute les extensions métier issues de la table ECO.FOU (rôle fournisseur)."

// Extensions CPage spécifiques
* extension contains
    ExtCPageValidity named cpageValidity 0..1 MS and
    ExtCPageEUZone named cpageEUZone 0..1 MS and
    ExtCPageSupplierAccountingClass6 named accountingClass6 0..1 MS and
    ExtCPageSupplierAccountingClass2 named accountingClass2 0..1 MS and
    ExtCPageSupplierPaymentTerms named paymentTerms 0..1 MS and
    ExtCPageSupplierPublicProcurement named procurement 0..1 MS and
    ExtCPageSupplierChorus named chorus 0..1 MS and
    ExtCPageSupplierInternalFlags named internalFlags 0..1

* extension[cpageValidity] ^short = "Validité du fournisseur (VALIFO)"
* extension[cpageEUZone] ^short = "Zone européenne (EUROTI)"
* extension[accountingClass6] ^short = "Comptabilité classe 6"
* extension[accountingClass2] ^short = "Comptabilité classe 2"
* extension[paymentTerms] ^short = "Conditions de paiement"
* extension[procurement] ^short = "Informations marchés publics"
* extension[chorus] ^short = "Informations Chorus"
* extension[internalFlags] ^short = "Flags internes système"

// Note: L'extension tiersRole (héritée) doit contenir au moins #supplier
// Mais FHIRPath constraint sur extensions parent non supporté partout, donc documenté uniquement
* extension[tiersRole] ^comment = "Pour ce profil fournisseur, l'extension tiersRole devrait contenir au moins le code 'supplier'."
