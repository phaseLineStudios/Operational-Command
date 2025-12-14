# MissionSelect::_build_pins Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 99–119)</br>
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
	_update_mission_locked_states()

	for m in _scenarios:
		var is_locked: bool = _mission_locked.get(m.id, false)
		if is_locked:
			continue
		var pin := _make_pin(m)
		pin.set_meta("pos_norm", m.map_position)
		pin.set_meta("title", m.title)
		pin.set_meta("scenario_id", m.id)
		pin.pressed.connect(func(): _on_pin_pressed(m, pin))
		pin.mouse_entered.connect(_on_pin_mouse_entered.bind(pin))
		pin.mouse_exited.connect(_on_pin_mouse_exited.bind(pin))

		_pins_layer.add_child(pin)
	_update_pin_positions()
	_update_pin_highlight()
```
