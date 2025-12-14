# ReinforcementPanel::_disable_row Function Reference

*Defined at:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd` (lines 222–227)</br>
*Belongs to:* [ReinforcementPanel](../../ReinforcementPanel.md)

**Signature**

```gdscript
func _disable_row(w: RowWidgets, disabled: bool) -> void
```

## Description

Enable/disable row interactivity.

## Source

```gdscript
func _disable_row(w: RowWidgets, disabled: bool) -> void:
	w.minus.disabled = disabled
	w.plus.disabled = disabled
	w.slider.editable = not disabled
```
