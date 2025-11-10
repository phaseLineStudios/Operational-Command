class_name DocumentController
extends Node
## Renders text content onto document clipboards in the HQ table scene.
##
## Manages three documents:
## - Intel Doc: Mission-specific intelligence items (placeholder)
## - Transcript Doc: Radio communication transcript
## - Briefing Doc: FRAGO SMEAC formatted mission briefing

## Document face scene (contains styled RichTextLabel)
const DOCUMENT_FACE_SCENE := preload("res://scenes/system/document_face.tscn")

## Document dimensions (fixed square viewport)
const DOC_WIDTH := 1024
const DOC_HEIGHT := 1024

## Paper texture resolution scale for anti-aliasing
const RESOLUTION_SCALE := 2.0

## Material surface index for the paper on clipboard mesh
const PAPER_MATERIAL_INDEX := 3

## Maximum transcript entries before pruning oldest
const MAX_TRANSCRIPT_ENTRIES := 50

## References to the clipboard RigidBody3D nodes
var intel_clipboard: RigidBody3D
var transcript_clipboard: RigidBody3D
var briefing_clipboard: RigidBody3D

## Viewports for rendering each document
var _intel_viewport: SubViewport
var _transcript_viewport: SubViewport
var _briefing_viewport: SubViewport

## Document face instances
var _intel_face: Control
var _transcript_face: Control
var _briefing_face: Control

## Content containers (RichTextLabel)
var _intel_content: RichTextLabel
var _transcript_content: RichTextLabel
var _briefing_content: RichTextLabel

## Full document content storage
var _intel_full_content := ""
var _transcript_full_content := ""
var _briefing_full_content := ""

## Page tracking
var _intel_pages: Array[String] = []
var _transcript_pages: Array[String] = []
var _briefing_pages: Array[String] = []

## Transcript storage
var _transcript_entries: Array[Dictionary] = []

## Current scenario reference
var _scenario: ScenarioData

## Mission resolution for objective tracking
var _resolution: MissionResolution

## Material references for texture updates
var _intel_material: StandardMaterial3D
var _transcript_material: StandardMaterial3D
var _briefing_material: StandardMaterial3D

## Debounce timers for texture refresh
var _intel_refresh_timer: Timer
var _transcript_refresh_timer: Timer
var _briefing_refresh_timer: Timer

## Refresh delay in seconds (wait for user to stop navigating)
const REFRESH_DELAY := 0.15


## Initialize the document controller with references to the clipboard nodes.
## [param intel] IntelDoc RigidBody3D reference
## [param transcript] TranscriptDoc RigidBody3D reference
## [param briefing] BriefingDoc RigidBody3D reference
func init(
	intel: RigidBody3D, transcript: RigidBody3D, briefing: RigidBody3D, scenario: ScenarioData
) -> void:
	intel_clipboard = intel
	transcript_clipboard = transcript
	briefing_clipboard = briefing
	_scenario = scenario
	_resolution = Game.resolution

	_setup_viewports()
	_setup_content_labels()
	_setup_refresh_timers()
	await get_tree().process_frame

	await _render_intel_doc()
	await _render_briefing_doc()
	await _render_transcript_doc()

	await _apply_textures()

	_setup_document_input()

	if _resolution:
		_resolution.objective_updated.connect(_on_objective_updated)


## Setup SubViewports for each document
func _setup_viewports() -> void:
	var render_size := Vector2i(DOC_WIDTH * RESOLUTION_SCALE, DOC_HEIGHT * RESOLUTION_SCALE)

	# Intel viewport
	_intel_viewport = SubViewport.new()
	_intel_viewport.size = render_size
	_intel_viewport.transparent_bg = false
	_intel_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_intel_viewport.gui_disable_input = false
	add_child(_intel_viewport)

	# Transcript viewport
	_transcript_viewport = SubViewport.new()
	_transcript_viewport.size = render_size
	_transcript_viewport.transparent_bg = false
	_transcript_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_transcript_viewport.gui_disable_input = false
	add_child(_transcript_viewport)

	# Briefing viewport
	_briefing_viewport = SubViewport.new()
	_briefing_viewport.size = render_size
	_briefing_viewport.transparent_bg = false
	_briefing_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_briefing_viewport.gui_disable_input = false
	add_child(_briefing_viewport)


## Setup debounce timers for texture refresh
func _setup_refresh_timers() -> void:
	# Intel timer
	_intel_refresh_timer = Timer.new()
	_intel_refresh_timer.wait_time = REFRESH_DELAY
	_intel_refresh_timer.one_shot = true
	_intel_refresh_timer.timeout.connect(_do_intel_refresh)
	add_child(_intel_refresh_timer)

	# Transcript timer
	_transcript_refresh_timer = Timer.new()
	_transcript_refresh_timer.wait_time = REFRESH_DELAY
	_transcript_refresh_timer.one_shot = true
	_transcript_refresh_timer.timeout.connect(_do_transcript_refresh)
	add_child(_transcript_refresh_timer)

	# Briefing timer
	_briefing_refresh_timer = Timer.new()
	_briefing_refresh_timer.wait_time = REFRESH_DELAY
	_briefing_refresh_timer.one_shot = true
	_briefing_refresh_timer.timeout.connect(_do_briefing_refresh)
	add_child(_briefing_refresh_timer)


## Setup input forwarding from 3D documents to viewports
func _setup_document_input() -> void:
	if intel_clipboard:
		intel_clipboard.document_viewport = _intel_viewport
		intel_clipboard.document_viewport_size = Vector2(
			DOC_WIDTH * RESOLUTION_SCALE, DOC_HEIGHT * RESOLUTION_SCALE
		)
		intel_clipboard.input_ray_pickable = true

	if transcript_clipboard:
		transcript_clipboard.document_viewport = _transcript_viewport
		transcript_clipboard.document_viewport_size = Vector2(
			DOC_WIDTH * RESOLUTION_SCALE, DOC_HEIGHT * RESOLUTION_SCALE
		)
		transcript_clipboard.input_ray_pickable = true

	if briefing_clipboard:
		briefing_clipboard.document_viewport = _briefing_viewport
		briefing_clipboard.document_viewport_size = Vector2(
			DOC_WIDTH * RESOLUTION_SCALE, DOC_HEIGHT * RESOLUTION_SCALE
		)
		briefing_clipboard.input_ray_pickable = true


## Setup document face scenes and get RichTextLabel content containers
func _setup_content_labels() -> void:
	# Intel document face
	_intel_face = DOCUMENT_FACE_SCENE.instantiate()
	_intel_viewport.add_child(_intel_face)
	_intel_content = _intel_face.get_node("%PaperContent")
	_intel_face.page_changed.connect(_on_intel_page_changed)

	# Transcript document face
	_transcript_face = DOCUMENT_FACE_SCENE.instantiate()
	_transcript_viewport.add_child(_transcript_face)
	_transcript_content = _transcript_face.get_node("%PaperContent")
	_transcript_face.page_changed.connect(_on_transcript_page_changed)

	# Briefing document face
	_briefing_face = DOCUMENT_FACE_SCENE.instantiate()
	_briefing_viewport.add_child(_briefing_face)
	_briefing_content = _briefing_face.get_node("%PaperContent")
	_briefing_face.page_changed.connect(_on_briefing_page_changed)


## Render intel document content (placeholder)
func _render_intel_doc() -> void:
	_intel_full_content = "[center][b]INTELLIGENCE SUMMARY[/b][/center]\n\n"
	_intel_full_content += "[i]No intelligence items available.[/i]\n\n"
	_intel_full_content += "This document will contain mission-specific intelligence briefings, "
	_intel_full_content += "enemy force estimates, terrain analysis, and other relevant information."

	_intel_pages = await _split_into_pages(_intel_content, _intel_full_content)
	# Initialize face state
	_intel_face.total_pages = _intel_pages.size()
	_intel_face.current_page = 0
	_intel_face.update_page_indicator()
	# Display first page content
	_display_page(_intel_face, _intel_content, _intel_pages, 0)


## Render briefing document in FRAGO SMEAC format
func _render_briefing_doc() -> void:
	if _scenario == null or _scenario.briefing == null:
		_briefing_full_content = "[center][b]NO BRIEFING AVAILABLE[/b][/center]"
		_briefing_pages = await _split_into_pages(_briefing_content, _briefing_full_content)
		# Initialize face state
		_briefing_face.total_pages = _briefing_pages.size()
		_briefing_face.current_page = 0
		_briefing_face.update_page_indicator()
		_display_page(_briefing_face, _briefing_content, _briefing_pages, 0)
		return

	var brief: BriefData = _scenario.briefing
	_briefing_pages.clear()

	# Page 1: Header + SITUATION
	var page1 := ""
	page1 += "[center][b]FRAGMENTARY ORDER (FRAGO)[/b][/center]\n"
	page1 += "[center]%s[/center]\n\n" % brief.title
	page1 += "[b]1. SITUATION[/b]\n\n"
	if brief.frag_enemy != null and brief.frag_enemy != "":
		page1 += "[b]a. Enemy Forces:[/b]\n%s\n\n" % brief.frag_enemy
	if brief.frag_friendly != null and brief.frag_friendly != "":
		page1 += "[b]b. Friendly Forces:[/b]\n%s\n\n" % brief.frag_friendly
	if brief.frag_terrain != null and brief.frag_terrain != "":
		page1 += "[b]c. Terrain:[/b]\n%s\n\n" % brief.frag_terrain
	if brief.frag_weather != null and brief.frag_weather != "":
		page1 += "[b]d. Weather:[/b]\n%s\n\n" % brief.frag_weather
	_briefing_pages.append(page1)

	# Page 2: MISSION
	var page2 := ""
	page2 += "[b]2. MISSION[/b]\n\n"
	if brief.frag_mission != null and brief.frag_mission != "":
		page2 += "%s\n\n" % brief.frag_mission
	if brief.frag_objectives != null and brief.frag_objectives.size() > 0:
		page2 += "[b]Objectives:[/b]\n"
		for obj in brief.frag_objectives:
			if obj is ScenarioObjectiveData:
				var status_icon := _get_objective_status_icon(obj.id)
				page2 += "%s %s\n" % [status_icon, obj.title]
		page2 += "\n"
	_briefing_pages.append(page2)

	# Page 3: EXECUTION
	var page3 := ""
	page3 += "[b]3. EXECUTION[/b]\n\n"
	if brief.frag_execution != null and brief.frag_execution != "":
		page3 += "%s\n\n" % brief.frag_execution
	_briefing_pages.append(page3)

	# Page 4: ADMIN & LOGISTICS (if present)
	if brief.frago_logi != null and brief.frago_logi != "":
		var page4 := ""
		page4 += "[b]4. ADMINISTRATION & LOGISTICS[/b]\n\n"
		page4 += "%s\n\n" % brief.frago_logi
		if brief.frag_start_time != null and brief.frag_start_time != "":
			page4 += "[b]H-Hour:[/b] %s\n" % brief.frag_start_time
		_briefing_pages.append(page4)
	elif brief.frag_start_time != null and brief.frag_start_time != "":
		# Add H-Hour to execution page if no logistics section
		_briefing_pages[_briefing_pages.size() - 1] += "[b]H-Hour:[/b] %s\n" % brief.frag_start_time

	# Build full content for reference
	_briefing_full_content = "\n".join(_briefing_pages)
	# Initialize face state
	_briefing_face.total_pages = _briefing_pages.size()
	_briefing_face.current_page = 0
	_briefing_face.update_page_indicator()
	_display_page(_briefing_face, _briefing_content, _briefing_pages, 0)


## Render transcript document
func _render_transcript_doc() -> void:
	_transcript_full_content = "[center][b]RADIO TRANSCRIPT[/b][/center]\n"
	_transcript_full_content += "[center]Mission Communications Log[/center]\n\n"

	if _transcript_entries.is_empty():
		_transcript_full_content += "[i]No communications recorded.[/i]\n"
	else:
		for entry in _transcript_entries:
			var timestamp: String = entry.get("timestamp", "")
			var speaker: String = entry.get("speaker", "")
			var message: String = entry.get("message", "")

			_transcript_full_content += "[b]%s[/b] [%s]\n" % [timestamp, speaker]
			_transcript_full_content += "%s\n\n" % message

	_transcript_pages = await _split_into_pages(_transcript_content, _transcript_full_content)
	# Show last page (most recent entries) for transcript
	var last_page: int = max(0, _transcript_pages.size() - 1)
	# Initialize face state
	_transcript_face.total_pages = _transcript_pages.size()
	_transcript_face.current_page = last_page
	_transcript_face.update_page_indicator()
	_display_page(_transcript_face, _transcript_content, _transcript_pages, last_page)


## Add a radio transmission to the transcript
## [param speaker] Who is speaking (e.g., "PLAYER", "ALPHA", "HQ")
## [param message] The message text
func add_transcript_entry(speaker: String, message: String) -> void:
	var timestamp := _get_mission_timestamp()

	_transcript_entries.append({"timestamp": timestamp, "speaker": speaker, "message": message})

	# Prune old entries if exceeding max
	if _transcript_entries.size() > MAX_TRANSCRIPT_ENTRIES:
		_transcript_entries.pop_front()

	# Remember if user was on the last page before update
	var was_on_last_page := false
	if _transcript_face and _transcript_pages.size() > 0:
		was_on_last_page = _transcript_face.current_page >= _transcript_pages.size() - 1

	await _update_transcript_content(was_on_last_page)


## Get current mission timestamp as formatted string
func _get_mission_timestamp() -> String:
	# TODO: Get actual mission time from SimWorld
	var time := Time.get_ticks_msec() / 1000.0
	var minutes := int(time / 60)
	var seconds := int(time) % 60
	return "%02d:%02d" % [minutes, seconds]


## Apply rendered textures to clipboard materials
func _apply_textures() -> void:
	await get_tree().process_frame
	await get_tree().process_frame  # Extra frame to ensure render complete

	_intel_material = _apply_texture_to_clipboard(intel_clipboard, _intel_viewport)
	_transcript_material = _apply_texture_to_clipboard(transcript_clipboard, _transcript_viewport)
	_briefing_material = _apply_texture_to_clipboard(briefing_clipboard, _briefing_viewport)


## Refresh the transcript document texture after content updates
func _refresh_transcript_texture() -> void:
	if _transcript_material and _transcript_viewport:
		await get_tree().process_frame  # Wait for render
		_refresh_texture(_transcript_material, _transcript_viewport)


## Apply a viewport texture to a clipboard's paper material
## Returns the material for future updates
func _apply_texture_to_clipboard(
	clipboard: RigidBody3D, viewport: SubViewport
) -> StandardMaterial3D:
	if clipboard == null or viewport == null:
		LogService.warning(
			"Cannot apply texture: clipboard or viewport is null", "DocumentController.gd"
		)
		return null

	# Find the mesh child
	var mesh_instance: MeshInstance3D = null
	for child in clipboard.get_node("Mesh").get_children():
		if child is MeshInstance3D:
			mesh_instance = child
			break

	if mesh_instance == null:
		LogService.warning(
			"No MeshInstance3D found in clipboard: %s" % clipboard.name, "DocumentController.gd"
		)
		return null

	# Get or create material for paper surface
	var material: StandardMaterial3D = mesh_instance.get_surface_override_material(
		PAPER_MATERIAL_INDEX
	)

	if material == null:
		material = StandardMaterial3D.new()
		mesh_instance.set_surface_override_material(PAPER_MATERIAL_INDEX, material)

	_refresh_texture(material, viewport)
	return material


## Refresh a material's texture from viewport with mipmaps
func _refresh_texture(material: StandardMaterial3D, viewport: SubViewport) -> void:
	if material == null or viewport == null:
		return

	var img := viewport.get_texture().get_image()
	if img == null:
		LogService.warning("Failed to get image from viewport", "DocumentController.gd")
		return

	img.generate_mipmaps()
	material.albedo_texture = ImageTexture.create_from_image(img)


## Split content into pages based on what fits in the RichTextLabel
func _split_into_pages(content: RichTextLabel, full_text: String) -> Array[String]:
	var pages: Array[String] = []

	if full_text.is_empty():
		pages.append("")
		return pages

	# Set the full text to measure once
	content.text = full_text
	await get_tree().process_frame  # Wait for layout

	var total_lines := content.get_line_count()
	var visible_lines := content.get_visible_line_count()

	# Safety check - if visible_lines is 0 or unreasonably small, use default
	if visible_lines < 10:
		LogService.warning(
			"visible_lines=%d is too small, defaulting to 30" % visible_lines,
			"DocumentController.gd"
		)
		visible_lines = 30

	# If everything fits on one page
	if total_lines <= visible_lines:
		pages.append(full_text)
		return pages

	# Split by lines and use binary search to find what actually fits
	var all_lines := full_text.split("\n")
	var remaining_lines := all_lines.duplicate()

	while remaining_lines.size() > 0:
		# Binary search to find max lines that fit
		var low := 1
		var high := remaining_lines.size()
		var best_fit := 1

		while low <= high:
			var mid := int((low + high) / 2.0)
			var test_lines := remaining_lines.slice(0, mid)
			var test_text := "\n".join(test_lines)

			# Test if this fits
			content.text = test_text
			await get_tree().process_frame

			var test_total := content.get_line_count()
			var test_visible := content.get_visible_line_count()

			if test_total <= test_visible:
				# Fits! Try more lines
				best_fit = mid
				low = mid + 1
			else:
				# Too many lines, try fewer
				high = mid - 1

		# Add the page with best_fit lines
		var page_lines := remaining_lines.slice(0, best_fit)
		var page_text := "\n".join(page_lines)

		# Only add non-empty pages
		if page_text.strip_edges() != "":
			pages.append(page_text)

		# Remove used lines
		remaining_lines = remaining_lines.slice(best_fit)

		# Safety check to avoid infinite loop
		if best_fit == 0:
			LogService.warning(
				"Could not fit any content - forcing remaining %d lines" % remaining_lines.size(),
				"DocumentController.gd"
			)
			pages.append("\n".join(remaining_lines))
			break

	# Ensure at least one page
	if pages.is_empty():
		pages.append(full_text)

	return pages


## Display a specific page for a document
func _display_page(
	face: Control, content: RichTextLabel, pages: Array[String], page_index: int
) -> void:
	if pages.is_empty():
		LogService.warning("No pages to display", "DocumentController.gd")
		return

	page_index = clampi(page_index, 0, pages.size() - 1)
	content.text = pages[page_index]


## Page change handlers - update content and debounce texture refresh
func _on_intel_page_changed(page_index: int) -> void:
	_display_page(_intel_face, _intel_content, _intel_pages, page_index)
	_intel_refresh_timer.start()


func _on_transcript_page_changed(page_index: int) -> void:
	_display_page(_transcript_face, _transcript_content, _transcript_pages, page_index)
	_transcript_refresh_timer.start()


func _on_briefing_page_changed(page_index: int) -> void:
	_display_page(_briefing_face, _briefing_content, _briefing_pages, page_index)
	_briefing_refresh_timer.start()


## Debounced refresh functions - called after timer expires
func _do_intel_refresh() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	_refresh_texture(_intel_material, _intel_viewport)


func _do_transcript_refresh() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	_refresh_texture(_transcript_material, _transcript_viewport)


func _do_briefing_refresh() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	_refresh_texture(_briefing_material, _briefing_viewport)


## Public API for page navigation (can be called from HQTable or input handlers)
func next_page_intel() -> void:
	if _intel_face:
		_intel_face.next_page()


func prev_page_intel() -> void:
	if _intel_face:
		_intel_face.prev_page()


func next_page_transcript() -> void:
	if _transcript_face:
		_transcript_face.next_page()


func prev_page_transcript() -> void:
	if _transcript_face:
		_transcript_face.prev_page()


func next_page_briefing() -> void:
	if _briefing_face:
		_briefing_face.next_page()


func prev_page_briefing() -> void:
	if _briefing_face:
		_briefing_face.prev_page()


## Get status icon for an objective based on MissionResolution state
func _get_objective_status_icon(obj_id: String) -> String:
	if not _resolution:
		return "[ ]"

	var state = _resolution._objective_states.get(obj_id, MissionResolution.ObjectiveState.PENDING)
	match state:
		MissionResolution.ObjectiveState.SUCCESS:
			return "[✓]"
		MissionResolution.ObjectiveState.FAILED:
			return "[✗]"
		_:
			return "[ ]"


## Handle objective state changes and refresh briefing
func _on_objective_updated(_obj_id: String, _state: int) -> void:
	_refresh_briefing_objectives()


## Refresh only the briefing objectives page
func _refresh_briefing_objectives() -> void:
	if not _scenario or not _scenario.briefing:
		return

	var brief: BriefData = _scenario.briefing

	# Rebuild page 2 (MISSION page with objectives)
	var page2 := ""
	page2 += "[b]2. MISSION[/b]\n\n"
	if brief.frag_mission != null and brief.frag_mission != "":
		page2 += "%s\n\n" % brief.frag_mission
	if brief.frag_objectives != null and brief.frag_objectives.size() > 0:
		page2 += "[b]Objectives:[/b]\n"
		for obj in brief.frag_objectives:
			if obj is ScenarioObjectiveData:
				var status_icon := _get_objective_status_icon(obj.id)
				page2 += "%s %s\n" % [status_icon, obj.title]
		page2 += "\n"

	# Update the briefing pages array
	if _briefing_pages.size() >= 2:
		_briefing_pages[1] = page2

	# If currently viewing page 2, refresh the display
	if _briefing_face and _briefing_face.current_page == 1:
		_display_page(_briefing_face, _briefing_content, _briefing_pages, 1)
		_briefing_refresh_timer.start()
