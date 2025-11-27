# UnitSelect::_populate_replacements_ui Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 781–815)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _populate_replacements_ui(unit: UnitData) -> void
```

## Description

Populate replacements UI with ReinforcementPanel

## Source

```gdscript
func _populate_replacements_ui(unit: UnitData) -> void:
	if not unit:
		# Clear all children when no unit selected
		for child in _replacements_vbox.get_children():
			child.queue_free()
		return

	var scenario_unit := _get_scenario_unit_for_id(unit.id)
	if not scenario_unit:
		# Clear all children when no scenario unit found
		for child in _replacements_vbox.get_children():
			child.queue_free()
		return

	# Instantiate ReinforcementPanel if needed
	if not _reinforcement_panel:
		_reinforcement_panel = REINFORCEMENT_PANEL_SCENE.instantiate() as ReinforcementPanel
		_reinforcement_panel.reinforcement_committed.connect(_on_reinforcement_committed)

	# Add to replacements vbox if not already added
	if _reinforcement_panel.get_parent() != _replacements_vbox:
		if _reinforcement_panel.get_parent():
			_reinforcement_panel.get_parent().remove_child(_reinforcement_panel)
		_replacements_vbox.add_child(_reinforcement_panel)

	# Get unit strength from scenario unit
	var unit_strengths: Dictionary[String, float] = {}
	unit_strengths[unit.id] = scenario_unit.state_strength

	# Set up panel with single unit
	_reinforcement_panel.set_units([unit], unit_strengths)
	_reinforcement_panel.set_pool(Game.current_scenario.replacement_pool)
	_reinforcement_panel.reset_pending()
```
