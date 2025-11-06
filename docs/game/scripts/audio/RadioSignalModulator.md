# RadioSignalModulator Class Reference

*File:* `scripts/audio/RadioSignalModulator.gd`
*Class name:* `RadioSignalModulator`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name RadioSignalModulator
extends Node
```

## Brief

Modulates Radio bus effects to simulate signal strength variation.

## Detailed Description

Creates realistic radio fading, interference, and signal dropout.

## Public Member Functions

- [`func _ready() -> void`](RadioSignalModulator/functions/_ready.md)
- [`func _process(delta: float) -> void`](RadioSignalModulator/functions/_process.md)

## Public Attributes

- `float min_signal_strength` — Signal strength variation parameters
- `float max_signal_strength`
- `float fade_speed`
- `float interference_chance`
- `int _radio_bus_idx` — Radio bus index
- `int _lowpass_idx` — Effect indices on the Radio bus
- `int _distortion_idx`
- `float _signal_strength` — Current signal strength (0.0 to 1.0)
- `float _target_strength` — Target signal strength
- `float _interference_timer` — Interference accumulator

## Public Constants

- `const BASE_LOWPASS_CUTOFF: float` — Base effect values
- `const BASE_DISTORTION_DRIVE: float`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _process

```gdscript
func _process(delta: float) -> void
```

## Member Data Documentation

### min_signal_strength

```gdscript
var min_signal_strength: float
```

Decorators: `@export`

Signal strength variation parameters

### max_signal_strength

```gdscript
var max_signal_strength: float
```

### fade_speed

```gdscript
var fade_speed: float
```

### interference_chance

```gdscript
var interference_chance: float
```

### _radio_bus_idx

```gdscript
var _radio_bus_idx: int
```

Radio bus index

### _lowpass_idx

```gdscript
var _lowpass_idx: int
```

Effect indices on the Radio bus

### _distortion_idx

```gdscript
var _distortion_idx: int
```

### _signal_strength

```gdscript
var _signal_strength: float
```

Current signal strength (0.0 to 1.0)

### _target_strength

```gdscript
var _target_strength: float
```

Target signal strength

### _interference_timer

```gdscript
var _interference_timer: float
```

Interference accumulator

## Constant Documentation

### BASE_LOWPASS_CUTOFF

```gdscript
const BASE_LOWPASS_CUTOFF: float
```

Base effect values

### BASE_DISTORTION_DRIVE

```gdscript
const BASE_DISTORTION_DRIVE: float
```
