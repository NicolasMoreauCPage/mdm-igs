// =============================================
// Extension Flags internes CPage fournisseur
// =============================================

Extension: CPageSupplierInternalFlags
Id: cpage-supplier-internal
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
