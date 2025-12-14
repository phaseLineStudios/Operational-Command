# LOSAdapter::set_hostile_contact Function Reference

*Defined at:* `scripts/sim/adapters/LOSAdapter.gd` (lines 184–189)</br>
*Belongs to:* [LOSAdapter](../../LOSAdapter.md)

**Signature**

```gdscript
func set_hostile_contact(v: bool) -> void
```

## Description

Allow external systems to toggle contact directly.

## Source

```gdscript
func set_hostile_contact(v: bool) -> void:
	_hostile_contact = v
	if v:
		_last_contact_s = Time.get_ticks_msec() / 1000.0
```
