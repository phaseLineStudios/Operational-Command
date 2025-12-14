# AIController Class Reference

*File:* `scripts/ai/AIController.gd`
*Class name:* `AIController`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name AIController
extends Node
```

## Brief

Enemy AI task manager with Cold War doctrine behaviors.

## Detailed Description

Maintains a rolling task list (defend, attack, delay, ambush) and reacts to
player activity and simulation feedback to re-plan routes and objectives.

Coordinates per-unit ScenarioTaskRunner and AIAgent to execute authored task chains.

## Public Member Functions

- [`func _ready() -> void`](AIController/functions/_ready.md) — Initialize controller and subscribe to sim engagement events for RETURN_FIRE.
- [`func register_unit(unit_id: int, agent: AIAgent, ordered_tasks: Array[Dictionary]) -> void`](AIController/functions/register_unit.md) — Register a unit's agent and its prebuilt ordered task list.
- [`func unregister_unit(unit_id: int) -> void`](AIController/functions/unregister_unit.md) — Unregister and free the runner/agent for a unit id (idempotent).
- [`func unregister_all_units() -> void`](AIController/functions/unregister_all_units.md) — Remove all registered units and dispose of their agents/runners.
- [`func is_unit_idle(unit_id: int) -> bool`](AIController/functions/is_unit_idle.md) — True if a unit has no active or queued tasks in its runner.
- [`func pause_unit(unit_id: int) -> void`](AIController/functions/pause_unit.md) — Pause the unit's task processing (current task remains active).
- [`func resume_unit(unit_id: int) -> void`](AIController/functions/resume_unit.md) — Resume a paused unit's task processing.
- [`func cancel_active(unit_id: int) -> void`](AIController/functions/cancel_active.md) — Cancel the active task (runner will start the next queued task).
- [`func advance_unit(unit_id: int) -> void`](AIController/functions/advance_unit.md) — Force-advance to the next task in the queue.
- [`func build_per_unit_queues(flat_tasks: Array[Dictionary]) -> Dictionary`](AIController/functions/build_per_unit_queues.md) — Build per-unit ordered queues from a flat list using unit_index and optional links.
- [`func _cmp_by_src_index(a: Dictionary, b: Dictionary) -> bool`](AIController/functions/_cmp_by_src_index.md) — Sort helper to keep original authoring order when no explicit links exist.
- [`func normalize_tasks(flat_tasks: Array) -> Array[Dictionary]`](AIController/functions/normalize_tasks.md) — Normalize ScenarioData.tasks entries (ScenarioTask resources or JSON dicts)
into runner-friendly dictionaries.
- [`func _on_engagement_reported(attacker_id: String, defender_id: String, _damage: float) -> void`](AIController/functions/_on_engagement_reported.md) — SimWorld callback: mark defender as recently attacked and open return-fire window.
- [`func _physics_process(dt: float) -> void`](AIController/functions/_physics_process.md) — Tick all runners (fixed step) and clear expired return-fire marks.
- [`func _apply_initial_blocks_for_unit(unit_id: int) -> void`](AIController/functions/_apply_initial_blocks_for_unit.md)
- [`func _on_trigger_activated(trigger_id: String) -> void`](AIController/functions/_on_trigger_activated.md)
- [`func create_agent(unit_id: int) -> AIAgent`](AIController/functions/create_agent.md) — Instantiate and bind an AIAgent using configured adapters.
- [`func _resolve_context_nodes() -> void`](AIController/functions/_resolve_context_nodes.md)
- [`func _ensure_adapter_cache() -> void`](AIController/functions/_ensure_adapter_cache.md)
- [`func _get_node_from_path(path: NodePath) -> Node`](AIController/functions/_get_node_from_path.md)
- [`func refresh_unit_index_cache() -> void`](AIController/functions/refresh_unit_index_cache.md) — Rebuild the ScenarioUnit id -> index cache for quick lookups.
- [`func apply_trigger_sync(per_unit: Dictionary, triggers: Array) -> void`](AIController/functions/apply_trigger_sync.md) — Register trigger/task sync so tasks stay blocked until trigger activates.
- [`func bind_trigger_engine(engine: TriggerEngine) -> void`](AIController/functions/bind_trigger_engine.md) — Bind TriggerEngine to receive trigger_activated notifications.
- [`func bind_env_behavior_system(_env_sys: Node) -> void`](AIController/functions/bind_env_behavior_system.md) — Bind environment behaviour system signals (placeholder).
- [`func _on_unit_lost(_unit_id: String) -> void`](AIController/functions/_on_unit_lost.md) — Handle unit lost event (placeholder).
- [`func _on_unit_recovered(_unit_id: String) -> void`](AIController/functions/_on_unit_recovered.md) — Handle unit recovered event (placeholder).
- [`func _on_unit_bogged(_unit_id: String) -> void`](AIController/functions/_on_unit_bogged.md) — Handle unit bogged event (placeholder).
- [`func _on_unit_unbogged(_unit_id: String) -> void`](AIController/functions/_on_unit_unbogged.md) — Handle unit unbogged event (placeholder).
- [`func apply_navigation_bias_from_order(_unit_id: String, _bias: StringName) -> void`](AIController/functions/apply_navigation_bias_from_order.md) — Apply navigation bias intent from orders (placeholder).
- [`func _uid_to_index(uid: String) -> int`](AIController/functions/_uid_to_index.md)
- [`func _request_engineer_if_available(unit_index: int) -> void`](AIController/functions/_request_engineer_if_available.md) — Locate an engineer-capable unit and log a support request.
- [`func _emit_radio(level: String, msg: String) -> void`](AIController/functions/_emit_radio.md)

## Public Attributes

- `SimWorld sim_world_ref` — Node references resolved in-scene (preferred over find_child calls).
- `MovementAdapter movement_adapter_ref`
- `CombatAdapter combat_adapter_ref`
- `LOSAdapter los_adapter_ref`
- `OrdersRouter orders_router_ref`
- `Node agents_root_ref`
- `NodePath sim_world_path`
- `NodePath movement_adapter_path`
- `NodePath combat_adapter_path`
- `NodePath los_adapter_path`
- `NodePath orders_router_path`
- `NodePath agents_root_path`
- `float return_fire_window_sec` — Seconds a RETURN_FIRE unit may fire after being attacked.
- `Dictionary _runners` — Active task runners per unit id.
- `Dictionary _agents` — AI agents per unit id.
- `Array _recent_attack_marks` — Temporary return-fire flags: { uid:int, key:String, expire:float }.
- `Dictionary _blocked_triggers` — Trigger id -> Array[Dictionary(unit_id, task_index)].
- `Dictionary _initial_blocks_by_unit` — Unit id -> Array[task_index] (initial blocks before triggers fire).
- `SimWorld _sim` — Cached scene references for adapter injection.
- `MovementAdapter _movement_adapter`
- `CombatAdapter _combat_adapter`
- `LOSAdapter _los_adapter`
- `OrdersRouter _orders_router`
- `Node _agents_root`
- `Dictionary _unit_index_cache` — ScenarioUnit id -> index cache for quick lookup.
- `Node _env_behavior_system`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Initialize controller and subscribe to sim engagement events for RETURN_FIRE.

### register_unit

```gdscript
func register_unit(unit_id: int, agent: AIAgent, ordered_tasks: Array[Dictionary]) -> void
```

Register a unit's agent and its prebuilt ordered task list.
`unit_id` Index in ScenarioData.units.
`agent` AIAgent that will execute intents.
`ordered_tasks` Runner-ready task dictionaries for this unit.

### unregister_unit

```gdscript
func unregister_unit(unit_id: int) -> void
```

Unregister and free the runner/agent for a unit id (idempotent).

### unregister_all_units

```gdscript
func unregister_all_units() -> void
```

Remove all registered units and dispose of their agents/runners.

### is_unit_idle

```gdscript
func is_unit_idle(unit_id: int) -> bool
```

True if a unit has no active or queued tasks in its runner.

### pause_unit

```gdscript
func pause_unit(unit_id: int) -> void
```

Pause the unit's task processing (current task remains active).

### resume_unit

```gdscript
func resume_unit(unit_id: int) -> void
```

Resume a paused unit's task processing.

### cancel_active

```gdscript
func cancel_active(unit_id: int) -> void
```

Cancel the active task (runner will start the next queued task).

### advance_unit

```gdscript
func advance_unit(unit_id: int) -> void
```

Force-advance to the next task in the queue.

### build_per_unit_queues

```gdscript
func build_per_unit_queues(flat_tasks: Array[Dictionary]) -> Dictionary
```

Build per-unit ordered queues from a flat list using unit_index and optional links.
Build per-unit ordered queues from a flat list of ScenarioData.tasks.
Uses unit_index and prev/next_index to form a deterministic chain.
[return] Dictionary: unit_index -> Array[Dictionary] (runner task dicts).

### _cmp_by_src_index

```gdscript
func _cmp_by_src_index(a: Dictionary, b: Dictionary) -> bool
```

Sort helper to keep original authoring order when no explicit links exist.

### normalize_tasks

```gdscript
func normalize_tasks(flat_tasks: Array) -> Array[Dictionary]
```

Normalize ScenarioData.tasks entries (ScenarioTask resources or JSON dicts)
into runner-friendly dictionaries.
Supported task_type: move, defend, patrol, set_behaviour, set_combat_mode, wait
Convert ScenarioTask resources/JSON into runner dictionaries (TaskMove/Defend/...).
Supports: move, defend, patrol (ping_pong, dwell_s, loop_forever), set_behaviour,
set_combat_mode, wait (seconds, until_contact). Positions are terrain meters (Vector2).

### _on_engagement_reported

```gdscript
func _on_engagement_reported(attacker_id: String, defender_id: String, _damage: float) -> void
```

SimWorld callback: mark defender as recently attacked and open return-fire window.

### _physics_process

```gdscript
func _physics_process(dt: float) -> void
```

Tick all runners (fixed step) and clear expired return-fire marks.

### _apply_initial_blocks_for_unit

```gdscript
func _apply_initial_blocks_for_unit(unit_id: int) -> void
```

### _on_trigger_activated

```gdscript
func _on_trigger_activated(trigger_id: String) -> void
```

### create_agent

```gdscript
func create_agent(unit_id: int) -> AIAgent
```

Instantiate and bind an AIAgent using configured adapters.

### _resolve_context_nodes

```gdscript
func _resolve_context_nodes() -> void
```

### _ensure_adapter_cache

```gdscript
func _ensure_adapter_cache() -> void
```

### _get_node_from_path

```gdscript
func _get_node_from_path(path: NodePath) -> Node
```

### refresh_unit_index_cache

```gdscript
func refresh_unit_index_cache() -> void
```

Rebuild the ScenarioUnit id -> index cache for quick lookups.

### apply_trigger_sync

```gdscript
func apply_trigger_sync(per_unit: Dictionary, triggers: Array) -> void
```

Register trigger/task sync so tasks stay blocked until trigger activates.
`per_unit` Dictionary returned from build_per_unit_queues.
`triggers` Scenario triggers.

### bind_trigger_engine

```gdscript
func bind_trigger_engine(engine: TriggerEngine) -> void
```

Bind TriggerEngine to receive trigger_activated notifications.

### bind_env_behavior_system

```gdscript
func bind_env_behavior_system(_env_sys: Node) -> void
```

Bind environment behaviour system signals (placeholder).

### _on_unit_lost

```gdscript
func _on_unit_lost(_unit_id: String) -> void
```

Handle unit lost event (placeholder).

### _on_unit_recovered

```gdscript
func _on_unit_recovered(_unit_id: String) -> void
```

Handle unit recovered event (placeholder).

### _on_unit_bogged

```gdscript
func _on_unit_bogged(_unit_id: String) -> void
```

Handle unit bogged event (placeholder).

### _on_unit_unbogged

```gdscript
func _on_unit_unbogged(_unit_id: String) -> void
```

Handle unit unbogged event (placeholder).

### apply_navigation_bias_from_order

```gdscript
func apply_navigation_bias_from_order(_unit_id: String, _bias: StringName) -> void
```

Apply navigation bias intent from orders (placeholder).

### _uid_to_index

```gdscript
func _uid_to_index(uid: String) -> int
```

### _request_engineer_if_available

```gdscript
func _request_engineer_if_available(unit_index: int) -> void
```

Locate an engineer-capable unit and log a support request.

### _emit_radio

```gdscript
func _emit_radio(level: String, msg: String) -> void
```

## Member Data Documentation

### sim_world_ref

```gdscript
var sim_world_ref: SimWorld
```

Decorators: `@export`

Node references resolved in-scene (preferred over find_child calls).

### movement_adapter_ref

```gdscript
var movement_adapter_ref: MovementAdapter
```

### combat_adapter_ref

```gdscript
var combat_adapter_ref: CombatAdapter
```

### los_adapter_ref

```gdscript
var los_adapter_ref: LOSAdapter
```

### orders_router_ref

```gdscript
var orders_router_ref: OrdersRouter
```

### agents_root_ref

```gdscript
var agents_root_ref: Node
```

### sim_world_path

```gdscript
var sim_world_path: NodePath
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

### agents_root_path

```gdscript
var agents_root_path: NodePath
```

### return_fire_window_sec

```gdscript
var return_fire_window_sec: float
```

Decorators: `@export`

Seconds a RETURN_FIRE unit may fire after being attacked.

### _runners

```gdscript
var _runners: Dictionary
```

Active task runners per unit id.

### _agents

```gdscript
var _agents: Dictionary
```

AI agents per unit id.

### _recent_attack_marks

```gdscript
var _recent_attack_marks: Array
```

Temporary return-fire flags: { uid:int, key:String, expire:float }.

### _blocked_triggers

```gdscript
var _blocked_triggers: Dictionary
```

Trigger id -> Array[Dictionary(unit_id, task_index)].

### _initial_blocks_by_unit

```gdscript
var _initial_blocks_by_unit: Dictionary
```

Unit id -> Array[task_index] (initial blocks before triggers fire).

### _sim

```gdscript
var _sim: SimWorld
```

Cached scene references for adapter injection.

### _movement_adapter

```gdscript
var _movement_adapter: MovementAdapter
```

### _combat_adapter

```gdscript
var _combat_adapter: CombatAdapter
```

### _los_adapter

```gdscript
var _los_adapter: LOSAdapter
```

### _orders_router

```gdscript
var _orders_router: OrdersRouter
```

### _agents_root

```gdscript
var _agents_root: Node
```

### _unit_index_cache

```gdscript
var _unit_index_cache: Dictionary
```

ScenarioUnit id -> index cache for quick lookup.

### _env_behavior_system

```gdscript
var _env_behavior_system: Node
```
