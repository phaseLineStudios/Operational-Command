# GridLayer::mark_dirty Function Reference

*Defined at:* `scripts/terrain/GridLayer.gd` (lines 36–40)</br>
*Belongs to:* [GridLayer](../GridLayer.md)

**Signature**

```gdscript
func mark_dirty() -> void
```

## Source

```gdscript
func mark_dirty() -> void:
	_need_bake = true
	queue_redraw()
```
