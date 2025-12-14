# UnitSelect::_ready Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 88–97)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Build UI, load mission

## Source

```gdscript
func _ready() -> void:
	_connect_ui()
	_load_mission()
	_refresh_topbar()
	_refresh_filters()
	_update_deploy_enabled()
	_update_logistics_labels(0, 0, 0, 0)
	_init_supply_pools()
```
