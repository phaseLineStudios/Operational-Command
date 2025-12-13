# UnitMgmt::_on_preview_changed Function Reference

*Defined at:* `scripts/ui/UnitMgmt.gd` (lines 104–109)</br>
*Belongs to:* [UnitMgmt](../../UnitMgmt.md)

**Signature**

```gdscript
func _on_preview_changed(_unit_id: String, _amt: int) -> void
```

## Description

Live preview hook from panel (visual-only here).

## Source

```gdscript
func _on_preview_changed(_unit_id: String, _amt: int) -> void:
	# This screen doesn't need a live preview side-effect;
	# values are applied on commit. Arguments prefixed with '_' to satisfy gdlint.
	pass
```
