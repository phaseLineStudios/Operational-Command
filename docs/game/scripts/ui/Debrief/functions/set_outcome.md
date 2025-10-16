# Debrief::set_outcome Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 148–152)</br>
*Belongs to:* [Debrief](../../Debrief.md)

**Signature**

```gdscript
func set_outcome(outcome: String) -> void
```

## Description

Sets the outcome label text and refreshes the title label.

## Source

```gdscript
func set_outcome(outcome: String) -> void:
	_outcome = outcome
	_update_title()
```
