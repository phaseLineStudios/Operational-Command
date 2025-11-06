# MissionDialog::_draw_line Function Reference

*Defined at:* `scripts/ui/MissionDialog.gd` (lines 114–174)</br>
*Belongs to:* [MissionDialog](../../MissionDialog.md)

**Signature**

```gdscript
func _draw_line() -> void
```

## Description

Draw the line from dialog to map position or target node

## Source

```gdscript
func _draw_line() -> void:
	if not visible:
		return

	var target_screen_pos: Variant = null

	# Priority 1: Target node (for tutorials)
	if _target_node != null:
		var node: Node = null
		if _target_node is String:
			# Try to find node by unique name first (%NodeName)
			if _target_node.begins_with("%"):
				node = get_node_or_null(_target_node)
			# Then try as a regular path
			if node == null:
				node = get_node_or_null(_target_node)
			# Finally try searching from root
			if node == null and get_tree():
				node = get_tree().root.find_child(_target_node.trim_prefix("%"), true, false)
		elif _target_node is NodePath:
			node = get_node_or_null(_target_node)
		elif _target_node is Node:
			node = _target_node

		if node and node is Control:
			# For Control nodes, use global rect center
			target_screen_pos = (node as Control).get_global_rect().get_center()
		elif node and node is Node2D:
			# For Node2D, use global position
			target_screen_pos = (node as Node2D).global_position
		elif node and node is Node3D:
			# For Node3D, try to get viewport position (may not always work)
			var cam := get_viewport().get_camera_3d()
			if cam:
				target_screen_pos = cam.unproject_position((node as Node3D).global_position)

	# Priority 2: Map position
	if target_screen_pos == null and _position_m != null and _map_controller != null:
		target_screen_pos = _map_controller.terrain_to_screen(_position_m)

	# If we don't have a valid target, bail out
	if target_screen_pos == null:
		return

	# Get dialog center position (use the panel container's global rect)
	var panel := $CenterContainer/DialogPanel as Control
	if panel == null:
		return

	var dialog_rect := panel.get_global_rect()

	# Calculate closest point on dialog edge to the target position
	var start_pos := _get_closest_edge_point(dialog_rect, target_screen_pos)

	# Draw line from dialog edge to target position
	_line_overlay.draw_line(start_pos, target_screen_pos, pos_line_color, 2.0)

	# Draw a small circle at the target position
	_line_overlay.draw_circle(target_screen_pos, 5.0, pos_color)
```
