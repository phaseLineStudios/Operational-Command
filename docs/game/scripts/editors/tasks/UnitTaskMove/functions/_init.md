# UnitTaskMove::_init Function Reference

*Defined at:* `scripts/editors/tasks/TaskMove.gd` (lines 9–13)</br>
*Belongs to:* [UnitTaskMove](../../UnitTaskMove.md)

**Signature**

```gdscript
func _init() -> void
```

## Description

Move to a position.

Keeps default params empty for now; extend as needed.

## Source

```gdscript
func _init() -> void:
	type_id = &"move"
	display_name = "Move"
	color = Color.SKY_BLUE
	icon = preload("res://assets/textures/ui/editors_task_move.png")
```
