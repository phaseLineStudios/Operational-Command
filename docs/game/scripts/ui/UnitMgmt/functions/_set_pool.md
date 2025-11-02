# UnitMgmt::_set_pool Function Reference

*Defined at:* `scripts/ui/UnitMgmt.gd` (lines 93–99)</br>
*Belongs to:* [UnitMgmt](../../UnitMgmt.md)

**Signature**

```gdscript
func _set_pool(v: int) -> void
```

## Description

Write the replacement pool to Game (placeholder persistence).

## Source

```gdscript
func _set_pool(v: int) -> void:
	if Game and Game.has_method("set_replacement_pool"):
		Game.call("set_replacement_pool", v)
	elif Game and Game.has_variable("campaign_replacement_pool"):
		Game.campaign_replacement_pool = v
```
