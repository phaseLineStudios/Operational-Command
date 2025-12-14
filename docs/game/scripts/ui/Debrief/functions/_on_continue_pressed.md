# Debrief::_on_continue_pressed Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 372–375)</br>
*Belongs to:* [Debrief](../../Debrief.md)

**Signature**

```gdscript
func _on_continue_pressed() -> void
```

## Description

Emits "continue_requested" with a snapshot of the current debrief state.

## Source

```gdscript
func _on_continue_pressed() -> void:
	emit_signal("continue_requested", _collect_payload())
```
