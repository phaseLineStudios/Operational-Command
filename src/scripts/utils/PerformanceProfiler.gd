extends Node
## Quick performance profiler to identify bottlenecks
## Add to hq_table scene temporarily and press F12 to print stats


func _ready() -> void:
	print("=== Performance Profiler Active ===")
	print("Press F12 to dump performance stats")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_filedialog_refresh"):  # F12
		_print_stats()


func _print_stats() -> void:
	var perf := Performance

	print("\n========== PERFORMANCE STATS ==========")
	print("FPS: ", Engine.get_frames_per_second())
	print("Frame Time: %.2f ms" % (perf.get_monitor(Performance.TIME_PROCESS) * 1000.0))
	print("\n--- Memory ---")
	print(
		(
			"Video Memory: %.1f MB"
			% (perf.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 1024.0 / 1024.0)
		)
	)
	print(
		(
			"Texture Memory: %.1f MB"
			% (perf.get_monitor(Performance.RENDER_TEXTURE_MEM_USED) / 1024.0 / 1024.0)
		)
	)
	print("\n--- Rendering ---")
	print("Draw Calls: ", perf.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
	print("Objects Drawn: ", perf.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME))
	print("Primitives: ", perf.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME))
	print("\n--- Physics ---")
	print("3D Bodies: ", perf.get_monitor(Performance.PHYSICS_3D_ACTIVE_OBJECTS))
	print("3D Islands: ", perf.get_monitor(Performance.PHYSICS_3D_ISLAND_COUNT))
	print("=======================================\n")

	# Get scene tree stats
	var root := get_tree().root
	var node_count := _count_nodes(root)
	var mesh_count := _count_meshes(root)
	print("Total Nodes: ", node_count)
	print("MeshInstance3D nodes: ", mesh_count)
	print("=======================================\n")


func _count_nodes(node: Node) -> int:
	var count := 1
	for child in node.get_children():
		count += _count_nodes(child)
	return count


func _count_meshes(node: Node) -> int:
	var count := 0
	if node is MeshInstance3D:
		count = 1
		var mesh := (node as MeshInstance3D).mesh
		if mesh:
			print("  Mesh: %s - %d surfaces" % [node.name, mesh.get_surface_count()])
	for child in node.get_children():
		count += _count_meshes(child)
	return count
