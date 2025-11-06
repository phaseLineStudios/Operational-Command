# UnitCreateDialog::_populate_ammo Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 350–372)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _populate_ammo() -> void
```

## Description

Populate Ammo

## Source

```gdscript
func _populate_ammo() -> void:
	for c in _ammo_container.get_children():
		c.queue_free()

	_ammo_spinners.clear()
	_ammo_keys.clear()

	for ammo_name in UnitData.AmmoTypes.keys():
		var lbl := Label.new()
		lbl.text = ammo_name

		var amt := SpinBox.new()
		amt.max_value = 20_000
		amt.value = 0
		amt.suffix = "rnds"

		_ammo_container.add_child(lbl)
		_ammo_container.add_child(amt)

		_ammo_keys.append(ammo_name)
		_ammo_spinners.append(amt)
```
