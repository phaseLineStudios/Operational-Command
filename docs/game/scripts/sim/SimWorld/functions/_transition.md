# SimWorld::_transition Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 308–313)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _transition(prev: State, next: State) -> void
```

## Description

Apply a state transition and emit `signal mission_state_changed`.
[param prev] Previous state.
[param next] Next state.

## Source

```gdscript
func _transition(prev: State, next: State) -> void:
	_state = next
	emit_signal("mission_state_changed", prev, next)
	LogService.info("mission_state_changed: %s" % {"prev": prev, "next": next}, "SimWorld.gd:285")
```

## References

- [`signal mission_state_changed`](../../SimWorld.md#mission_state_changed)
