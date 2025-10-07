# CombatController::_make_su Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 83–100)</br>
*Belongs to:* [CombatController](../../CombatController.md)

**Signature**

```gdscript
func _make_su(u: UnitData, cs: String, pos: Variant) -> ScenarioUnit
```

## Description

Minimal factory for a ScenarioUnit used by this controller (test harness)

## Source

```gdscript
func _make_su(u: UnitData, cs: String, pos: Variant) -> ScenarioUnit:
	var su := ScenarioUnit.new()
	su.unit = u
	su.callsign = cs

	# Accept Vector2 or Vector3; convert 3D ground coords (x,z) -> 2D
	var p2: Vector2
	if pos is Vector2:
		p2 = pos
	elif pos is Vector3:
		p2 = Vector2((pos as Vector3).x, (pos as Vector3).z)
	else:
		p2 = Vector2.ZERO

	su.position_m = p2
	return su
```
