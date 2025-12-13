# EnvironmentController::_ready Function Reference

*Defined at:* `scripts/sim/EnvironmentController.gd` (lines 248–252)</br>
*Belongs to:* [EnvironmentController](../../EnvironmentController.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	set_process(Engine.is_editor_hint())
	_update_environment()
```
