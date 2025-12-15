# DocumentController::_refresh_briefing_objectives Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 831–857)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _refresh_briefing_objectives() -> void
```

## Description

Refresh only the briefing objectives page

## Source

```gdscript
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
```
