# ReinforcementTest::_test_spawn Function Reference

*Defined at:* `scripts/test/ReinforcementTest.gd` (lines 215–246)</br>
*Belongs to:* [ReinforcementTest](../../ReinforcementTest.md)

**Signature**

```gdscript
func _test_spawn() -> void
```

## Description

Exercise SimWorld.spawn_scenario_units(): wiped-out filtered, factor forwarded

## Source

```gdscript
func _test_spawn() -> void:
	print("-- Spawn Test --")
	var sim: Node = Node.new()
	sim.name = "SimWorld"
	sim.set_script(load("res://scripts/sim/SimWorld.gd"))
	add_child(sim)
	await get_tree().process_frame
	var scenario: Node = _make_mock_scenario()
	sim.call("spawn_scenario_units", scenario)
	if sim.get_child_count() == 0:
		print("Spawn result: no children (likely only wiped-out units or spawn blocked)")
	else:
		for c in sim.get_children():
			var f: float = 0.0
			var raw_sf: Variant = null
			if c.has_method("get"):
				raw_sf = c.get("strength_factor")
			if typeof(raw_sf) == TYPE_FLOAT:
				f = raw_sf as float
			elif typeof(raw_sf) == TYPE_INT:
				f = float(raw_sf)
			var cnt: int = 0
			var raw_cnt: Variant = null
			if c.has_method("get"):
				raw_cnt = c.get("count")
			if typeof(raw_cnt) == TYPE_INT:
				cnt = raw_cnt as int
			elif typeof(raw_cnt) == TYPE_FLOAT:
				cnt = int(raw_cnt)
			prints("[spawned]", c.name, "factor=", f, "count=", cnt)
```
