# DebugOverlay::update_debug Function Reference

*Defined at:* `scripts/test/DebugOverlay.gd` (lines 47–51)</br>
*Belongs to:* [DebugOverlay](../../DebugOverlay.md)

**Signature**

```gdscript
func update_debug(d: Dictionary) -> void
```

## Source

```gdscript
func update_debug(d: Dictionary) -> void:
	_dbg = d
	queue_redraw()
```
