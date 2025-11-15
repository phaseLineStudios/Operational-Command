# LOSAdapter::_on_contact Function Reference

*Defined at:* `scripts/sim/adapters/LOSAdapter.gd` (lines 137–141)</br>
*Belongs to:* [LOSAdapter](../../LOSAdapter.md)

**Signature**

```gdscript
func _on_contact(attacker: String, defender: String) -> void
```

## Description

used by AIAgent to determine what to do on contact in LOSAdapter

## Source

```gdscript
func _on_contact(attacker: String, defender: String) -> void:
	if attacker == unit_id or defender == unit_id:
		_last_contact_s = Time.get_ticks_msec() / 1000.0
```
