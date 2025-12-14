# LOSAdapter::has_hostile_contact Function Reference

*Defined at:* `scripts/sim/adapters/LOSAdapter.gd` (lines 174–182)</br>
*Belongs to:* [LOSAdapter](../../LOSAdapter.md)

**Signature**

```gdscript
func has_hostile_contact() -> bool
```

## Description

Used by AIAgent wait-until-contact

## Source

```gdscript
func has_hostile_contact() -> bool:
	if _hostile_contact:
		return true
	if _last_contact_s < 0.0:
		return false
	var curr_time := Time.get_ticks_msec() / 1000.0
	return curr_time - _last_contact_s <= contact_memory_sec
```
