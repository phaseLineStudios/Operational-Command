# PerformanceProfiler Class Reference

*File:* `scripts/utils/PerformanceProfiler.gd`
*Inherits:* `Node`

## Synopsis

```gdscript
extends Node
```

## Public Member Functions

- [`func _ready() -> void`](PerformanceProfiler/functions/_ready.md) — Quick performance profiler to identify bottlenecks
- [`func _process(_delta: float) -> void`](PerformanceProfiler/functions/_process.md)
- [`func _print_stats() -> void`](PerformanceProfiler/functions/_print_stats.md)
- [`func _count_nodes(node: Node) -> int`](PerformanceProfiler/functions/_count_nodes.md)
- [`func _count_meshes(node: Node) -> int`](PerformanceProfiler/functions/_count_meshes.md)

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Quick performance profiler to identify bottlenecks
Add to hq_table scene temporarily and press F12 to print stats

### _process

```gdscript
func _process(_delta: float) -> void
```

### _print_stats

```gdscript
func _print_stats() -> void
```

### _count_nodes

```gdscript
func _count_nodes(node: Node) -> int
```

### _count_meshes

```gdscript
func _count_meshes(node: Node) -> int
```
