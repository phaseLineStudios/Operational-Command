# DebugMetricsDisplay Class Reference

*File:* `scripts/ui/DebugMetricsDisplay.gd`
*Class name:* `DebugMetricsDisplay`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name DebugMetricsDisplay
extends Control
```

## Brief

Debug menu display style

## Detailed Description

Returns the sum of all values of an array (use as a parameter to `Array.reduce()`)

## Public Member Functions

- [`func _init() -> void`](DebugMetricsDisplay/functions/_init.md)
- [`func _ready() -> void`](DebugMetricsDisplay/functions/_ready.md)
- [`func _exit_tree() -> void`](DebugMetricsDisplay/functions/_exit_tree.md)
- [`func update_settings_label() -> void`](DebugMetricsDisplay/functions/update_settings_label.md) — Update hardware information label
- [`func update_information_label() -> void`](DebugMetricsDisplay/functions/update_information_label.md) — Update hardware/software information label
- [`func _fps_graph_draw() -> void`](DebugMetricsDisplay/functions/_fps_graph_draw.md)
- [`func _total_graph_draw() -> void`](DebugMetricsDisplay/functions/_total_graph_draw.md)
- [`func _cpu_graph_draw() -> void`](DebugMetricsDisplay/functions/_cpu_graph_draw.md)
- [`func _gpu_graph_draw() -> void`](DebugMetricsDisplay/functions/_gpu_graph_draw.md)
- [`func _process(_delta: float) -> void`](DebugMetricsDisplay/functions/_process.md)
- [`func _on_visibility_changed() -> void`](DebugMetricsDisplay/functions/_on_visibility_changed.md)

## Public Attributes

- `Array[float] frame_history_total`
- `Array[float] frame_history_cpu`
- `Array[float] frame_history_gpu`
- `Array[float] fps_history`
- `Label fps`
- `Label frame_time`
- `Label frame_number`
- `GridContainer frame_history`
- `Label frame_history_total_avg`
- `Label frame_history_total_min`
- `Label frame_history_total_max`
- `Label frame_history_total_last`
- `Label frame_history_cpu_avg`
- `Label frame_history_cpu_min`
- `Label frame_history_cpu_max`
- `Label frame_history_cpu_last`
- `Label frame_history_gpu_avg`
- `Label frame_history_gpu_min`
- `Label frame_history_gpu_max`
- `Label frame_history_gpu_last`
- `HBoxContainer fps_graph_container`
- `Panel fps_graph`
- `HBoxContainer total_graph_container`
- `Panel total_graph`
- `HBoxContainer cpu_graph_container`
- `Panel cpu_graph`
- `HBoxContainer gpu_graph_container`
- `Panel gpu_graph`
- `Label information`
- `Label settings`

## Public Constants

- `const HISTORY_NUM_FRAMES` — The number of frames to keep in history for graph drawing and best/worst calculations
- `const GRAPH_SIZE`
- `const GRAPH_MIN_FPS`
- `const GRAPH_MAX_FPS`
- `const GRAPH_MIN_FRAMETIME`
- `const GRAPH_MAX_FRAMETIME`

## Member Function Documentation

### _init

```gdscript
func _init() -> void
```

### _ready

```gdscript
func _ready() -> void
```

### _exit_tree

```gdscript
func _exit_tree() -> void
```

### update_settings_label

```gdscript
func update_settings_label() -> void
```

Update hardware information label

### update_information_label

```gdscript
func update_information_label() -> void
```

Update hardware/software information label

### _fps_graph_draw

```gdscript
func _fps_graph_draw() -> void
```

### _total_graph_draw

```gdscript
func _total_graph_draw() -> void
```

### _cpu_graph_draw

```gdscript
func _cpu_graph_draw() -> void
```

### _gpu_graph_draw

```gdscript
func _gpu_graph_draw() -> void
```

### _process

```gdscript
func _process(_delta: float) -> void
```

### _on_visibility_changed

```gdscript
func _on_visibility_changed() -> void
```

## Member Data Documentation

### frame_history_total

```gdscript
var frame_history_total: Array[float]
```

### frame_history_cpu

```gdscript
var frame_history_cpu: Array[float]
```

### frame_history_gpu

```gdscript
var frame_history_gpu: Array[float]
```

### fps_history

```gdscript
var fps_history: Array[float]
```

### fps

```gdscript
var fps: Label
```

### frame_time

```gdscript
var frame_time: Label
```

### frame_number

```gdscript
var frame_number: Label
```

### frame_history

```gdscript
var frame_history: GridContainer
```

### frame_history_total_avg

```gdscript
var frame_history_total_avg: Label
```

### frame_history_total_min

```gdscript
var frame_history_total_min: Label
```

### frame_history_total_max

```gdscript
var frame_history_total_max: Label
```

### frame_history_total_last

```gdscript
var frame_history_total_last: Label
```

### frame_history_cpu_avg

```gdscript
var frame_history_cpu_avg: Label
```

### frame_history_cpu_min

```gdscript
var frame_history_cpu_min: Label
```

### frame_history_cpu_max

```gdscript
var frame_history_cpu_max: Label
```

### frame_history_cpu_last

```gdscript
var frame_history_cpu_last: Label
```

### frame_history_gpu_avg

```gdscript
var frame_history_gpu_avg: Label
```

### frame_history_gpu_min

```gdscript
var frame_history_gpu_min: Label
```

### frame_history_gpu_max

```gdscript
var frame_history_gpu_max: Label
```

### frame_history_gpu_last

```gdscript
var frame_history_gpu_last: Label
```

### fps_graph_container

```gdscript
var fps_graph_container: HBoxContainer
```

### fps_graph

```gdscript
var fps_graph: Panel
```

### total_graph_container

```gdscript
var total_graph_container: HBoxContainer
```

### total_graph

```gdscript
var total_graph: Panel
```

### cpu_graph_container

```gdscript
var cpu_graph_container: HBoxContainer
```

### cpu_graph

```gdscript
var cpu_graph: Panel
```

### gpu_graph_container

```gdscript
var gpu_graph_container: HBoxContainer
```

### gpu_graph

```gdscript
var gpu_graph: Panel
```

### information

```gdscript
var information: Label
```

### settings

```gdscript
var settings: Label
```

## Constant Documentation

### HISTORY_NUM_FRAMES

```gdscript
const HISTORY_NUM_FRAMES
```

The number of frames to keep in history for graph drawing and best/worst calculations

### GRAPH_SIZE

```gdscript
const GRAPH_SIZE
```

### GRAPH_MIN_FPS

```gdscript
const GRAPH_MIN_FPS
```

### GRAPH_MAX_FPS

```gdscript
const GRAPH_MAX_FPS
```

### GRAPH_MIN_FRAMETIME

```gdscript
const GRAPH_MIN_FRAMETIME
```

### GRAPH_MAX_FRAMETIME

```gdscript
const GRAPH_MAX_FRAMETIME
```
