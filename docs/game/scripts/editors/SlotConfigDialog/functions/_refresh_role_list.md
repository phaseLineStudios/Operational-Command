# SlotConfigDialog::_refresh_role_list Function Reference

*Defined at:* `scripts/editors/SlotConfigDialog.gd` (lines 87–103)</br>
*Belongs to:* [SlotConfigDialog](../../SlotConfigDialog.md)

**Signature**

```gdscript
func _refresh_role_list()
```

## Description

Refresh role list

## Source

```gdscript
func _refresh_role_list():
	editor._queue_free_children(roles_list)
	for role in _roles:
		var rwp := PanelContainer.new()
		var row := HBoxContainer.new()
		var lbl := Label.new()
		lbl.text = role
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(lbl)
		var btn := Button.new()
		btn.text = "Remove"
		btn.pressed.connect(func(): _on_remove_role(role))
		row.add_child(btn)
		rwp.add_child(row)
		roles_list.add_child(rwp)
```
