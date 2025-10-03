extends UnitBaseTask
class_name UnitTask_SetCombatMode
## Set unit combat mode.

@export_enum("forced_hold_fire", "do_not_fire_unless_fired_upon", "open_fire") var combat_mode: int = 2


func _init() -> void:
	type_id = &"set_combat_mode"
	display_name = "Set Combat Mode"
	color = Color.INDIAN_RED
	icon = preload("res://assets/textures/ui/editors_task_combatmode.png")
