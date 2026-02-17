// =============================================
// Profil Tiers Organization (basé sur FR Core)
// =============================================

Profile: TiersOrganization
Parent: $fr-core-organization
Id: tiers-organization
Title: "Tiers (générique)"
Description: "Profil générique pour la notion de Tiers (commun débiteur/fournisseur), basé sur FR Core Organization. Ce profil hérite des slices identifier déjà définis par FR Core (SIREN, SIRET, FINESS) et ajoute l'identifiant interne ETIER ainsi que la TVA intracommunautaire."

// FR Core définit déjà le slicing sur Organization.identifier + slices SIREN/SIRET/FINESS
// On ajoute uniquement nos slices supplémentaires

* identifier 1..* MS
  * system 1..1 MS
  * value 1..1 MS

* identifier contains
    etierId 1..1 MS and
    tva 0..1 MS

// Identifiant interne ETIER (ECO.ETIER.IDTITI)
* identifier[etierId].type = $v2-0203#RI "Resource identifier"
* identifier[etierId].system = $id-etier (exactly)
* identifier[etierId].value 1..1
* identifier[etierId] ^short = "Identifiant interne du tiers (IDTITI)"
* identifier[etierId] ^definition = "Identifiant unique interne du tiers issu de la table ECO.ETIER (champ IDTITI)."

// TVA intracommunautaire (ECO.ETIER.TVAITI)
* identifier[tva].type = $v2-0203#TAX "Tax ID number"
* identifier[tva].system = $id-tva (exactly)
* identifier[tva].value 1..1
* identifier[tva] ^short = "Numéro de TVA intracommunautaire"
* identifier[tva] ^definition = "Numéro de TVA intracommunautaire du tiers (champ TVAITI)."

// Nom / raison sociale (NORSTI)
* name 1..1 MS
* name ^short = "Raison sociale / nom du tiers"
* name ^definition = "Nom officiel du tiers (ECO.ETIER.NORSTI)."

// Complément de nom (COMPTI)
* alias 0..* MS
* alias ^short = "Nom complémentaire"
* alias ^definition = "Nom complémentaire ou alternatif du tiers (ECO.ETIER.COMPTI)."

// Adresse siège (AL1STI, AL2STI, AL3STI, CPOSTI, BDISTI, PAYSTI)
* address 0..* MS
* address ^short = "Adresse du siège"

// Télécom (TELETI, MAILTI, SITETI)
* telecom 0..* MS
* telecom ^short = "Contacts téléphoniques et emails"

// Actif / validité (VALITI)
* active 0..1 MS
* active ^short = "Tiers actif"
* active ^definition = "Indique si le tiers est actif. Peut être mappé depuis ECO.ETIER.VALITI (V=true, I=false)."

// Rôles génériques du tiers (debtor/supplier)
* extension contains ExtTiersRole named tiersRole 0..* MS
* extension[tiersRole] ^short = "Rôle(s) du tiers"
* extension[tiersRole] ^definition = "Rôle(s) générique(s) du tiers : fournisseur (supplier) si présent dans ECO.FOU, débiteur (debtor) si présent dans ECO.DBT."

// Note: FR Core Organization hérite déjà des contraintes suivantes :
// - identifier[siren] : SIREN (9 chiffres) - system = https://sirene.fr
// - identifier[siret] : SIRET (14 chiffres) - system = https://sirene.fr
// - identifier[finess] : FINESS - system = http://finess.sante.gouv.fr
// Ces slices sont automatiquement disponibles et ne doivent pas être redéfinis ici.
