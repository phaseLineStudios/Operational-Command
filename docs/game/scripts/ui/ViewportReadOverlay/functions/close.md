# ViewportReadOverlay::close Function Reference

*Defined at:* `scripts/ui/ViewportReadOverlay.gd` (lines 49–53)</br>
*Belongs to:* [ViewportReadOverlay](../../ViewportReadOverlay.md)

**Signature**

```gdscript
func close() -> void
```

## Source

```gdscript
func close() -> void:
	closed.emit()
	queue_free()
```
