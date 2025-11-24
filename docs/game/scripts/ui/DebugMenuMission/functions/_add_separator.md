# DebugMenuMission::_add_separator Function Reference

*Defined at:* `scripts/ui/DebugMenuMission.gd` (lines 132–140)</br>
*Belongs to:* [DebugMenuMission](../../DebugMenuMission.md)

**Signature**

```gdscript
func _add_separator() -> void
```

## Description

Add a separator row

## Source

```gdscript
func _add_separator() -> void:
	var separator1 := HSeparator.new()
	separator1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mission_content.add_child(separator1)
	var separator2 := HSeparator.new()
	separator2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mission_content.add_child(separator2)
```
