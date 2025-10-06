# UnitSelect::_on_request_inspect_from_tree Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 363–367)</br>
*Belongs to:* [UnitSelect](../UnitSelect.md)

**Signature**

```gdscript
func _on_request_inspect_from_tree(unit: UnitData) -> void
```

## Description

Inspect unit from slot list and show stats

## Source

```gdscript
func _on_request_inspect_from_tree(unit: UnitData) -> void:
	_show_unit_stats(unit)
	_update_card_selection(unit)
```
