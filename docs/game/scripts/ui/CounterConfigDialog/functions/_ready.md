# CounterConfigDialog::_ready Function Reference

*Defined at:* `scripts/ui/CounterConfigDialog.gd` (lines 23–35)</br>
*Belongs to:* [CounterConfigDialog](../../CounterConfigDialog.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	close_requested.connect(func(): hide())
	close_btn.pressed.connect(func(): hide())
	create_btn.pressed.connect(_on_create_pressed)

	_populate_affiliation()
	_populate_types()
	_populate_sizes()

	# Set default callsign
	callsign.text = "ALPHA"
```
