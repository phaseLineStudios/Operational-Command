# NARules::clear_mission_overrides Function Reference

*Defined at:* `scripts/radio/NARules.gd` (lines 30–33)</br>
*Belongs to:* [NARules](../../NARules.md)

**Signature**

```gdscript
func clear_mission_overrides() -> void
```

## Description

Clear mission overrides (call when leaving a mission).
Should be called on mission end to reset grammar to defaults.

## Source

```gdscript
func clear_mission_overrides() -> void:
	_mission_overrides.clear()
```
