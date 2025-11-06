# EngineerController::_is_water_feature Function Reference

*Defined at:* `scripts/sim/systems/EngineerController.gd` (lines 304–323)</br>
*Belongs to:* [EngineerController](../../EngineerController.md)

**Signature**

```gdscript
func _is_water_feature(feature: Dictionary) -> bool
```

## Description

Check if a terrain feature is water-related

## Source

```gdscript
func _is_water_feature(feature: Dictionary) -> bool:
	var brush_path: String = feature.get("brush_path", "")
	if (
		brush_path.to_lower().contains("water")
		or brush_path.to_lower().contains("creek")
		or brush_path.to_lower().contains("river")
	):
		return true

	var brush: TerrainBrush = feature.get("brush", null)
	if brush:
		if brush.mv_tracked == 0.0 and brush.mv_wheeled == 0.0 and brush.mv_foot == 0.0:
			return true
		var title := brush.legend_title.to_lower()
		if title.contains("water") or title.contains("creek") or title.contains("river"):
			return true

	return false
```
