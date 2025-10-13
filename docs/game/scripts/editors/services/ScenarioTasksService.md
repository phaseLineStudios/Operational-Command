# ScenarioTasksService Class Reference

*File:* `scripts/editors/services/ScenarioTasksService.gd`
*Class name:* `ScenarioTasksService`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name ScenarioTasksService
extends RefCounted
```

## Public Member Functions

- [`func setup(ctx: ScenarioEditorContext) -> void`](ScenarioTasksService/functions/setup.md)
- [`func _init_defs() -> void`](ScenarioTasksService/functions/_init_defs.md)
- [`func _build_list(ctx: ScenarioEditorContext) -> void`](ScenarioTasksService/functions/_build_list.md)
- [`func _on_selected(ctx: ScenarioEditorContext, index: int) -> void`](ScenarioTasksService/functions/_on_selected.md)
- [`func collect_unit_chain(data: ScenarioData, unit_index: int) -> Array[int]`](ScenarioTasksService/functions/collect_unit_chain.md)
- [`func make_task_title(inst: ScenarioTask, idx_in_chain: int) -> String`](ScenarioTasksService/functions/make_task_title.md)
- [`func _gen_task_id(ctx: ScenarioEditorContext, type_id: StringName) -> String`](ScenarioTasksService/functions/_gen_task_id.md)
- [`func _find_tail(tasks: Array, unit_index: int) -> int`](ScenarioTasksService/functions/_find_tail.md)
- [`func _snap(ctx: ScenarioEditorContext) -> Dictionary`](ScenarioTasksService/functions/_snap.md)

## Public Attributes

- `Array[UnitBaseTask] defs`
- `UnitBaseTask selected_def`
- `ScenarioTask after_ref`
- `int new_idx`

## Member Function Documentation

### setup

```gdscript
func setup(ctx: ScenarioEditorContext) -> void
```

### _init_defs

```gdscript
func _init_defs() -> void
```

### _build_list

```gdscript
func _build_list(ctx: ScenarioEditorContext) -> void
```

### _on_selected

```gdscript
func _on_selected(ctx: ScenarioEditorContext, index: int) -> void
```

### collect_unit_chain

```gdscript
func collect_unit_chain(data: ScenarioData, unit_index: int) -> Array[int]
```

### make_task_title

```gdscript
func make_task_title(inst: ScenarioTask, idx_in_chain: int) -> String
```

### _gen_task_id

```gdscript
func _gen_task_id(ctx: ScenarioEditorContext, type_id: StringName) -> String
```

### _find_tail

```gdscript
func _find_tail(tasks: Array, unit_index: int) -> int
```

### _snap

```gdscript
func _snap(ctx: ScenarioEditorContext) -> Dictionary
```

## Member Data Documentation

### defs

```gdscript
var defs: Array[UnitBaseTask]
```

### selected_def

```gdscript
var selected_def: UnitBaseTask
```

### after_ref

```gdscript
var after_ref: ScenarioTask
```

### new_idx

```gdscript
var new_idx: int
```
