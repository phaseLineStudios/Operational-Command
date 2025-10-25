# Debrief::_request_align Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 422–425)</br>
*Belongs to:* [Debrief](../../Debrief.md)

**Signature**

```gdscript
func _request_align() -> void
```

## Description

Defers alignment one frame so container sizes update before measuring.

## Source

```gdscript
func _request_align() -> void:
	call_deferred("_align_right_split")
```
