extends RefCounted
class_name ScenarioSelectionService

func set_selection(ctx: ScenarioEditorContext, pick: Dictionary, from_tree := false) -> void:
	ctx.selected_pick = pick if pick != null else {}
	ctx.terrain_overlay.set_selected(ctx.selected_pick)
	_build_hint(ctx, pick)
	ctx.request_overlay_redraw()
	if not from_tree:
		_select_in_tree(ctx, pick)
	ctx.selection_changed.emit(pick)

func clear_selection(ctx: ScenarioEditorContext, from_tree := false) -> void:
	ctx.selected_pick = {}
	ctx.terrain_overlay.clear_selected()
	_queue_free_children(ctx.tool_hint)
	ctx.request_overlay_redraw()
	if not from_tree:
		ctx.scene_tree.deselect_all()

func _build_hint(ctx: ScenarioEditorContext, pick: Dictionary) -> void:
	_queue_free_children(ctx.tool_hint)
	var t := StringName(pick.get("type",""))
	if t in [&"unit",&"task"]:
		var l := Label.new(); l.text = "CTRL+DRAG - synchronize with trigger"; ctx.tool_hint.add_child(l)
	elif t == &"trigger":
		var l2 := Label.new(); l2.text = "CTRL+DRAG - synchronize with Unit/Task"; ctx.tool_hint.add_child(l2)

func _select_in_tree(ctx: ScenarioEditorContext, pick: Dictionary) -> void:
	if pick.is_empty(): ctx.scene_tree.deselect_all(); return
	var root := ctx.scene_tree.get_root()
	if root == null: return
	_select_recursive(ctx.scene_tree, root, pick)

func _select_recursive(tree: Tree, item: TreeItem, pick: Dictionary) -> bool:
	var meta: Variant = item.get_metadata(0)
	if typeof(meta) == TYPE_DICTIONARY and meta.get("type","") == pick.get("type","") and int(meta.get("index",-1)) == int(pick.get("index",-1)):
		tree.set_selected(item, 0); return true
	var child := item.get_first_child()
	while child:
		if _select_recursive(tree, child, pick): return true
		child = child.get_next()
	return false

func _queue_free_children(node: Control) -> void:
	for n in node.get_children():
		n.queue_free()
