@icon("res://assets/textures/ui/editors_task_move.png")
extends UnitBaseTask
class_name UnitTask_Move
## Move to a position.
##
## Keeps default params empty for now; extend as needed.

func _init() -> void:
	type_id = &"move"
	display_name = "Move"
	color = Color.SKY_BLUE
	icon = preload("res://assets/textures/ui/editors_task_move.png")
