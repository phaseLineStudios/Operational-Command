# MainMenu::_collapse_if_needed Function Reference

*Defined at:* `scripts/ui/MainMenu.gd` (lines 183–187)</br>
*Belongs to:* [MainMenu](../MainMenu.md)

**Signature**

```gdscript
func _collapse_if_needed() -> void
```

## Description

Collapse submenu only if expanded

## Source

```gdscript
func _collapse_if_needed() -> void:
	if _state == SubmenuState.EXPANDED:
		_collapse_submenu()
```
