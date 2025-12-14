# SimWorld::get_current_contacts Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 386–389)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func get_current_contacts() -> Array
```

## Description

Pairs in contact this tick: Array of { attacker: String, defender: String }.

## Source

```gdscript
func get_current_contacts() -> Array:
	return _contact_pairs.duplicate()
```
