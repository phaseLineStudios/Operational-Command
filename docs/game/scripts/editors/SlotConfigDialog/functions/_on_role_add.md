# SlotConfigDialog::_on_role_add Function Reference

*Defined at:* `scripts/editors/SlotConfigDialog.gd` (lines 66–74)</br>
*Belongs to:* [SlotConfigDialog](../SlotConfigDialog.md)

**Signature**

```gdscript
func _on_role_add()
```

## Description

Add role to role list

## Source

```gdscript
func _on_role_add():
	var role := roles_input.text
	if role in _roles:
		return
	_roles.append(role)
	roles_input.text = ""
	_refresh_role_list()
```
