# TriggerAPI::color Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 652–655)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func color(r: float, g: float, b: float, a: float = 1.0) -> Color
```

- **r**: Red component (0.0 to 1.0)
- **g**: Green component (0.0 to 1.0)
- **b**: Blue component (0.0 to 1.0)
- **a**: Alpha component (0.0 to 1.0), defaults to 1.0
- **Return Value**: Color with given components

## Description

Create a Color from RGB or RGBA values (0.0 to 1.0).
  
  

**Usage in trigger expressions:**

```
# Create red color
set_global("marker_color", color(1.0, 0.0, 0.0))

# Create semi-transparent blue
set_global("marker_color", color(0.0, 0.0, 1.0, 0.5))
```

## Source

```gdscript
func color(r: float, g: float, b: float, a: float = 1.0) -> Color:
	return Color(r, g, b, a)
```
