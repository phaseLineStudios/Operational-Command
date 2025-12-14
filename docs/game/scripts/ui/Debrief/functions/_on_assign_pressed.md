# Debrief::_on_assign_pressed Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 364–370)</br>
*Belongs to:* [Debrief](../../Debrief.md)

**Signature**

```gdscript
func _on_assign_pressed() -> void
```

## Description

Emits "commendation_assigned" only when both selection fields are non-empty.

## Source

```gdscript
func _on_assign_pressed() -> void:
	var award := get_selected_commendation()
	var recip := get_selected_recipient()
	if award != "" and recip != "":
		emit_signal("commendation_assigned", award, recip)
```
