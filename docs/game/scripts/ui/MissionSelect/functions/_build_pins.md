# MissionSelect::_build_pins Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 77–87)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

**Signature**

```gdscript
func _build_pins() -> void
```

## Description

Create pins and position them (normalized coords).

## Source

```gdscript
func _build_pins() -> void:
	_clear_children(_pins_layer)
	for m in _scenarios:
		var pin := _make_pin(m)
		pin.set_meta("pos_norm", m.map_position)
		pin.set_meta("title", m.title)
		pin.pressed.connect(func(): _on_pin_pressed(m, pin))
		_pins_layer.add_child(pin)
	_update_pin_positions()
```
