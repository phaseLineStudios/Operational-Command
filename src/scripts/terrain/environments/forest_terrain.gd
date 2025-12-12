class_name forest_terrain
extends Node

@export var scene_env: SceneEnvironment
@export var terrain: Node3D

var _scenario: ScenarioData
var terrain_mesh: MeshInstance3D


func _ready() -> void:
	terrain_mesh = terrain.get_node_or_null("Terrain")
	if not terrain_mesh:
		LogService.warning("Didn't find Terrain Mesh.", "forest_terrain.gd:14")
		return
	scene_env.scenario_changed.connect(scenario_changed)
	scenario_changed(
		scene_env.get_scenario() if scene_env.get_scenario() else Game.current_scenario
	)


func scenario_changed(new_scenario: ScenarioData) -> void:
	if not new_scenario:
		LogService.warning("Null scenario.", "forest_terrain.gd:24")
		return
	print(new_scenario)
	_scenario = new_scenario
	check_rain()


func check_rain() -> void:
	if not terrain_mesh or not _scenario:
		LogService.warning("No Terrain Mesh or missing scenario.", "forest_terrain.gd:27")
		return

	var mat = terrain_mesh.get_surface_override_material(0)
	if not mat:
		LogService.warning("No material found on terrain mesh.", "forest_terrain.gd:34")
		return

	if not mat is ShaderMaterial:
		LogService.warning(
			"Material is not a ShaderMaterial: %s" % mat.get_class(),
			"forest_terrain.gd:40"
		)
		return

	var shader_mat := mat as ShaderMaterial

	if _scenario.rain > 0.0:
		# Lower roughness makes terrain look wet/shiny
		shader_mat.set_shader_parameter("roughness_scale", 0.0)
		print("Set terrain roughness to 0.0 (wet)")
	else:
		# Reset to normal roughness
		shader_mat.set_shader_parameter("roughness_scale", 1.0)
		print("Set terrain roughness to 1.0 (dry)")
