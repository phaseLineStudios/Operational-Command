# Debrief::get_selected_recipient Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 299–303)</br>
*Belongs to:* [Debrief](../Debrief.md)

**Signature**

```gdscript
func get_selected_recipient() -> String
```

## Description

Returns the selected recipient name, or an empty string if none is selected.

## Source

```gdscript
func get_selected_recipient() -> String:
	var idx := _recipient_dd.get_selected()
	return "" if idx == -1 else _recipient_dd.get_item_text(idx)
```
