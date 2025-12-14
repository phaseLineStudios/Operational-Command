# Debrief::get_selected_commendation Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 349–353)</br>
*Belongs to:* [Debrief](../../Debrief.md)

**Signature**

```gdscript
func get_selected_commendation() -> String
```

## Description

Returns the currently selected award, or an empty string if none is selected.

## Source

```gdscript
func get_selected_commendation() -> String:
	var idx := _award_dd.get_selected()
	return "" if idx == -1 else _award_dd.get_item_text(idx)
```
