# ReinforcementPanel::_emit_preview Function Reference

*Defined at:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd` (lines 322–325)</br>
*Belongs to:* [ReinforcementPanel](../../ReinforcementPanel.md)

**Signature**

```gdscript
func _emit_preview(uid: String, amt: int) -> void
```

## Description

Emit preview signal.

## Source

```gdscript
func _emit_preview(uid: String, amt: int) -> void:
	emit_signal("reinforcement_preview_changed", uid, amt)
```
