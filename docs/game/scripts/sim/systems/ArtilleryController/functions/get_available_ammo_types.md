# ArtilleryController::get_available_ammo_types Function Reference

*Defined at:* `scripts/sim/systems/ArtilleryController.gd` (lines 145–170)</br>
*Belongs to:* [ArtilleryController](../../ArtilleryController.md)

**Signature**

```gdscript
func get_available_ammo_types(unit_id: String) -> Array[String]
```

## Description

Get available artillery ammunition types for a unit

## Source

```gdscript
func get_available_ammo_types(unit_id: String) -> Array[String]:
	var su: ScenarioUnit = _units.get(unit_id)
	if not su:
		return []

	var types: Array[String] = []

	# Check for mortar ammo
	if su.state_ammunition.get("MORTAR_AP", 0) > 0:
		types.append("MORTAR_AP")
	if su.state_ammunition.get("MORTAR_SMOKE", 0) > 0:
		types.append("MORTAR_SMOKE")
	if su.state_ammunition.get("MORTAR_ILLUM", 0) > 0:
		types.append("MORTAR_ILLUM")

	# Check for artillery ammo
	if su.state_ammunition.get("ARTILLERY_AP", 0) > 0:
		types.append("ARTILLERY_AP")
	if su.state_ammunition.get("ARTILLERY_SMOKE", 0) > 0:
		types.append("ARTILLERY_SMOKE")
	if su.state_ammunition.get("ARTILLERY_ILLUM", 0) > 0:
		types.append("ARTILLERY_ILLUM")

	return types
```
