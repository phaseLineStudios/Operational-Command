# MainMenu::_build_submenu_buttons Function Reference

*Defined at:* `scripts/ui/MainMenu.gd` (lines 125–161)</br>
*Belongs to:* [MainMenu](../MainMenu.md)

**Signature**

```gdscript
func _build_submenu_buttons() -> void
```

## Description

Creates 3 submenu buttons and wires them to scene changes.

## Source

```gdscript
func _build_submenu_buttons() -> void:
	_clear_children(_submenu_holder)

	# Campaign Editor
	var b_campaign := Button.new()
	b_campaign.text = SUB_BUTTON_TEXT["campaign_editor"]
	b_campaign.focus_mode = Control.FOCUS_ALL
	b_campaign.pressed.connect(
		func():
			_collapse_submenu()
			_go("campaign_editor")
	)
	_submenu_holder.add_child(b_campaign)

	# Scenario Editor
	var b_scenario := Button.new()
	b_scenario.text = SUB_BUTTON_TEXT["scenario_editor"]
	b_scenario.focus_mode = Control.FOCUS_ALL
	b_scenario.pressed.connect(
		func():
			_collapse_submenu()
			_go("scenario_editor")
	)
	_submenu_holder.add_child(b_scenario)

	# Terrain Editor
	var b_terrain := Button.new()
	b_terrain.text = SUB_BUTTON_TEXT["terrain_editor"]
	b_terrain.focus_mode = Control.FOCUS_ALL
	b_terrain.pressed.connect(
		func():
			_collapse_submenu()
			_go("terrain_editor")
	)
	_submenu_holder.add_child(b_terrain)
```
