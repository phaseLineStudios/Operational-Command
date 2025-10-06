# CombatController::_ready Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 55–81)</br>
*Belongs to:* [CombatController](../CombatController.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Init

## Source

```gdscript
func _ready() -> void:
	# Ammo adapter wiring
	if combat_adapter_path != NodePath(""):
		_adapter = get_node(combat_adapter_path) as CombatAdapter
	if _adapter == null:
		_adapter = get_tree().get_first_node_in_group("CombatAdapter") as CombatAdapter

	# Build ScenarioUnit wrappers for the imported UnitData (test harness)
	attacker_su = _make_su(imported_attacker, "ALPHA", Vector2(0, 0))
	defender_su = _make_su(imported_defender, "BRAVO", Vector2(300, 0))

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
