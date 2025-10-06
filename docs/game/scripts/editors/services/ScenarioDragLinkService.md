# ScenarioDragLinkService Class Reference

*File:* `scripts/editors/services/ScenarioDragLinkService.gd`
*Class name:* `ScenarioDragLinkService`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name ScenarioDragLinkService
extends RefCounted
```

## Public Member Functions

- [`func begin_drag(ctx: ScenarioEditorContext, pick: Dictionary, overlay_pos: Vector2) -> void`](ScenarioDragLinkService/functions/begin_drag.md)
- [`func update_drag(ctx: ScenarioEditorContext, overlay_pos: Vector2) -> void`](ScenarioDragLinkService/functions/update_drag.md)
- [`func end_drag(ctx: ScenarioEditorContext, commit := true) -> void`](ScenarioDragLinkService/functions/end_drag.md)
- [`func begin_link(ctx: ScenarioEditorContext, src: Dictionary, cursor_pos: Vector2) -> void`](ScenarioDragLinkService/functions/begin_link.md)
- [`func update_link(ctx: ScenarioEditorContext, cursor_pos: Vector2) -> void`](ScenarioDragLinkService/functions/update_link.md)
- [`func end_link(ctx: ScenarioEditorContext) -> void`](ScenarioDragLinkService/functions/end_link.md)
- [`func _get_pos(ctx: ScenarioEditorContext, pick: Dictionary) -> Vector2`](ScenarioDragLinkService/functions/_get_pos.md)
- [`func _set_pos(ctx: ScenarioEditorContext, pick: Dictionary, p: Vector2) -> void`](ScenarioDragLinkService/functions/_set_pos.md)

## Public Attributes

- `Dictionary drag_pick`
- `Dictionary link_src_pick`
- `ScenarioUnit su`
- `UnitSlotData sl`
- `ScenarioTask ti`

## Member Function Documentation

### begin_drag

```gdscript
func begin_drag(ctx: ScenarioEditorContext, pick: Dictionary, overlay_pos: Vector2) -> void
```

### update_drag

```gdscript
func update_drag(ctx: ScenarioEditorContext, overlay_pos: Vector2) -> void
```

### end_drag

```gdscript
func end_drag(ctx: ScenarioEditorContext, commit := true) -> void
```

### begin_link

```gdscript
func begin_link(ctx: ScenarioEditorContext, src: Dictionary, cursor_pos: Vector2) -> void
```

### update_link

```gdscript
func update_link(ctx: ScenarioEditorContext, cursor_pos: Vector2) -> void
```

### end_link

```gdscript
func end_link(ctx: ScenarioEditorContext) -> void
```

### _get_pos

```gdscript
func _get_pos(ctx: ScenarioEditorContext, pick: Dictionary) -> Vector2
```

### _set_pos

```gdscript
func _set_pos(ctx: ScenarioEditorContext, pick: Dictionary, p: Vector2) -> void
```

## Member Data Documentation

### drag_pick

```gdscript
var drag_pick: Dictionary
```

### link_src_pick

```gdscript
var link_src_pick: Dictionary
```

### su

```gdscript
var su: ScenarioUnit
```

### sl

```gdscript
var sl: UnitSlotData
```

### ti

```gdscript
var ti: ScenarioTask
```
