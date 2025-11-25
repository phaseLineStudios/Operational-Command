class_name EnvBehaviorSystem
extends Node
## Computes visibility, loss rolls, and terrain slowdowns; ticks navigation states.
## Stub only—implement behaviour, signals, and integrations in a later task.

# Signals (documented in task):
signal unit_lost(unit_id: String)
signal unit_recovered(unit_id: String)
signal unit_bogged(unit_id: String)
signal unit_unbogged(unit_id: String)
signal speed_modifier_changed(unit_id: String, multiplier: float)
signal navigation_bias_changed(unit_id: String, bias: StringName)

# TODO: add exports for TerrainRender/LOSAdapter/VisibilityProfile/MovementAdapter/SimWorld RNG, etc.

