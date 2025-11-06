# UnitCreateDialog::_populate_move_profile Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 328–334)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _populate_move_profile() -> void
```

## Description

Populate move profile option button.

## Source

```gdscript
func _populate_move_profile() -> void:
	_move_ob.clear()
	var mp = TerrainBrush.MoveProfile
	for mp_name in mp.keys():
		_move_ob.add_item(String(mp_name), int(mp[mp_name]))
```
