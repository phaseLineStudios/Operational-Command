# SimWorld::_transition Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 443–448)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _transition(prev: State, next: State) -> void
```

- **prev**: Previous state.
- **next**: Next state.

## Description

Apply a state transition and emit `signal mission_state_changed`.

## Source

```gdscript
func _transition(prev: State, next: State) -> void:
	_state = next
	emit_signal("mission_state_changed", prev, next)
	LogService.info("mission_state_changed: %s" % {"prev": prev, "next": next}, "SimWorld.gd:285")
```

## References

- [`signal mission_state_changed`](..\..\SimWorld.md#mission_state_changed)
