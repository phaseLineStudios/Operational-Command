# PauseMenu::_release_interactions Function Reference

*Defined at:* `scripts/ui/PauseMenu.gd` (lines 105–108)</br>
*Belongs to:* [PauseMenu](../../PauseMenu.md)

**Signature**

```gdscript
func _release_interactions() -> void
```

## Source

```gdscript
func _release_interactions() -> void:
	for controller in get_tree().get_nodes_in_group("interaction_controllers"):
		if controller and controller.has_method("cancel_hold"):
			controller.cancel_hold()
```
