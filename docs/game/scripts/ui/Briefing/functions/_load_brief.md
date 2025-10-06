# Briefing::_load_brief Function Reference

*Defined at:* `scripts/ui/Briefing.gd` (lines 37–44)</br>
*Belongs to:* [Briefing](../Briefing.md)

**Signature**

```gdscript
func _load_brief() -> void
```

## Description

Load the new-structure brief (your schema).

## Source

```gdscript
func _load_brief() -> void:
	_brief = Game.current_scenario.briefing
	if not _brief:
		return
	_title.text = String(_brief.title)
	_items = _brief.board_items
```
