extends UnitBaseTask
class_name UnitTask_SetBehaviour
## Set unit behaviour.

@export_enum("careless", "safe", "aware", "combat", "stealth") var behaviour: int = 1


func _init() -> void:
	type_id = &"set_behaviour"
	display_name = "Set Behaviour"
	color = Color.DARK_TURQUOISE
	icon = preload("res://assets/textures/ui/editors_task_behaviour.png")
