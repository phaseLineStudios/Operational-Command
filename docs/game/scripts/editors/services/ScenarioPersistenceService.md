# ScenarioPersistenceService Class Reference

*File:* `scripts/editors/services/ScenarioPersistenceService.gd`
*Class name:* `ScenarioPersistenceService`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name ScenarioPersistenceService
extends RefCounted
```

## Public Member Functions

- [`func suggest_filename(ctx: ScenarioEditorContext) -> String`](ScenarioPersistenceService/functions/suggest_filename.md)
- [`func ensure_json_ext(p: String) -> String`](ScenarioPersistenceService/functions/ensure_json_ext.md)
- [`func save_to_path(ctx: ScenarioEditorContext, path: String) -> bool`](ScenarioPersistenceService/functions/save_to_path.md)
- [`func load_from_path(ctx: ScenarioEditorContext, path: String) -> bool`](ScenarioPersistenceService/functions/load_from_path.md)

## Public Constants

- `const JSON_FILTER: PackedStringArray`

## Member Function Documentation

### suggest_filename

```gdscript
func suggest_filename(ctx: ScenarioEditorContext) -> String
```

### ensure_json_ext

```gdscript
func ensure_json_ext(p: String) -> String
```

### save_to_path

```gdscript
func save_to_path(ctx: ScenarioEditorContext, path: String) -> bool
```

### load_from_path

```gdscript
func load_from_path(ctx: ScenarioEditorContext, path: String) -> bool
```

## Constant Documentation

### JSON_FILTER

```gdscript
const JSON_FILTER: PackedStringArray
```
