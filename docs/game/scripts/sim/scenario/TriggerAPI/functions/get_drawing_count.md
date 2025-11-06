# TriggerAPI::get_drawing_count Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 320–325)</br>
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

```
# Trigger when player has drawn at least 3 strokes
get_drawing_count() >= 3

# Combined with location check
get_drawing_count() > 0 and count_in_area("friend", Vector2(500, 500), Vector2(100, 100)) > 0
```

## Source

```gdscript
func get_drawing_count() -> int:
	if drawing_controller and drawing_controller.has_method("get_stroke_count"):
		return drawing_controller.get_stroke_count()
	return 0
```
