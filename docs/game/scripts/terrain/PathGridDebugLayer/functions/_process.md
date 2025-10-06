# PathGridDebugLayer::_process Function Reference

*Defined at:* `scripts/terrain/PathGridDebugLayer.gd` (lines 14–16)</br>
*Belongs to:* [PathGridDebugLayer](../PathGridDebugLayer.md)

**Signature**

```gdscript
func _process(_d: float) -> void
```

## Source

```gdscript
func _process(_d: float) -> void:
	if grid and grid.debug_enabled:
		queue_redraw()
```
