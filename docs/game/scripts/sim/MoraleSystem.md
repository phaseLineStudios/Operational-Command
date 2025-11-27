# MoraleSystem Class Reference

*File:* `scripts/sim/MoraleSystem.gd`
*Class name:* `MoraleSystem`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name MoraleSystem
extends RefCounted
```

## Public Member Functions

- [`func _init(u_id: String = "", u_owner: ScenarioUnit = null) -> void`](MoraleSystem/functions/_init.md) — sets value of id variables
- [`func get_morale() -> float`](MoraleSystem/functions/get_morale.md) — returns the raw moralevalue
- [`func set_morale(value: float, source: String = "direct") -> void`](MoraleSystem/functions/set_morale.md) — changes moralevalue to a new value
- [`func apply_morale_delta(delta: float, source: String = "delta") -> void`](MoraleSystem/functions/apply_morale_delta.md) — changes morale value
- [`func get_morale_state(value: float = morale) -> int`](MoraleSystem/functions/get_morale_state.md) — returns moralestate based on morale value
- [`func is_broken() -> bool`](MoraleSystem/functions/is_broken.md) — bool to see if morealstate is broken
- [`func tick(dt: float) -> void`](MoraleSystem/functions/tick.md) — applies overtime moralechanges
- [`func nearby_ally_morale_change(amount: float = 0.0, source: String = "nearby victory") -> void`](MoraleSystem/functions/nearby_ally_morale_change.md) — applies morale boost to nearby units
- [`func morale_effectiveness_mul() -> float`](MoraleSystem/functions/morale_effectiveness_mul.md) — returns morale multiplier based on moralestate
- [`func safe_rest() -> void`](MoraleSystem/functions/safe_rest.md) — gains morale if no enemies nearby

## Public Attributes

- `String  ##id of unit unit_id`
- `float morale`
- `int morale_state`
- `ScenarioUnit  ##unit connected to the script owner`
- `ScenarioData  ##points to current scenario to check weather scenario`

## Signals

- `signal morale_changed(unit_id, prev, cur, source)` — Morale system for units
- `signal morale_state_changed(unit_id, prev, cur)`

## Enumerations

- `enum MoraleState`

## Member Function Documentation

### _init

```gdscript
func _init(u_id: String = "", u_owner: ScenarioUnit = null) -> void
```

sets value of id variables

### get_morale

```gdscript
func get_morale() -> float
```

returns the raw moralevalue

### set_morale

```gdscript
func set_morale(value: float, source: String = "direct") -> void
```

changes moralevalue to a new value

### apply_morale_delta

```gdscript
func apply_morale_delta(delta: float, source: String = "delta") -> void
```

changes morale value

### get_morale_state

```gdscript
func get_morale_state(value: float = morale) -> int
```

returns moralestate based on morale value

### is_broken

```gdscript
func is_broken() -> bool
```

bool to see if morealstate is broken

### tick

```gdscript
func tick(dt: float) -> void
```

applies overtime moralechanges

### nearby_ally_morale_change

```gdscript
func nearby_ally_morale_change(amount: float = 0.0, source: String = "nearby victory") -> void
```

applies morale boost to nearby units

### morale_effectiveness_mul

```gdscript
func morale_effectiveness_mul() -> float
```

returns morale multiplier based on moralestate

### safe_rest

```gdscript
func safe_rest() -> void
```

gains morale if no enemies nearby

## Member Data Documentation

### unit_id

```gdscript
var unit_id: String  ##id of unit
```

### morale

```gdscript
var morale: float
```

### morale_state

```gdscript
var morale_state: int
```

### owner

```gdscript
var owner: ScenarioUnit  ##unit connected to the script
```

### scenario

```gdscript
var scenario: ScenarioData  ##points to current scenario to check weather
```

## Signal Documentation

### morale_changed

```gdscript
signal morale_changed(unit_id, prev, cur, source)
```

Morale system for units
handles changes in morale and decay of morale over time

### morale_state_changed

```gdscript
signal morale_state_changed(unit_id, prev, cur)
```

## Enumeration Type Documentation

### MoraleState

```gdscript
enum MoraleState
```
