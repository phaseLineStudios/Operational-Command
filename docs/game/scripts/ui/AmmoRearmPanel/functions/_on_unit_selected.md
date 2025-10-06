# AmmoRearmPanel::_on_unit_selected Function Reference

*Defined at:* `scripts/ui/AmmoRearmPanel.gd` (lines 69–75)</br>
*Belongs to:* [AmmoRearmPanel](../AmmoRearmPanel.md)

**Signature**

```gdscript
func _on_unit_selected(idx: int) -> void
```

## Source

```gdscript
func _on_unit_selected(idx: int) -> void:
	if idx < 0 or idx >= _units.size():
		return
	var u: UnitData = _units[idx]
	_build_controls_for(u)
```
