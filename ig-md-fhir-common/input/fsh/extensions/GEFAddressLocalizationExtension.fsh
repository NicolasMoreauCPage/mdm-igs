// =============================================
// Extension: Localisation Adresse (GEF)
// =============================================

Extension: GEFAddressLocalization
Id: gef-address-localization
Title: "Localisation Adresse (GEF)"
Description: "Extension pour la localisation géographique de l'adresse selon la nomenclature GEF. Correspond au champ KERD 'Localisation' de l'adresse. Permet de qualifier si l'adresse se situe en France (métropole + DOM-TOM), en Europe (UE et pays européens hors UE), ou dans le reste du monde."
Context: Address
* ^url = "http://cpage.org/fhir/StructureDefinition/gef-address-localization"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Address"

* value[x] only code
* valueCode 1..1 MS
* valueCode from GEFAddressLocalizationVS (required)
* valueCode ^short = "Localisation : FRANCE, EUROPE, ou AUTRE"
* valueCode ^definition = "Code indiquant la zone géographique de l'adresse : France (métropole + outre-mer), Europe (UE et hors UE), ou Autre (reste du monde)"
