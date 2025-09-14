extends Resource
class_name ScenarioTask
## A placed task for a unit with per-instance params and linking

## Unique Id within scenario
@export var id: String
## The task definition
@export var task: UnitBaseTask
## World position (meters)
@export var position_m: Vector2
## Overrides per exported property of `task`
@export var params: Dictionary = {}
## Owner unit index in ScenarioData.units
@export var unit_index: int = -1
## Link to next ScenarioTask in the chain
@export var next_index: int = -1
## Link to previous ScenarioTask in the chain
@export var prev_index: int = -1
