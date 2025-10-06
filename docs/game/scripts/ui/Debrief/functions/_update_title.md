# Debrief::_update_title Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 341–346)</br>
*Belongs to:* [Debrief](../Debrief.md)

**Signature**

```gdscript
func _update_title() -> void
```

## Description

Keeps the bottom title in sync with the latest mission and outcome.

## Source

```gdscript
func _update_title() -> void:
	_title.text = (
		"Debrief: %s (%s)" % [_mission_name if _mission_name != "" else "<mission>", _outcome]
	)
```
