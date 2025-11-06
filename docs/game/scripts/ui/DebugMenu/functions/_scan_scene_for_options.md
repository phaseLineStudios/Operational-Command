# DebugMenu::_scan_scene_for_options Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 199–257)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _scan_scene_for_options() -> void
```

## Description

Async scan all nodes in the scene tree for debug options

## Source

```gdscript
func _scan_scene_for_options() -> void:
	_scene_options_discovered.clear()

	var root := get_tree().root
	var nodes_to_scan: Array[Node] = []
	_collect_nodes_recursive(root, nodes_to_scan)

	var total_nodes := nodes_to_scan.size()
	var scanned_count := 0
	var batch_size := 50  # Process 50 nodes per frame to avoid lag

	# Process nodes in batches
	while scanned_count < total_nodes:
		var batch_end := mini(scanned_count + batch_size, total_nodes)

		for i in range(scanned_count, batch_end):
			var node := nodes_to_scan[i]
			if node == null or not is_instance_valid(node):
				continue

			# Skip nodes we don't want to scan
			if _should_skip_node(node):
				continue

			var all_options: Array = []

			# Method 1: Auto-detect @export variables with "debug" in name or category
			var export_options := _extract_debug_exports(node)
			all_options.append_array(export_options)

			# Method 2: Check if node has get_debug_options method
			if node.has_method("get_debug_options"):
				var manual_options = node.get_debug_options()
				if manual_options is Array:
					all_options.append_array(manual_options)

			# Only add if we actually found options
			if all_options.size() > 0:
				_scene_options_discovered.append({"node": node, "options": all_options})

		scanned_count = batch_end

		# Update status
		var progress := float(scanned_count) / float(total_nodes) * 100.0
		scene_options_status.text = "Scanning: %d%%" % int(progress)

		# Yield to next frame
		await get_tree().process_frame

	# Build UI with discovered options
	_build_scene_options_ui()

	scene_options_status.text = (
		"Found %d nodes with debug options" % _scene_options_discovered.size()
	)
	scene_options_refresh.disabled = false
	_is_scanning = false
```
