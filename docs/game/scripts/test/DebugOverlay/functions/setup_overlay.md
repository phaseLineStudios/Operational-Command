# DebugOverlay::setup_overlay Function Reference

*Defined at:* `scripts/test/DebugOverlay.gd` (lines 21–26)</br>
*Belongs to:* [DebugOverlay](../DebugOverlay.md)

**Signature**

```gdscript
func setup_overlay(renderer: TerrainRender, units: Array) -> void
```

## Source

```gdscript
func setup_overlay(renderer: TerrainRender, units: Array) -> void:
	_renderer = renderer
	_units = units
	queue_redraw()
```
