# Limitation FSH/SUSHI sur les contraintes de string

Les contraintes directes de type `minLength`, `maxLength` et `pattern` sur les champs de type `string` (ex: `valueString`) ne sont pas supportées nativement dans FSH/SUSHI (v3.x). 

Pour imposer des contraintes de longueur ou de motif sur une string, il faut :
- Utiliser une Invariant FHIR (avec une expression FHIRPath) et l'appliquer via FSH avec la syntaxe `* obeys <invariant>`.
- Ou documenter la contrainte dans le short/definition, mais la validation automatique ne sera pas générée dans le profil.

Exemple d'invariant FSH :

Invariant: ribKeyLength
Description: "La clé RIB doit comporter exactement 2 chiffres."
Expression: "value.matches('^\\d{2}$')"
Severity: #error

* valueString obeys ribKeyLength

> Limitation : Les invariants sont visibles dans le profil, mais ne sont pas toujours appliqués par tous les validateurs FHIR.

Voir : https://build.fhir.org/ig/HL7/fhir-shorthand/reference.html#invariants
