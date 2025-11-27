# DebugMenu::_update_mission_tab_visibility Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 623–634)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _update_mission_tab_visibility() -> void
```

## Description

Update Mission tab visibility based on whether HQ Table scene is active

## Source

```gdscript
func _update_mission_tab_visibility() -> void:
	if not is_inside_tree():
		return

	# Check if SimWorld exists in the scene tree (indicates HQ Table is active)
	var root := get_tree().root
	var sim_world := root.find_child("SimWorld", true, false)

	if sim_world and mission_tab:
		mission_tab.visible = true
	elif mission_tab:
		mission_tab.visible = false
```
