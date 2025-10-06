# UnitSelect::_refresh_pool_filter Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 184–201)</br>
*Belongs to:* [UnitSelect](../UnitSelect.md)

**Signature**

```gdscript
func _refresh_pool_filter() -> void
```

## Description

Refresh pool visibility based on filter/search/assignment

## Source

```gdscript
func _refresh_pool_filter() -> void:
	var roles := _active_roles()
	var search := _search.text.strip_edges().to_lower()
	for unit_id in _cards_by_unit.keys():
		var card: UnitCard = _cards_by_unit[unit_id]
		if not is_instance_valid(card):
			continue
		var u: UnitData = _units_by_id[unit_id]
		var role_ok := roles.is_empty() or roles.has(u.role)
		var text_ok := (
			search.is_empty()
			or u.title.to_lower().find(search) >= 0
			or String(unit_id).to_lower().find(search) >= 0
		)
		var in_use := _assigned_by_unit.has(unit_id)
		card.visible = role_ok and text_ok and not in_use
```
