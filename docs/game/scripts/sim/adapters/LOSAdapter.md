# LOSAdapter Class Reference

*File:* `scripts/sim/adapters/LOSAdapter.gd`
*Class name:* `LOSAdapter`
*Inherits:* `Node`
> **Experimental**

## Synopsis

```gdscript
class_name LOSAdapter
extends Node
```

## Brief

Line-of-sight adapter for unit visibility and contact checks

Wraps a LOS helper node and terrain data to answer LOS, spotting
multipliers, and build contact pairs between forces.

## Detailed Description

Minimal contact detector used by TaskWait until_contact.
Either toggle by API, or do a simple distance scan against a group.

## Public Member Functions

- [`func _ready() -> void`](LOSAdapter/functions/_ready.md) — Autowires LOS helper and terrain renderer from exported paths.
- [`func _process(_dt: float) -> void`](LOSAdapter/functions/_process.md)
- [`func has_los(a: ScenarioUnit, b: ScenarioUnit) -> bool`](LOSAdapter/functions/has_los.md) — Returns true if there is an unobstructed LOS from `a` to `b`.
- [`func spotting_mul(pos_d: Vector2, range_m: float, weather_severity: float = 0.0) -> float`](LOSAdapter/functions/spotting_mul.md) — Computes a spotting multiplier (0..1) at `range_m` from `pos_d`.
- [`func contacts_between(friends: Array[ScenarioUnit], enemies: Array[ScenarioUnit]) -> Array`](LOSAdapter/functions/contacts_between.md) — Builds contact pairs with clear LOS between `friends` and `enemies`.
- [`func _on_contact(attacker: String, defender: String) -> void`](LOSAdapter/functions/_on_contact.md) — used by AIAgent to determine what to do on contact in LOSAdapter
- [`func has_hostile_contact() -> bool`](LOSAdapter/functions/has_hostile_contact.md) — Used by AIAgent wait-until-contact
- [`func set_hostile_contact(v: bool) -> void`](LOSAdapter/functions/set_hostile_contact.md) — Allow external systems to toggle contact directly.
- [`func _behaviour_spotting_mult(target: ScenarioUnit) -> float`](LOSAdapter/functions/_behaviour_spotting_mult.md)
- [`func sample_visibility_for_unit(_unit: ScenarioUnit) -> float`](LOSAdapter/functions/sample_visibility_for_unit.md) — Fast local visibility query placeholder for EnvBehaviorSystem.
- [`func sample_visibility_at(_pos_m: Vector2) -> float`](LOSAdapter/functions/sample_visibility_at.md) — Visibility sampling at a position placeholder.
- [`func _current_weather_severity() -> float`](LOSAdapter/functions/_current_weather_severity.md)

## Public Attributes

- `NodePath actor_path` — If actor_path is set and hostiles_group_name is non-empty, we will auto-scan each frame.
- `StringName hostiles_group_name`
- `float detection_radius`
- `NodePath los_node_path` — NodePath to a LOS helper that implements:
- `NodePath terrain_renderer_path` — NodePath to the TerrainRender that provides `data: TerrainData`.
- `TerrainEffectsConfig effects_config` — Terrain effects configuration used by LOS/spotting calculations.
- `NodePath simworld_path`
- `String unit_id`
- `float contact_memory_sec`
- `Node _los`
- `TerrainRender _renderer`
- `TerrainData _terrain`
- `Node3D _actor`
- `bool _hostile_contact`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Autowires LOS helper and terrain renderer from exported paths.

### _process

```gdscript
func _process(_dt: float) -> void
```

### has_los

```gdscript
func has_los(a: ScenarioUnit, b: ScenarioUnit) -> bool
```

Returns true if there is an unobstructed LOS from `a` to `b`.
Checks both terrain blocking AND maximum spotting range.
`a` Attacking/observing unit.
`b` Defending/observed unit.
[return] True if LOS is clear and within range, otherwise false.

### spotting_mul

```gdscript
func spotting_mul(pos_d: Vector2, range_m: float, weather_severity: float = 0.0) -> float
```

Computes a spotting multiplier (0..1) at `range_m` from `pos_d`.
Values near 0 reduce detection; 1 means no penalty.
`pos_d` Defender position in meters (terrain space).
`range_m` Range from observer to defender in meters.
`weather_severity` Optional 0..1 weather penalty factor.
[return] Spotting multiplier in [0, 1].

### contacts_between

```gdscript
func contacts_between(friends: Array[ScenarioUnit], enemies: Array[ScenarioUnit]) -> Array
```

Builds contact pairs with clear LOS between `friends` and `enemies`.
`friends` Array of friendly ScenarioUnit.
`enemies` Array of enemy ScenarioUnit.
[return] Array of Dictionaries: { \"attacker\": ScenarioUnit, \"defender\": ScenarioUnit }.

### _on_contact

```gdscript
func _on_contact(attacker: String, defender: String) -> void
```

used by AIAgent to determine what to do on contact in LOSAdapter

### has_hostile_contact

```gdscript
func has_hostile_contact() -> bool
```

Used by AIAgent wait-until-contact

### set_hostile_contact

```gdscript
func set_hostile_contact(v: bool) -> void
```

Allow external systems to toggle contact directly.

### _behaviour_spotting_mult

```gdscript
func _behaviour_spotting_mult(target: ScenarioUnit) -> float
```

### sample_visibility_for_unit

```gdscript
func sample_visibility_for_unit(_unit: ScenarioUnit) -> float
```

Fast local visibility query placeholder for EnvBehaviorSystem.

### sample_visibility_at

```gdscript
func sample_visibility_at(_pos_m: Vector2) -> float
```

Visibility sampling at a position placeholder.

### _current_weather_severity

```gdscript
func _current_weather_severity() -> float
```

## Member Data Documentation

### actor_path

```gdscript
var actor_path: NodePath
```

Decorators: `@export`

If actor_path is set and hostiles_group_name is non-empty, we will auto-scan each frame.

### hostiles_group_name

```gdscript
var hostiles_group_name: StringName
```

### detection_radius

```gdscript
var detection_radius: float
```

### los_node_path

```gdscript
var los_node_path: NodePath
```

Decorators: `@export`

NodePath to a LOS helper that implements:
`trace_los(a_pos, b_pos, renderer, terrain_data, effects_config) -> Dictionary`

### terrain_renderer_path

```gdscript
var terrain_renderer_path: NodePath
```

Decorators: `@export`

NodePath to the TerrainRender that provides `data: TerrainData`.

### effects_config

```gdscript
var effects_config: TerrainEffectsConfig
```

Decorators: `@export`

Terrain effects configuration used by LOS/spotting calculations.

### simworld_path

```gdscript
var simworld_path: NodePath
```

### unit_id

```gdscript
var unit_id: String
```

### contact_memory_sec

```gdscript
var contact_memory_sec: float
```

### _los

```gdscript
var _los: Node
```

### _renderer

```gdscript
var _renderer: TerrainRender
```

### _terrain

```gdscript
var _terrain: TerrainData
```

### _actor

```gdscript
var _actor: Node3D
```

### _hostile_contact

```gdscript
var _hostile_contact: bool
```
