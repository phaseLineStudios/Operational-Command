# UnitMgmt::_get_pool Function Reference

*Defined at:* `scripts/ui/UnitMgmt.gd` (lines 84–91)</br>
*Belongs to:* [UnitMgmt](../../UnitMgmt.md)

**Signature**

```gdscript
func _get_pool() -> int
```

## Description

Read the replacement pool from Game (placeholder persistence).

## Source

```gdscript
func _get_pool() -> int:
	if Game and Game.has_method("get_replacement_pool"):
		return int(Game.call("get_replacement_pool"))
	if Game and Game.has_variable("campaign_replacement_pool"):
		return int(Game.campaign_replacement_pool)
	return 0
```
