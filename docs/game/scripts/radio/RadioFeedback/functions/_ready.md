# RadioFeedback::_ready Function Reference

*Defined at:* `scripts/radio/RadioFeedback.gd` (lines 18–25)</br>
*Belongs to:* [RadioFeedback](../RadioFeedback.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Ready-time setup:
- Connect to `OrdersParser.parse_error`
- Try to locate an AmmoSystem (by group "AmmoSystem") and bind to its signals.

## Source

```gdscript
func _ready() -> void:
	OrdersParser.parse_error.connect(_on_parse_error)

	var ammo := get_tree().get_first_node_in_group("AmmoSystem") as AmmoSystem
	if ammo:
		bind_ammo(ammo)
```
