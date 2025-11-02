extends Node
class_name AIController
## Enemy AI task manager with Cold War doctrine behaviors.
##
## Maintains a rolling task list (defend, attack, delay, ambush) and reacts to
## player activity and simulation feedback to re-plan routes and objectives.

func register_unit(unit_id: int, agent: AIAgent, ordered_tasks: Array[Dictionary]) -> void:
	pass

func unregister_unit(unit_id: int) -> void:
	pass

func is_unit_idle(unit_id: int) -> bool:
	pass

func pause_unit(unit_id: int) -> void:
	pass

func resume_unit(unit_id: int) -> void:
	pass

func cancel_active(unit_id: int) -> void:
	pass

func advance_unit(unit_id: int) -> void:
	pass

func build_per_unit_queues(flat_tasks: Array[Dictionary]) -> Dictionary:
	pass

static func _cmp_by_index(a: Dictionary, b: Dictionary) -> bool:
	pass

func _physics_process(dt: float) -> void:
	pass
