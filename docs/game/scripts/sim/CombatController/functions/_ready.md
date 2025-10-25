# CombatController::_ready Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 53–74)</br>
*Belongs to:* [CombatController](../../CombatController.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Init

## Source

```gdscript
func _ready() -> void:
	# Build ScenarioUnit wrappers for the imported UnitData (test harness)
	attacker_su = _make_su(imported_attacker, "ALPHA", Vector2(0, 0))
	defender_su = _make_su(imported_defender, "BRAVO", Vector2(300, 0))

	if debug_enabled:
		notify_health.connect(print_unit_status)

	# Start loop with ScenarioUnits
	combat_loop(attacker_su, defender_su)

	_debug_timer = Timer.new()
	_debug_timer.one_shot = false
	add_child(_debug_timer)
	_debug_timer.timeout.connect(
		func():
			if debug_enabled and _cur_att != null and _cur_def != null:
				_emit_debug_snapshot(_cur_att, _cur_def, false)
	)
	_set_debug_rate()
```
