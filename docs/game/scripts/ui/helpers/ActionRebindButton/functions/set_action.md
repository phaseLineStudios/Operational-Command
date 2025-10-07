# ActionRebindButton::set_action Function Reference

*Defined at:* `scripts/ui/helpers/ActionRebindButton.gd` (lines 13–17)</br>
*Belongs to:* [ActionRebindButton](../../ActionRebindButton.md)

**Signature**

```gdscript
func set_action(new_name: String) -> void
```

## Description

Set action programmatically.

## Source

```gdscript
func set_action(new_name: String) -> void:
	action_name = new_name
	refresh_label()
```
