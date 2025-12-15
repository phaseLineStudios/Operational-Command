# TriggerAPI::get_drawing_count Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 334–339)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func get_drawing_count() -> int
```

- **Return Value**: Number of strokes drawn.

## Description

Get the number of drawing strokes the player has made.
Each continuous pen stroke counts as one stroke.
  
  

**Usage in trigger condition:**

## Source

```gdscript
func get_drawing_count() -> int:
	if drawing_controller and drawing_controller.has_method("get_stroke_count"):
		return drawing_controller.get_stroke_count()
	return 0
```
