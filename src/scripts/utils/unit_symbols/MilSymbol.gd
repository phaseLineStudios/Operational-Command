## Main military symbol generator
## Creates symbol textures using viewport rendering
class_name MilSymbol
extends RefCounted

## Unit affiliation.
enum UnitAffiliation { FRIEND, ENEMY, NEUTRAL, UNKNOWN }
## Unit Type (Main Icon)
enum UnitType {
	INFANTRY,
	MECHANIZED,
	MOTORIZED,
	ARMOR,
	ANTI_TANK,
	ANTI_AIR,
	ARTILLERY,
	MORTAR,
	RECON,
	ENGINEER,
	MEDICAL,
	SUPPLY,
	HQ,
	NONE
}
## Unit Size/Echelon.
enum UnitSize {
	TEAM,
	SQUAD,
	SECTION,
	PLATOON,
	COMPANY,
	BATTALION,
	REGIMENT,
	BRIGADE,
	DIVISION,
	CORPS,
	ARMY,
	NONE
}
## Unit Modifier (top)
enum Modifier1 { NONE, HQ, BRIDGE, EOD }
## Unit Modifier (bottom)
enum Modifier2 { NONE, SUPPLY, AIR_DEFENCE, DEMOLITION, AIRBORNE, AMPHIBIOUS, RIVERINE, TRACKED }
## Unit Status
enum UnitStatus { PRESENT, PLANNED }
## Unit Reinforced or Reduced
enum UnitReinforcedReduced { NONE, REINFORCED, REDUCED, REINFORCED_AND_REDUCED }

## Configuration
var config: MilSymbolConfig

## Cached viewport and renderer (reused for efficiency)
var _viewport: SubViewport
var _renderer: MilSymbolRenderer


func _init(p_config: MilSymbolConfig = null) -> void:
	if p_config != null:
		config = p_config
	else:
		config = MilSymbolConfig.create_default()


## Generate a symbol texture using enums (primary API)
## Returns an ImageTexture of the rendered symbol
func generate(
	affiliation: UnitAffiliation,
	unit_type: UnitType,
	unit_size: UnitSize = UnitSize.PLATOON,
	callsign: String = ""
) -> ImageTexture:
	var size_text := _unit_size_to_text(unit_size)

	return await generate_texture(
		affiliation, MilSymbolGeometry.Domain.GROUND, unit_type, size_text, callsign
	)


## Generate a symbol texture (internal - uses internal enum types)
## Returns an ImageTexture of the rendered symbol
func generate_texture(
	affiliation: UnitAffiliation,
	domain: MilSymbolGeometry.Domain = MilSymbolGeometry.Domain.GROUND,
	icon_type: UnitType = UnitType.NONE,
	unit_size: String = "",
	designation: String = ""
) -> ImageTexture:
	var viewport_created := _viewport == null
	_ensure_viewport()

	# If we just created the viewport, wait for deferred add_child to complete
	var tree := Engine.get_main_loop() as SceneTree
	if viewport_created:
		if tree:
			await tree.process_frame  # Wait for deferred add_child

	# Setup the renderer
	_renderer.config = config
	_renderer.affiliation = affiliation
	_renderer.domain = domain
	_renderer.icon_type = icon_type
	_renderer.unit_size_text = unit_size
	_renderer.unique_designation = designation
	_renderer.queue_redraw()
	if _viewport:
		_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE

	# Wait for rendering using the main SceneTree
	tree = Engine.get_main_loop() as SceneTree
	if tree:
		await tree.process_frame
		await tree.process_frame  # Extra frame to ensure render is complete

	# Capture the texture
	if _viewport == null:
		LogService.warning("Viewport is null", "MilSymbol.gd:104")
		return
	var img := _viewport.get_texture().get_image()

	# If rendered at higher resolution, scale down with anti-aliasing
	if config.resolution_scale > 1.0:
		var target_size := config.get_pixel_size()
		img.resize(target_size, target_size, Image.INTERPOLATE_LANCZOS)

	return ImageTexture.create_from_image(img)


## Generate a symbol texture from a simplified code
## Code format: "AFFILIATION-DOMAIN-TYPE" (e.g., "F-G-INF" for Friend Ground Infantry)
func generate_from_code(
	code: String, unit_size: String = "", designation: String = ""
) -> ImageTexture:
	var parts := code.split("-")

	var affiliation := _parse_affiliation(parts[0] if parts.size() > 0 else "F")
	var domain := _parse_domain(parts[1] if parts.size() > 1 else "G")
	var icon_type := _parse_icon_type(parts[2] if parts.size() > 2 else "")

	return await generate_texture(affiliation, domain, icon_type, unit_size, designation)


## Generate a symbol texture from unit data (same as generate() - kept for compatibility)
## More convenient for game integration
func generate_from_unit(
	unit_affiliation: UnitAffiliation,
	unit_type: UnitType,
	unit_size: UnitSize = UnitSize.COMPANY,
	designation: String = ""
) -> ImageTexture:
	return await generate(unit_affiliation, unit_type, unit_size, designation)


## Synchronously generate a symbol texture (blocking)
## Use this carefully as it requires a SceneTree context
func generate_texture_sync(
	affiliation: UnitAffiliation,
	domain: MilSymbolGeometry.Domain = MilSymbolGeometry.Domain.GROUND,
	icon_type: UnitType = UnitType.NONE,
	unit_size: String = "",
	designation: String = ""
) -> ImageTexture:
	var viewport_created := _viewport == null
	_ensure_viewport()

	# If we just created the viewport, wait for deferred add_child to complete
	var tree := Engine.get_main_loop() as SceneTree
	if viewport_created and tree:
		await tree.process_frame

	# Setup the renderer
	_renderer.config = config
	_renderer.affiliation = affiliation
	_renderer.domain = domain
	_renderer.icon_type = icon_type
	_renderer.unit_size_text = unit_size
	_renderer.unique_designation = designation
	_renderer.queue_redraw()
	if _viewport:
		_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE

	# Force immediate render
	RenderingServer.force_draw(false)
	if tree:
		await tree.process_frame

	# Capture the texture
	var img := _viewport.get_texture().get_image()

	# If rendered at higher resolution, scale down with anti-aliasing
	if config.resolution_scale > 1.0:
		var target_size := config.get_pixel_size()
		img.resize(target_size, target_size, Image.INTERPOLATE_LANCZOS)

	return ImageTexture.create_from_image(img)


## Clean up resources
func cleanup() -> void:
	if _viewport != null:
		_viewport.queue_free()
		_viewport = null
		_renderer = null


## Ensure viewport and renderer exist
func _ensure_viewport() -> void:
	if _viewport != null:
		return

	# Create viewport at higher resolution for anti-aliasing
	var target_size := config.get_pixel_size()
	var render_size := int(target_size * config.resolution_scale)

	_viewport = SubViewport.new()
	_viewport.size = Vector2i(render_size, render_size)
	_viewport.transparent_bg = true
	_viewport.render_target_update_mode = SubViewport.UPDATE_DISABLED

	# Create renderer
	_renderer = MilSymbolRenderer.new()
	_renderer.config = config
	_viewport.add_child(_renderer)

	# Add to scene tree (required for rendering)
	# Use call_deferred to avoid "busy setting up children" errors
	var tree := Engine.get_main_loop() as SceneTree
	if tree and tree.root:
		tree.root.call_deferred("add_child", _viewport)
	else:
		push_error("MilSymbol: Cannot generate symbols without an active SceneTree")


## Parse affiliation from string
func _parse_affiliation(code: String) -> UnitAffiliation:
	match code.to_upper():
		"F", "FRIEND", "FRIENDLY", "BLUE":
			return UnitAffiliation.FRIEND
		"H", "HOSTILE", "ENEMY", "RED":
			return UnitAffiliation.ENEMY
		"N", "NEUTRAL", "GREEN":
			return UnitAffiliation.NEUTRAL
		"U", "UNKNOWN", "YELLOW":
			return UnitAffiliation.UNKNOWN
		_:
			return UnitAffiliation.FRIEND


## Parse icon type from string
func _parse_icon_type(code: String) -> UnitType:
	return MilSymbolIcons.parse_unit_type(code)


## Parse domain from string
func _parse_domain(code: String) -> MilSymbolGeometry.Domain:
	match code.to_upper():
		"G", "GROUND", "LAND":
			return MilSymbolGeometry.Domain.GROUND
		"A", "AIR":
			return MilSymbolGeometry.Domain.AIR
		"S", "SEA", "SURFACE":
			return MilSymbolGeometry.Domain.SEA
		"SP", "SPACE":
			return MilSymbolGeometry.Domain.SPACE
		"SS", "SUB", "SUBSURFACE":
			return MilSymbolGeometry.Domain.SUBSURFACE
		_:
			return MilSymbolGeometry.Domain.GROUND


## Convert UnitSize enum to NATO size indicator text
func _unit_size_to_text(unit_size: UnitSize) -> String:
	match unit_size:
		UnitSize.NONE:
			return ""
		UnitSize.TEAM:
			return "ø"
		UnitSize.SQUAD:
			return "•"
		UnitSize.SECTION:
			return "••"
		UnitSize.PLATOON:
			return "•••"
		UnitSize.COMPANY:
			return "I"
		UnitSize.BATTALION:
			return "II"
		UnitSize.REGIMENT:
			return "III"
		UnitSize.BRIGADE:
			return "X"
		UnitSize.DIVISION:
			return "XX"
		UnitSize.CORPS:
			return "XXX"
		UnitSize.ARMY:
			return "XXXX"
		_:
			return ""


## Static convenience method: create and generate in one call
static func create_symbol(
	affiliation: UnitAffiliation,
	unit_type: UnitType,
	size: MilSymbolConfig.Size = MilSymbolConfig.Size.MEDIUM,
	unit_size: UnitSize = UnitSize.COMPANY,
	designation: String = ""
) -> ImageTexture:
	var cfg := MilSymbolConfig.create_default()
	cfg.size = size

	var generator := MilSymbol.new(cfg)
	var texture := await generator.generate(affiliation, unit_type, unit_size, designation)

	generator.cleanup()
	return texture


## Static convenience method for creating frame-only symbols (no fill)
## One-liner for quick frame-only symbol generation
static func create_frame_symbol(
	affiliation: UnitAffiliation,
	unit_type: UnitType,
	size: MilSymbolConfig.Size = MilSymbolConfig.Size.MEDIUM,
	unit_size: UnitSize = UnitSize.PLATOON,
	designation: String = ""
) -> ImageTexture:
	var cfg := MilSymbolConfig.create_frame_only()
	cfg.size = size

	var generator := MilSymbol.new(cfg)
	var texture := await generator.generate(affiliation, unit_type, unit_size, designation)

	generator.cleanup()
	return texture
