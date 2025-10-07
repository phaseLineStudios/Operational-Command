# ActionRebindButton::refresh_label Function Reference

*Defined at:* `scripts/ui/helpers/ActionRebindButton.gd` (lines 19–26)</br>
*Belongs to:* [ActionRebindButton](../../ActionRebindButton.md)

**Signature**

```gdscript
func refresh_label() -> void
```

## Description

Update text from current binding.

## Source

```gdscript
func refresh_label() -> void:
	if action_name == "":
		text = "(unset)"
		return
	var events := InputMap.action_get_events(action_name)
	text = events[0].as_text() if events.size() > 0 else "(unbound)"
```
