extends Node
class_name ScenarioTaskRunner

signal task_started(unit_id: int, task_type: StringName)
signal task_completed(unit_id: int, task_type: StringName)
signal task_failed(unit_id: int, task_type: StringName, reason: StringName)

func setup(p_unit_id: int, ordered_tasks: Array[Dictionary]) -> void:
	pass

func is_idle() -> bool:
	pass

func pause() -> void:
	pass

func resume() -> void:
	pass

func cancel_active() -> void:
	pass

func advance() -> void:
	pass

func _start_next() -> void:
	pass

func tick(dt: float, agent: AIAgent) -> void:
	pass
