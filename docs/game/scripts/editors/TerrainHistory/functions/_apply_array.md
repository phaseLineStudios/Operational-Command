# TerrainHistory::_apply_array Function Reference

*Defined at:* `scripts/editors/TerrainHistory.gd` (lines 129–133)</br>
*Belongs to:* [TerrainHistory](../TerrainHistory.md)

**Signature**

```gdscript
func _apply_array(data: TerrainData, array_name: String, value: Array) -> void
```

## Description

Replace `data[array_name]` with `value` and emit change.

## Source

```gdscript
func _apply_array(data: TerrainData, array_name: String, value: Array) -> void:
	data.set(array_name, value)
	_emit_changed(data)
```
