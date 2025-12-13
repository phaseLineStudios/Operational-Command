# Settings::_connect_signals Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 167–179)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func _connect_signals() -> void
```

## Description

Wire up buttons and live labels.

## Source

```gdscript
func _connect_signals() -> void:
	btn_back.pressed.connect(
		func():
			if back_scene != null:
				Game.goto_scene(back_scene.resource_path)
			emit_signal("back_requested")
	)
	_btn_apply.pressed.connect(_apply_and_save)
	_btn_defaults.pressed.connect(_reset_defaults)
	_reset_bindings.pressed.connect(_reset_all_bindings)
	_scale.value_changed.connect(func(v: float): _scale_val.text = "%d%%" % int(v))
```
