# UnitTaskWait::_init Function Reference

*Defined at:* `scripts/editors/tasks/TaskWait.gd` (lines 8–14)</br>
*Belongs to:* [UnitTaskWait](../../UnitTaskWait.md)

**Signature**

```gdscript
func _init() -> void
```

## Source

```gdscript
func _init() -> void:
	type_id = &"wait"
	display_name = "Wait"
	color = Color.SLATE_GRAY
	icon = preload("res://assets/textures/ui/editors_task_wait.png")
```
