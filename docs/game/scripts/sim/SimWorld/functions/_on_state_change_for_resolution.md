# SimWorld::_on_state_change_for_resolution Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 347–351)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _on_state_change_for_resolution(_prev: State, next: State) -> void
```

- **prev**: Previous state.
- **next**: Next state.

## Description

State change callback: finalize mission resolution.

## Source

```gdscript
func _on_state_change_for_resolution(_prev: State, next: State) -> void:
	if next == State.COMPLETED:
		Game.resolution.finalize(false)
```
