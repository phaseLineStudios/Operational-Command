# Debrief::_on_retry_pressed Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 377–380)</br>
*Belongs to:* [Debrief](../../Debrief.md)

**Signature**

```gdscript
func _on_retry_pressed() -> void
```

## Description

Emits "retry_requested" with the same payload format as continue.

## Source

```gdscript
func _on_retry_pressed() -> void:
	emit_signal("retry_requested", _collect_payload())
```
