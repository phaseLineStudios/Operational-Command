# ReinforcementTest::_make_unit_prefab Function Reference

*Defined at:* `scripts/test/ReinforcementTest.gd` (lines 169–172)</br>
*Belongs to:* [ReinforcementTest](../../ReinforcementTest.md)

**Signature**

```gdscript
func _make_unit_prefab() -> PackedScene
```

## Description

Make a tiny runtime PackedScene whose instance accepts a strength factor

## Source

```gdscript
func _make_unit_prefab() -> PackedScene:
	var holder: Node = Node.new()
	var gs: GDScript = GDScript.new()
	gs.source_code = """
```
