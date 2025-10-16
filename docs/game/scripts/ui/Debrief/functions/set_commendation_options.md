# Debrief::set_commendation_options Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 290–295)</br>
*Belongs to:* [Debrief](../../Debrief.md)

**Signature**

```gdscript
func set_commendation_options(options: Array) -> void
```

## Description

Sets the available commendation names in the Award dropdown.

## Source

```gdscript
func set_commendation_options(options: Array) -> void:
	_award_dd.clear()
	for o in options:
		_award_dd.add_item(str(o))
```
