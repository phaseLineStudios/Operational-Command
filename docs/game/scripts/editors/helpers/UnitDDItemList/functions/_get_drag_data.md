# UnitDDItemList::_get_drag_data Function Reference

*Defined at:* `scripts/editors/helpers/UnitDDItemList.gd` (lines 24–39)</br>
*Belongs to:* [UnitDDItemList](../../UnitDDItemList.md)

**Signature**

```gdscript
func _get_drag_data(_at_position: Vector2) -> Variant
```

## Description

Return drag payload when user drags a selected row.

## Source

```gdscript
func _get_drag_data(_at_position: Vector2) -> Variant:
	var sel := get_selected_items()
	if sel.is_empty():
		return null
	var i := sel[0]
	var md: Variant = get_item_metadata(i)
	if typeof(md) != TYPE_DICTIONARY or not md.has("id"):
		return null

	var preview := Label.new()
	preview.text = get_item_text(i)
	set_drag_preview(preview)

	return {"type": "unit", "id": String(md["id"]), "from": int(kind)}
```
