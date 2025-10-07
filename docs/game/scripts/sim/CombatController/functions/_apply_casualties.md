# CombatController::_apply_casualties Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 282–299)</br>
*Belongs to:* [CombatController](../../CombatController.md)

**Signature**

```gdscript
func _apply_casualties(u: UnitData, raw_losses: int) -> int
```

## Description

Apply casualties to runtime state. Returns actual KIA + WIA applied

## Source

```gdscript
func _apply_casualties(u: UnitData, raw_losses: int) -> int:
	if u == null or raw_losses <= 0:
		return 0
	var before := int(round(u.state_strength))
	var loss: int = clamp(raw_losses, 0, before)
	u.state_strength = float(before - loss)

	var wia_ratio := 0.6
	u.state_injured = max(0.0, u.state_injured + float(round(loss * wia_ratio)))

	var coh_per_cas := 0.01
	u.cohesion = clamp(u.cohesion - float(loss) * coh_per_cas, 0.0, 1.0)

	var eqp_per_cas := 0.01
	u.state_equipment = max(0.0, u.state_equipment - float(loss) * eqp_per_cas)
	return loss
```
