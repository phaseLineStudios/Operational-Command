extends Node
## Authoritative battlefield simulation (state, movement, combat, LOS).
##
## Holds all unit entities and resolves ticks deterministically. Integrates
## visibility ([code]LOS.gd[/code]) and combat ([code]Combat.gd[/code]) and
## exposes read-only views for UI.
