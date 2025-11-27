# PickupItem Class Reference

*File:* `scripts/core/PickupItem.gd`
*Class name:* `PickupItem`
*Inherits:* `RigidBody3D`

## Synopsis

```gdscript
class_name PickupItem
extends RigidBody3D
```

## Brief

Surface index 3 is the paper surface on the clipboard

## Detailed Description

Size of the document viewport for coordinate mapping

## Public Member Functions

- [`func get_grab_offset(hit_position: Vector3) -> Vector3`](PickupItem/functions/get_grab_offset.md) — Get the grab offset for this item.
- [`func _ready()`](PickupItem/functions/_ready.md)
- [`func on_pickup() -> void`](PickupItem/functions/on_pickup.md) — Runs on pickup
- [`func on_drop() -> void`](PickupItem/functions/on_drop.md) — Runs on drop
- [`func start_inspect(camera: Camera3D) -> void`](PickupItem/functions/start_inspect.md) — Runs on inspect start
- [`func end_inspect() -> void`](PickupItem/functions/end_inspect.md) — Runs on inspect close
- [`func toggle_inspect(camera: Camera3D) -> void`](PickupItem/functions/toggle_inspect.md)
- [`func is_inspecting() -> bool`](PickupItem/functions/is_inspecting.md)
- [`func handle_inspect_input(event: InputEvent) -> bool`](PickupItem/functions/handle_inspect_input.md)
- [`func _process(delta: float) -> void`](PickupItem/functions/_process.md)
- [`func _unhandled_input(event: InputEvent) -> void`](PickupItem/functions/_unhandled_input.md) — Handle unhandled input for document interaction
- [`func _get_document_uv_from_hit(hit: Dictionary) -> Vector2`](PickupItem/functions/_get_document_uv_from_hit.md) — Get UV coordinates from raycast hit on document mesh
- [`func _barycentric_coords(p: Vector3, a: Vector3, b: Vector3, c: Vector3) -> Vector3`](PickupItem/functions/_barycentric_coords.md) — Calculate barycentric coordinates of point p in triangle (a, b, c)

## Public Attributes

- `Vector3 held_rotation` — Rotation of object when held
- `bool pick_toggle` — Should pick be a toggle action or a held action
- `bool hide_mouse` — Should the mouse be hidden when object is held
- `bool use_fixed_anchor` — Use a fixed anchor point instead of click position (in local space)
- `Vector3 anchor_offset` — Fixed anchor point in local coordinates (e.g., Vector3(0, -0.05, 0) for pen tip)
- `bool snap_to_origin_position` — Snap back to origin position on drop
- `bool snap_to_origin_rotation` — Snap back to origin rotation on drop
- `bool inspect_enabled`
- `Vector3 inspect_offset` — Local offset from the camera (Godot forward is -Z)
- `Vector3 inspect_rotation` — Rotation relative to camera (degrees)
- `float inspect_smooth` — Higher = snappier follow in inspect (0 = teleport)
- `SubViewport document_viewport` — Viewport to forward clicks to (for interactive documents)
- `Vector3 origin_position`
- `Vector3 origin_rotation`
- `Camera3D _inspect_camera`
- `Transform3D _pre_inspect_transform`

## Member Function Documentation

### get_grab_offset

```gdscript
func get_grab_offset(hit_position: Vector3) -> Vector3
```

Get the grab offset for this item.
If use_fixed_anchor is true, returns anchor_offset.
Otherwise, returns the offset based on where the item was clicked.
`hit_position` World position where the item was clicked.
[return] Local offset for grabbing.

### _ready

```gdscript
func _ready()
```

### on_pickup

```gdscript
func on_pickup() -> void
```

Runs on pickup

### on_drop

```gdscript
func on_drop() -> void
```

Runs on drop

### start_inspect

```gdscript
func start_inspect(camera: Camera3D) -> void
```

Runs on inspect start

### end_inspect

```gdscript
func end_inspect() -> void
```

Runs on inspect close

### toggle_inspect

```gdscript
func toggle_inspect(camera: Camera3D) -> void
```

### is_inspecting

```gdscript
func is_inspecting() -> bool
```

### handle_inspect_input

```gdscript
func handle_inspect_input(event: InputEvent) -> bool
```

### _process

```gdscript
func _process(delta: float) -> void
```

### _unhandled_input

```gdscript
func _unhandled_input(event: InputEvent) -> void
```

Handle unhandled input for document interaction

### _get_document_uv_from_hit

```gdscript
func _get_document_uv_from_hit(hit: Dictionary) -> Vector2
```

Get UV coordinates from raycast hit on document mesh

### _barycentric_coords

```gdscript
func _barycentric_coords(p: Vector3, a: Vector3, b: Vector3, c: Vector3) -> Vector3
```

Calculate barycentric coordinates of point p in triangle (a, b, c)

## Member Data Documentation

### held_rotation

```gdscript
var held_rotation: Vector3
```

Decorators: `@export`

Rotation of object when held

### pick_toggle

```gdscript
var pick_toggle: bool
```

Decorators: `@export`

Should pick be a toggle action or a held action

### hide_mouse

```gdscript
var hide_mouse: bool
```

Decorators: `@export`

Should the mouse be hidden when object is held

### use_fixed_anchor

```gdscript
var use_fixed_anchor: bool
```

Decorators: `@export`

Use a fixed anchor point instead of click position (in local space)

### anchor_offset

```gdscript
var anchor_offset: Vector3
```

Decorators: `@export`

Fixed anchor point in local coordinates (e.g., Vector3(0, -0.05, 0) for pen tip)

### snap_to_origin_position

```gdscript
var snap_to_origin_position: bool
```

Decorators: `@export`

Snap back to origin position on drop

### snap_to_origin_rotation

```gdscript
var snap_to_origin_rotation: bool
```

Decorators: `@export`

Snap back to origin rotation on drop

### inspect_enabled

```gdscript
var inspect_enabled: bool
```

### inspect_offset

```gdscript
var inspect_offset: Vector3
```

Decorators: `@export`

Local offset from the camera (Godot forward is -Z)

### inspect_rotation

```gdscript
var inspect_rotation: Vector3
```

Decorators: `@export`

Rotation relative to camera (degrees)

### inspect_smooth

```gdscript
var inspect_smooth: float
```

Decorators: `@export`

Higher = snappier follow in inspect (0 = teleport)

### document_viewport

```gdscript
var document_viewport: SubViewport
```

Decorators: `@export`

Viewport to forward clicks to (for interactive documents)

### origin_position

```gdscript
var origin_position: Vector3
```

### origin_rotation

```gdscript
var origin_rotation: Vector3
```

### _inspect_camera

```gdscript
var _inspect_camera: Camera3D
```

### _pre_inspect_transform

```gdscript
var _pre_inspect_transform: Transform3D
```
