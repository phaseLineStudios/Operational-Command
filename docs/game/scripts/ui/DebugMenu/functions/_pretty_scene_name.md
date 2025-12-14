# DebugMenu::_pretty_scene_name Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 142–147)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _pretty_scene_name(p: String) -> String
```

## Description

Prettify scene name

## Source

```gdscript
func _pretty_scene_name(p: String) -> String:
	var rel := p.replace("res://", "")
	var dot := rel.rfind(".")
	return rel.substr(0, dot) if dot >= 0 else rel
```
