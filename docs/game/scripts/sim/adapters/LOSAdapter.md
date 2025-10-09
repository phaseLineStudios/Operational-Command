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

NodePath to a LOS helper that implements:
`trace_los(a_pos, b_pos, renderer, terrain_data, effects_config) -> Dictionary`

NodePath to the TerrainRender that provides `data: TerrainData`.

## Public Member Functions

- [`func _ready() -> void`](LOSAdapter/functions/_ready.md) — Autowires LOS helper and terrain renderer from exported paths.
- [`func has_los(a: ScenarioUnit, b: ScenarioUnit) -> bool`](LOSAdapter/functions/has_los.md) — Returns true if there is an unobstructed LOS from [param a] to [param b].
- [`func spotting_mul(pos_d: Vector2, range_m: float, weather_severity: float = 0.0) -> float`](LOSAdapter/functions/spotting_mul.md) — Computes a spotting multiplier (0..1) at [param range_m] from [param pos_d].
- [`func contacts_between(friends: Array[ScenarioUnit], enemies: Array[ScenarioUnit]) -> Array`](LOSAdapter/functions/contacts_between.md) — Builds contact pairs with clear LOS between [param friends] and [param enemies].

## Public Attributes

- `NodePath los_node_path`
- `NodePath terrain_renderer_path`
- `TerrainEffectsConfig effects_config` — Terrain effects configuration used by LOS/spotting calculations.
- `Node _los`
- `TerrainRender _renderer`
- `TerrainData _terrain`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Autowires LOS helper and terrain renderer from exported paths.

### has_los

```gdscript
func has_los(a: ScenarioUnit, b: ScenarioUnit) -> bool
```

Returns true if there is an unobstructed LOS from [param a] to [param b].
[param a] Attacking/observing unit.
[param b] Defending/observed unit.
[return] True if LOS is clear, otherwise false.

### spotting_mul

```gdscript
func spotting_mul(pos_d: Vector2, range_m: float, weather_severity: float = 0.0) -> float
```

Computes a spotting multiplier (0..1) at [param range_m] from [param pos_d].
Values near 0 reduce detection; 1 means no penalty.
[param pos_d] Defender position in meters (terrain space).
[param range_m] Range from observer to defender in meters.
[param weather_severity] Optional 0..1 weather penalty factor.
[return] Spotting multiplier in [0, 1].

### contacts_between

```gdscript
func contacts_between(friends: Array[ScenarioUnit], enemies: Array[ScenarioUnit]) -> Array
```

Builds contact pairs with clear LOS between [param friends] and [param enemies].
[param friends] Array of friendly ScenarioUnit.
[param enemies] Array of enemy ScenarioUnit.
[return] Array of Dictionaries: { \"attacker\": ScenarioUnit, \"defender\": ScenarioUnit }.

## Member Data Documentation

### los_node_path

```gdscript
var los_node_path: NodePath
```

### terrain_renderer_path

```gdscript
var terrain_renderer_path: NodePath
```

### effects_config

```gdscript
var effects_config: TerrainEffectsConfig
```

Decorators: `@export`

Terrain effects configuration used by LOS/spotting calculations.

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
