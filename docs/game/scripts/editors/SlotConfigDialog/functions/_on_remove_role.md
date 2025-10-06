# SlotConfigDialog::_on_remove_role Function Reference

*Defined at:* `scripts/editors/SlotConfigDialog.gd` (lines 76–81)</br>
*Belongs to:* [SlotConfigDialog](../SlotConfigDialog.md)

**Signature**

```gdscript
func _on_remove_role(role: String)
```

## Description

Remove a role from role list

## Source

```gdscript
func _on_remove_role(role: String):
	var idx := _roles.find(role)
	_roles.remove_at(idx)
	_refresh_role_list()
```
