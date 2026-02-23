// =============================================
// CodeSystem: GEF Identifier Type
// =============================================

CodeSystem: GEFIdentifierTypeCS
Id: gef-identifier-type-cs
Title: "Type d'identifiant GEF"
Description: "Codes pour types d'identifiants dans les interfaces GEF (EFOU, KERD). Correspond au champ 'Type identifiant' des messages GEF."
* ^url = "http://cpage.org/fhir/CodeSystem/gef-identifier-type-cs"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* ^count = 9

* #01 "SIRET" "Système d'Identification du Répertoire des ETablissements (14 caractères)"
* #02 "SIREN" "Système d'Identification du Répertoire des ENtreprises (9 caractères)"
* #03 "FINESS" "Fichier National des Établissements Sanitaires et Sociaux (9 caractères)"
* #04 "NIR" "Numéro d'Inscription au Répertoire - Sécurité Sociale (15 caractères)"
* #05 "TVA" "TVA intracommunautaire (numéro de TVA intra-UE)"
* #06 "HORS_UE" "Identifiant hors Union Européenne"
* #07 "TAHITI" "Numéro Tahiti (Polynésie française)"
* #08 "RIDET" "RIDET Nouméa (Nouvelle-Calédonie)"
* #09 "EN_COURS" "Fournisseur en cours d'immatriculation (identifiant temporaire)"
