# DocumentController::_render_briefing_doc Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 239–309)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _render_briefing_doc() -> void
```

## Description

Render briefing document in FRAGO SMEAC format

## Source

```gdscript
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
```
