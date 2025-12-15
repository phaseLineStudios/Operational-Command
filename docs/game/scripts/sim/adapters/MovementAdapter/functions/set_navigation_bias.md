# MovementAdapter::set_navigation_bias Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 583–588)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func set_navigation_bias(_su: ScenarioUnit, _bias: StringName) -> void
```

## Description

Set navigation bias (roads/cover/shortest) (placeholder).

## Source

```gdscript
func set_navigation_bias(_su: ScenarioUnit, _bias: StringName) -> void:
	if _su == null:
		return
	_su.set_meta("env_navigation_bias", _bias)
```
