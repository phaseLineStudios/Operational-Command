# PostProcessController::_get_shader Function Reference

*Defined at:* `scripts/ui/PostProcessController.gd` (lines 132–135)</br>
*Belongs to:* [PostProcessController](../../PostProcessController.md)

**Signature**

```gdscript
func _get_shader(rect: CanvasItem) -> ShaderMaterial
```

## Description

Get shader material from CanvasItem.

## Source

```gdscript
func _get_shader(rect: CanvasItem) -> ShaderMaterial:
	return rect.material as ShaderMaterial
```
