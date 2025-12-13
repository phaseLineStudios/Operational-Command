# DrawingController::has_drawing Function Reference

*Defined at:* `scripts/core/DrawingController.gd` (lines 321–324)</br>
*Belongs to:* [DrawingController](../../DrawingController.md)

**Signature**

```gdscript
func has_drawing() -> bool
```

## Description

Check if any drawing has been made

## Source

```gdscript
func has_drawing() -> bool:
	return not _strokes.is_empty()
```
