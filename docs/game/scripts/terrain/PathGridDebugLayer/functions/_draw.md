# PathGridDebugLayer::_draw Function Reference

*Defined at:* `scripts/terrain/PathGridDebugLayer.gd` (lines 9–13)</br>
*Belongs to:* [PathGridDebugLayer](../../PathGridDebugLayer.md)

**Signature**

```gdscript
func _draw() -> void
```

**Decorators:** `@export var grid: PathGrid`

## Description

Simple on-canvas PathGrid visualizer

## Source

```gdscript
func _draw() -> void:
	if grid:
		grid.debug_draw_overlay(self)
```
