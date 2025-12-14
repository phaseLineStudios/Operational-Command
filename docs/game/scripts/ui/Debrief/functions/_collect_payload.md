# Debrief::_collect_payload Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 382–392)</br>
*Belongs to:* [Debrief](../../Debrief.md)

**Signature**

```gdscript
func _collect_payload() -> Dictionary
```

## Description

Collects a snapshot of all user-visible state for higher-level flow management.

## Source

```gdscript
func _collect_payload() -> Dictionary:
	return {
		"mission_name": _mission_name,
		"outcome": _outcome,
		"score": _score,
		"casualties": _casualties,
		"selected_commendation": get_selected_commendation(),
		"selected_recipient": get_selected_recipient()
	}
```
