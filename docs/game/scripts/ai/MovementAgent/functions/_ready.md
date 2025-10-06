# MovementAgent::_ready Function Reference

*Defined at:* `scripts/ai/MovementAgent.gd` (lines 52–57)</br>
*Belongs to:* [MovementAgent](../MovementAgent.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	if grid and wait_for_grid_ready:
		grid.build_ready.connect(_on_grid_ready)
		grid.grid_rebuilt.connect(func(): _on_grid_ready(grid._build_profile))
```
