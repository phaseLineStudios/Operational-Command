# UnitSelect::_on_filter_text_changed Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 161–164)</br>
*Belongs to:* [UnitSelect](../UnitSelect.md)

**Signature**

```gdscript
func _on_filter_text_changed(_t: String) -> void
```

## Description

Handle text search filter changed

## Source

```gdscript
func _on_filter_text_changed(_t: String) -> void:
	_refresh_pool_filter()
```
