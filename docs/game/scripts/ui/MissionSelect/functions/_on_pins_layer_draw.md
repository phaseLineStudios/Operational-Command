# MissionSelect::_on_pins_layer_draw Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 348–394)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

**Signature**

```gdscript
func _on_pins_layer_draw() -> void
```

## Description

Draw mission path between pins in campaign order.

## Source

```gdscript
func _on_pins_layer_draw() -> void:
	if _scenarios.size() < 2:
		return

	var color_to_unplayed := Color(1.0, 1.0, 1.0, 0.5)
	var color_default := Color(1.0, 1.0, 1.0, 1.0)
	var width := 1.0
	var antialias := true
	var gap: float = float(pin_size.x) * 0.4

	var latest_unplayed_idx := -1
	if Game.current_save:
		for i in range(_scenarios.size()):
			var m := _scenarios[i]
			if not Game.current_save.is_mission_completed(m.id):
				latest_unplayed_idx = i
				break

	if latest_unplayed_idx == -1:
		latest_unplayed_idx = _scenarios.size()

	for i in range(_scenarios.size() - 1):
		var from_mission := _scenarios[i]
		var to_mission := _scenarios[i + 1]

		if not _pin_centers_by_id.has(from_mission.id) or not _pin_centers_by_id.has(to_mission.id):
			continue

		var from_center: Vector2 = _pin_centers_by_id[from_mission.id]
		var to_center: Vector2 = _pin_centers_by_id[to_mission.id]

		var segment: Vector2 = to_center - from_center
		var length := segment.length()
		if length <= gap * 2.0:
			continue

		var dir: Vector2 = segment / length
		var from_pt: Vector2 = from_center + dir * gap
		var to_pt: Vector2 = to_center - dir * gap

		var to_idx := i + 1
		var is_to_unplayed := to_idx == latest_unplayed_idx
		var color := color_to_unplayed if is_to_unplayed else color_default

		_pins_layer.draw_line(from_pt, to_pt, color, width, antialias)
```
