# Debrief::set_casualties Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 181–195)</br>
*Belongs to:* [Debrief](../Debrief.md)

**Signature**

```gdscript
func set_casualties(c: Dictionary) -> void
```

## Description

Sets friendly and enemy casualty figures and updates the RichText labels.
Missing values default to 0.
Shape:
{
"friendly": {"kia": int, "wia": int, "vehicles": int},
"enemy":    {"kia": int, "wia": int, "vehicles": int}
}

## Source

```gdscript
func set_casualties(c: Dictionary) -> void:
	_casualties = c.duplicate(true)
	var f: Dictionary = _casualties.get("friendly", {})
	var e: Dictionary = _casualties.get("enemy", {})
	_cas_friend.text = (
		"[b]Friendly[/b]\nKIA: %d\nWIA: %d\nVehicles: %d"
		% [int(f.get("kia", 0)), int(f.get("wia", 0)), int(f.get("vehicles", 0))]
	)
	_cas_enemy.text = (
		"[b]Enemy[/b]\nKIA: %d\nWIA: %d\nVehicles: %d"
		% [int(e.get("kia", 0)), int(e.get("wia", 0)), int(e.get("vehicles", 0))]
	)
	_request_align()
```
