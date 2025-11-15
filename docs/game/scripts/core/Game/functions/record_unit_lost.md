# Game::record_unit_lost Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 113–116)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func record_unit_lost(count: int = 1) -> void
```

## Description

record lost units

## Source

```gdscript
func record_unit_lost(count: int = 1) -> void:
	resolution.add_units_lost(count)
```
