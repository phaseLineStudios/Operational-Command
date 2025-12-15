# PerformanceProfiler::_ready Function Reference

*Defined at:* `scripts/utils/PerformanceProfiler.gd` (lines 6–10)</br>
*Belongs to:* [PerformanceProfiler](../../PerformanceProfiler.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Quick performance profiler to identify bottlenecks
Add to hq_table scene temporarily and press F12 to print stats

## Source

```gdscript
func _ready() -> void:
	print("=== Performance Profiler Active ===")
	print("Press F12 to dump performance stats")
```
