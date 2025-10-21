# InteractionController::_ready Function Reference

*Defined at:* `scripts/core/PlayerInteraction.gd` (lines 18–23)</br>
*Belongs to:* [InteractionController](../../InteractionController.md)

**Signature**

```gdscript
func _ready()
```

## Source

```gdscript
func _ready():
	bounds.transparency = 1
	_half_x = bounds.mesh.size.x * 0.5
	_half_z = bounds.mesh.size.y * 0.5
```
