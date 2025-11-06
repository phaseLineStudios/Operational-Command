# CounterConfigDialog::_on_create_pressed Function Reference

*Defined at:* `scripts/ui/CounterConfigDialog.gd` (lines 57–70)</br>
*Belongs to:* [CounterConfigDialog](../../CounterConfigDialog.md)

**Signature**

```gdscript
func _on_create_pressed() -> void
```

## Source

```gdscript
func _on_create_pressed() -> void:
	var selected_affiliation := affiliation.selected as MilSymbol.UnitAffiliation
	var selected_type := type.selected as MilSymbol.UnitType
	var selected_size := unit_size.selected as MilSymbol.UnitSize
	var selected_callsign := callsign.text.strip_edges().to_upper()

	if selected_callsign.is_empty():
		selected_callsign = "UNIT"

	counter_create_requested.emit(
		selected_affiliation, selected_type, selected_size, selected_callsign
	)

	hide()
```
