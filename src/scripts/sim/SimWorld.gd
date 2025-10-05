extends Node
## Authoritative battlefield simulation (state, movement, combat, LOS).
##
## Holds all unit entities and resolves ticks deterministically. Integrates
## visibility LOS.gd and combat Combat.gd and
## exposes read-only views for UI.

func _ready():
	Game.start_scenario([])
