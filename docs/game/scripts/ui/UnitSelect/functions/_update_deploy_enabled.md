# UnitSelect::_update_deploy_enabled Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 403–406)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _update_deploy_enabled() -> void
```

## Description

Enable/disable deploy button based on slot fill

## Source

```gdscript
func _update_deploy_enabled() -> void:
	_btn_deploy.disabled = _assigned_by_unit.size() != _total_slots
```
