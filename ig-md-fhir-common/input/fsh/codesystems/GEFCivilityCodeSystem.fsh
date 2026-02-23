// =============================================
// CodeSystem: Civilité (GEF)
// =============================================

CodeSystem: GEFCivilityCS
Id: gef-civility-cs
Title: "Civilité (GEF)"
Description: "Codes de civilité selon la nomenclature GEF. Utilisé dans les messages KERD (position 10) pour les débiteurs de Catégorie TG = 01 (Personne physique). Obligatoire si le débiteur est une personne physique."
* ^url = "http://cpage.org/fhir/CodeSystem/gef-civility-cs"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* ^count = 5

* #M "Monsieur" "Monsieur"
* #MME "Madame" "Madame"
* #MLLE "Mademoiselle" "Mademoiselle"
* #METMME "Monsieur et Madame" "Monsieur et Madame (couple)"
* #MOUMME "Monsieur ou Madame" "Monsieur ou Madame (indéterminé)"
