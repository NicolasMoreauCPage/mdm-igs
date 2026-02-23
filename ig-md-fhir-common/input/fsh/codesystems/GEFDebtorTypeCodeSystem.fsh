// =============================================
// CodeSystem: Type Débiteur (GEF)
// =============================================

CodeSystem: GEFDebtorTypeCS
Id: gef-debtor-type-cs
Title: "Type Débiteur (GEF)"
Description: "Type de débiteur selon la nomenclature GEF. Utilisé dans les messages KERD (position 2) pour distinguer les débiteurs occasionnels des débiteurs normaux/réguliers."
* ^url = "http://cpage.org/fhir/CodeSystem/gef-debtor-type-cs"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* ^count = 2

* #O "Occasionnel" "Débiteur occasionnel - enregistrement ponctuel, non récurrent"
* #N "Normal" "Débiteur normal/régulier - enregistrement permanent, utilisé de façon récurrente"
