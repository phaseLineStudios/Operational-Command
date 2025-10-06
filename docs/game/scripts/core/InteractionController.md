# InteractionController Class Reference

*File:* `scripts/core/PlayerInteraction.gd`
*Class name:* `InteractionController`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name InteractionController
extends Node
```

## Public Member Functions

- [`func _ready()`](InteractionController/functions/_ready.md)
- [`func _unhandled_input(event: InputEvent) -> void`](InteractionController/functions/_unhandled_input.md)
- [`func _process(delta: float) -> void`](InteractionController/functions/_process.md)
- [`func _try_pickup(mouse_pos: Vector2) -> void`](InteractionController/functions/_try_pickup.md)
- [`func _drop_held() -> void`](InteractionController/functions/_drop_held.md)
- [`func _project_mouse_to_finite_plane(mouse_pos: Vector2) -> Variant`](InteractionController/functions/_project_mouse_to_finite_plane.md)

## Public Attributes

- `int pickable_mask`
- `float follow_smooth`
- `PickupItem _held`
- `Camera3D camera`
- `MeshInstance3D bounds`

## Member Function Documentation

### _ready

```gdscript
func _ready()
```

### _unhandled_input

```gdscript
func _unhandled_input(event: InputEvent) -> void
```

### _process

```gdscript
func _process(delta: float) -> void
```

### _try_pickup

```gdscript
func _try_pickup(mouse_pos: Vector2) -> void
```

### _drop_held

```gdscript
func _drop_held() -> void
```

### _project_mouse_to_finite_plane

```gdscript
func _project_mouse_to_finite_plane(mouse_pos: Vector2) -> Variant
```

## Member Data Documentation

### pickable_mask

```gdscript
var pickable_mask: int
```

### follow_smooth

```gdscript
var follow_smooth: float
```

### _held

```gdscript
var _held: PickupItem
```

### camera

```gdscript
var camera: Camera3D
```

### bounds

```gdscript
var bounds: MeshInstance3D
```
