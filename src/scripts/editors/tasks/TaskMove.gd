@icon("res://assets/textures/ui/editors_task_move.png")
class_name UnitTaskMove
extends UnitBaseTask
## Move to a position.
##
## Keeps default params empty for now; extend as needed.


func _init() -> void:
	type_id = &"move"
	display_name = "Move"
	color = Color.SKY_BLUE
	icon = preload("res://assets/textures/ui/editors_task_move.png")
