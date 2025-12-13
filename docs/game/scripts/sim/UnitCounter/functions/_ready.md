# UnitCounter::_ready Function Reference

*Defined at:* `scripts/sim/UnitCounter.gd` (lines 37–46)</br>
*Belongs to:* [UnitCounter](../../UnitCounter.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	var color := _get_base_color()

	var face := await _generate_face(color)
	_ensure_mesh_materials(color, face)

	# Emit signal when texture generation is complete
	texture_ready.emit()
```
