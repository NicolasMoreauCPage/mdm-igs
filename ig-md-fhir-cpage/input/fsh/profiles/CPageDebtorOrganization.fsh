// =============================================
// Profil CPage Debtor Organization
// =============================================

Profile: CPageDebtorOrganization
Parent: $tiers-organization
Id: cpage-debtor-organization
Title: "Tiers Débiteur (CPage)"
Description: "Profil CPage pour un tiers débiteur. Hérite du profil TiersOrganization générique et ajoute les extensions métier issues de la table ECO.DBT (rôle débiteur)."

// Extensions CPage spécifiques
* extension contains
    ExtCPageValidity named cpageValidity 0..1 MS and
    ExtCPageEUZone named cpageEUZone 0..1 MS and
    ExtCPageDebtorResidency named residency 0..1 MS and
    ExtCPageDebtorAccount named debtorAccount 0..1 MS and
    ExtCPageDebtorAsap named asap 0..1 MS and
    ExtCPageDebtorExternalId named externalId 0..1 MS and
    ExtCPageDebtorAssociatedSupplier named associatedSupplier 0..1

* extension[cpageValidity] ^short = "Validité du débiteur (INVADT)"
* extension[cpageEUZone] ^short = "Zone européenne (EUROTI)"
* extension[residency] ^short = "Résidence débiteur (RESIDT)"
* extension[debtorAccount] ^short = "Compte tiers débiteur"
* extension[asap] ^short = "Paramètres ASAP"
* extension[externalId] ^short = "Identifiant externe (IDEXDT)"
* extension[associatedSupplier] ^short = "Fournisseur associé (NUFODT)"

// Note: L'extension tiersRole (héritée) doit contenir au moins #debtor
* extension[tiersRole] ^comment = "Pour ce profil débiteur, l'extension tiersRole devrait contenir au moins le code 'debtor'."
