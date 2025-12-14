# MissionSelect::_update_pin_highlight Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 191–220)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

**Signature**

```gdscript
func _update_pin_highlight() -> void
```

## Description

Highlight latest unlocked mission pin and fade previous ones.

## Source

```gdscript
func _update_pin_highlight() -> void:
	if _scenarios.is_empty():
		return

	var last_unlocked_idx := -1
	for i in range(_scenarios.size()):
		var m := _scenarios[i]
		if not _mission_locked.get(m.id, false):
			last_unlocked_idx = i

	if last_unlocked_idx == -1:
		return

	var last_unlocked_id: String = _scenarios[last_unlocked_idx].id

	for node in _pins_layer.get_children():
		if not (node is Control) or not node.has_meta("scenario_id"):
			continue

		var ctrl := node as Control
		var mission_id: String = ctrl.get_meta("scenario_id", "")

		if mission_id == last_unlocked_id:
			ctrl.set_meta("highlight_state", "current")
			ctrl.modulate = Color(1.0, 1.0, 1.0, 0.5)
		else:
			ctrl.set_meta("highlight_state", "dim")
			ctrl.modulate = Color(1.0, 1.0, 1.0, 1.0)
```
