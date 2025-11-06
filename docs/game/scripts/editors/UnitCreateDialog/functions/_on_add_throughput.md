# UnitCreateDialog::_on_add_throughput Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 477–490)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _on_add_throughput() -> void
```

## Description

Add throughput to list.

## Source

```gdscript
func _on_add_throughput() -> void:
	var k := _th_key.text.strip_edges()
	var v := float(_th_val.value)
	if k == "":
		return
	if _thru.has(k):
		_replace_kv_row(_th_list, k, v)
	else:
		_add_kv_row(_th_list, k, v, _on_delete_throughput_row)
	_thru[k] = v
	_th_key.clear()
	_th_val.value = 0.0
```
