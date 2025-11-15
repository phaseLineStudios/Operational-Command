# CombatAdapter::_ready Function Reference

*Defined at:* `scripts/sim/adapters/CombatAdapter.gd` (lines 28–33)</br>
*Belongs to:* [CombatAdapter](../../CombatAdapter.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Resolve the AmmoSystem reference when the node enters the tree.

## Source

```gdscript
func _ready() -> void:
	if ammo_system_path != NodePath(""):
		_ammo = get_node(ammo_system_path) as AmmoSystem
	add_to_group("CombatAdapter")
```
