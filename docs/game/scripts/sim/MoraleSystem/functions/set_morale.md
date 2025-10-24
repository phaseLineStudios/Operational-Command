# MoraleSystem::set_morale Function Reference

*Defined at:* `scripts/sim/MoraleSystem.gd` (lines 32–44)</br>
*Belongs to:* [MoraleSystem](../../MoraleSystem.md)

**Signature**

```gdscript
func set_morale(value: float, source: String = "direct") -> void
```

## Description

changes moralevalue to a new value

## Source

```gdscript
func set_morale(value: float, source: String = "direct") -> void:
	var prev_val := morale
	var prev_state := morale_state

	morale = clamp(value, 0.0, 1.0)
	morale_state = get_morale_state(morale)

	if prev_val != morale:
		emit_signal("morale_changed", unit_id, prev_val, morale, source)
	if prev_state != morale_state:
		emit_signal("morale_state_changed", unit_id, prev_state, morale_state)
```
