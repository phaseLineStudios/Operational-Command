# AIAgent Class Reference

*File:* `scripts/ai/AIAgent.gd`
*Class name:* `AIAgent`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name AIAgent
extends Node
```

## Brief

Provide adapter references directly (preferred over NodePath lookups).

## Public Member Functions

- [`func _ready() -> void`](AIAgent/functions/_ready.md)
- [`func _ensure_adapter_refs() -> void`](AIAgent/functions/_ensure_adapter_refs.md)
- [`func _on_adapters_changed() -> void`](AIAgent/functions/_on_adapters_changed.md)
- [`func notify_hostile_shot() -> void`](AIAgent/functions/notify_hostile_shot.md) — External notification that a hostile shot was observed against this unit.
- [`func _get_su() -> ScenarioUnit`](AIAgent/functions/_get_su.md)
- [`func set_behaviour(b: int) -> void`](AIAgent/functions/set_behaviour.md)
- [`func set_combat_mode(m: int) -> void`](AIAgent/functions/set_combat_mode.md)
- [`func _apply_behaviour_mapping() -> void`](AIAgent/functions/_apply_behaviour_mapping.md)
- [`func intent_move_begin(point_m: Variant) -> void`](AIAgent/functions/intent_move_begin.md) — Begin a move intent using ScenarioUnit + MovementAdapter pathing
- [`func intent_move_check() -> bool`](AIAgent/functions/intent_move_check.md)
- [`func intent_defend_begin(center_m: Variant, radius: float) -> void`](AIAgent/functions/intent_defend_begin.md)
- [`func intent_defend_check() -> bool`](AIAgent/functions/intent_defend_check.md)
- [`func intent_patrol_check() -> bool`](AIAgent/functions/intent_patrol_check.md)
- [`func set_patrol_dwell(seconds: float) -> void`](AIAgent/functions/set_patrol_dwell.md) — Optional: set patrol dwell time (seconds) if adapter supports it
- [`func intent_wait_begin(seconds: float, until_contact: bool) -> void`](AIAgent/functions/intent_wait_begin.md)
- [`func intent_wait_check(dt: float) -> bool`](AIAgent/functions/intent_wait_check.md)

## Public Attributes

- `int unit_id`
- `NodePath movement_adapter_path`
- `NodePath combat_adapter_path`
- `NodePath los_adapter_path`
- `NodePath orders_router_path`
- `int behaviour`
- `int combat_mode`
- `float _wait_timer`
- `bool _wait_until_contact`
- `OrdersRouter _router`

## Signals

- `signal behaviour_changed(unit_id: int, behaviour: int)` — Translates tasks into intents for your existing adapters in scripts/sim/adapters.
- `signal combat_mode_changed(unit_id: int, mode: int)`

## Enumerations

- `enum Behaviour`
- `enum ROE`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _ensure_adapter_refs

```gdscript
func _ensure_adapter_refs() -> void
```

### _on_adapters_changed

```gdscript
func _on_adapters_changed() -> void
```

### notify_hostile_shot

```gdscript
func notify_hostile_shot() -> void
```

External notification that a hostile shot was observed against this unit.

### _get_su

```gdscript
func _get_su() -> ScenarioUnit
```

### set_behaviour

```gdscript
func set_behaviour(b: int) -> void
```

### set_combat_mode

```gdscript
func set_combat_mode(m: int) -> void
```

### _apply_behaviour_mapping

```gdscript
func _apply_behaviour_mapping() -> void
```

### intent_move_begin

```gdscript
func intent_move_begin(point_m: Variant) -> void
```

Begin a move intent using ScenarioUnit + MovementAdapter pathing

### intent_move_check

```gdscript
func intent_move_check() -> bool
```

### intent_defend_begin

```gdscript
func intent_defend_begin(center_m: Variant, radius: float) -> void
```

### intent_defend_check

```gdscript
func intent_defend_check() -> bool
```

### intent_patrol_check

```gdscript
func intent_patrol_check() -> bool
```

### set_patrol_dwell

```gdscript
func set_patrol_dwell(seconds: float) -> void
```

Optional: set patrol dwell time (seconds) if adapter supports it

### intent_wait_begin

```gdscript
func intent_wait_begin(seconds: float, until_contact: bool) -> void
```

### intent_wait_check

```gdscript
func intent_wait_check(dt: float) -> bool
```

## Member Data Documentation

### unit_id

```gdscript
var unit_id: int
```

### movement_adapter_path

```gdscript
var movement_adapter_path: NodePath
```

### combat_adapter_path

```gdscript
var combat_adapter_path: NodePath
```

### los_adapter_path

```gdscript
var los_adapter_path: NodePath
```

### orders_router_path

```gdscript
var orders_router_path: NodePath
```

### behaviour

```gdscript
var behaviour: int
```

### combat_mode

```gdscript
var combat_mode: int
```

### _wait_timer

```gdscript
var _wait_timer: float
```

### _wait_until_contact

```gdscript
var _wait_until_contact: bool
```

### _router

```gdscript
var _router: OrdersRouter
```

## Signal Documentation

### behaviour_changed

```gdscript
signal behaviour_changed(unit_id: int, behaviour: int)
```

Translates tasks into intents for your existing adapters in scripts/sim/adapters.

### combat_mode_changed

```gdscript
signal combat_mode_changed(unit_id: int, mode: int)
```

## Enumeration Type Documentation

### Behaviour

```gdscript
enum Behaviour
```

### ROE

```gdscript
enum ROE
```
