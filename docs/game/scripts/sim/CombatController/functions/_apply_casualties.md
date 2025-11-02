# CombatController::_apply_casualties Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 298–320)</br>
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

	# Record for debrief summary (does NOT re-apply at debrief unless change policy)
	var game := get_tree().get_root().get_node_or_null("/root/Game")
	if game and game.has_node("resolution"):
		game.resolution.add_unit_losses(u.id, loss)

	var wia_ratio := 0.6
	u.state_injured = max(0.0, u.state_injured + float(round(loss * wia_ratio)))

	var coh_per_cas := 0.01
	u.cohesion = clamp(u.cohesion - float(loss) * coh_per_cas, 0.0, 1.0)

	var eqp_per_cas := 0.01
	u.state_equipment = max(0.0, u.state_equipment - float(loss) * eqp_per_cas)
	return loss
```
