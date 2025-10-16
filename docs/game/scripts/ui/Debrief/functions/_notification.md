# Debrief::_notification Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 133–137)</br>
*Belongs to:* [Debrief](../../Debrief.md)

**Signature**

```gdscript
func _notification(what)
```

## Description

Reapplies alignment when the control is resized by the parent or user.

## Source

```gdscript
func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_align_right_split()
```
