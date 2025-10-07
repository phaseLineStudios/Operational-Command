# Radio::_exit_tree Function Reference

*Defined at:* `scripts/radio/Radio.gd` (lines 67–69)</br>
*Belongs to:* [Radio](../../Radio.md)

**Signature**

```gdscript
func _exit_tree() -> void
```

## Description

Ensure we stop capture when the radio node leaves.

## Source

```gdscript
func _exit_tree() -> void:
	if _tx:
		_stop_tx()
```
