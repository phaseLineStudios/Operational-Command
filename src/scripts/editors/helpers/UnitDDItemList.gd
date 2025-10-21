# File: res://scripts/editors/UnitDDItemList.gd
class_name UnitDDItemList
extends ItemList
## Drag & drop enabled ItemList for moving UnitData between pool and selected.
## Expects the parent dialog to implement `_on_unit_dropped(from_kind:int, to_kind:int, unit_id:String)`.

## List kind.
enum Kind { POOL, SELECTED }

## This list’s role (POOL or SELECTED).
@export var kind: Kind = Kind.POOL
## Path to NewScenarioDialog so we can call back on drop.
@export var dialog_path: NodePath

var _dlg: Node

func _ready() -> void:
	if dialog_path != NodePath():
		_dlg = get_node_or_null(dialog_path)

## Return drag payload when user drags a selected row.
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

## Accept drops that are unit payloads.
func _can_drop_data(_pos: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.get("type", "") == "unit"

## Notify dialog to move the unit.
func _drop_data(_pos: Vector2, data: Variant) -> void:
	if not _can_drop_data(_pos, data):
		return
	if _dlg and _dlg.has_method("_on_unit_dropped"):
		_dlg._on_unit_dropped(int(data.get("from", int(kind))), int(kind), String(data.get("id")))
