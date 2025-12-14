# EnvBehaviorSystem::_near_landmark Function Reference

*Defined at:* `scripts/sim/systems/EnvBehaviorSystem.gd` (lines 310–328)</br>
*Belongs to:* [EnvBehaviorSystem](../../EnvBehaviorSystem.md)

**Signature**

```gdscript
func _near_landmark(unit: ScenarioUnit) -> bool
```

## Description

Recovery helper: detect nearby map labels as landmarks.

## Source

```gdscript
func _near_landmark(unit: ScenarioUnit) -> bool:
	if movement_adapter == null or movement_adapter.renderer == null:
		return false
	if unit == null:
		return false
	var data := movement_adapter.renderer.data
	if data == null or data.labels == null:
		return false
	for lab in data.labels:
		if typeof(lab) != TYPE_DICTIONARY:
			continue
		var pos: Variant = lab.get("pos", null)
		if typeof(pos) != TYPE_VECTOR2:
			continue
		if (pos as Vector2).distance_to(unit.position_m) <= landmark_recovery_radius_m:
			return true
	return false
```
