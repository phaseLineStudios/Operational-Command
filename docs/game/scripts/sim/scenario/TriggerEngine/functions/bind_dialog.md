# TriggerEngine::bind_dialog Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 71–74)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

**Signature**

```gdscript
func bind_dialog(dialog: Control) -> void
```

- **dialog**: MissionDialog node for displaying trigger messages.

## Description

Bind mission dialog UI for trigger scripts.
Makes dialog available via `method TriggerAPI.show_dialog`.

## Source

```gdscript
func bind_dialog(dialog: Control) -> void:
	_api._mission_dialog = dialog
```

## References

- [`method TriggerAPI.show_dialog`](../../TriggerAPI.md#show_dialog)
