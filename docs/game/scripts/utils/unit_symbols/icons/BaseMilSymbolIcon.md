# BaseMilSymbolIcon Class Reference

*File:* `scripts/utils/unit_symbols/icons/BaseIcon.gd`
*Class name:* `BaseMilSymbolIcon`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name BaseMilSymbolIcon
extends RefCounted
```

## Brief

Represents a MilSymbol Icon

## Public Member Functions

- [`func get_type() -> MilSymbol.UnitType`](BaseMilSymbolIcon/functions/get_type.md) — Retrieve Unit Type.
- [`func get_icon_config(affiliation: MilSymbol.UnitAffiliation) -> Dictionary`](BaseMilSymbolIcon/functions/get_icon_config.md) — Retrieve Icon config.
- [`func _get_friendly_icon() -> Dictionary`](BaseMilSymbolIcon/functions/_get_friendly_icon.md) — Get friendly icon (overrideable).
- [`func _get_enemy_icon() -> Dictionary`](BaseMilSymbolIcon/functions/_get_enemy_icon.md) — Get enemy icon (overrideable).
- [`func _get_neutral_icon() -> Dictionary`](BaseMilSymbolIcon/functions/_get_neutral_icon.md) — Get neutral icon (overrideable).
- [`func _get_unknown_icon() -> Dictionary`](BaseMilSymbolIcon/functions/_get_unknown_icon.md) — Get unknown icon (overrideable).
- [`func _get_default_icon() -> Dictionary`](BaseMilSymbolIcon/functions/_get_default_icon.md) — Get default icon (overrideable).

## Member Function Documentation

### get_type

```gdscript
func get_type() -> MilSymbol.UnitType
```

Retrieve Unit Type.
[return] Unit Type.

### get_icon_config

```gdscript
func get_icon_config(affiliation: MilSymbol.UnitAffiliation) -> Dictionary
```

Retrieve Icon config.
[return] Dictionary of icon config.

### _get_friendly_icon

```gdscript
func _get_friendly_icon() -> Dictionary
```

Get friendly icon (overrideable).
[return] Dictionary of icon config.

### _get_enemy_icon

```gdscript
func _get_enemy_icon() -> Dictionary
```

Get enemy icon (overrideable).
[return] Dictionary of icon config.

### _get_neutral_icon

```gdscript
func _get_neutral_icon() -> Dictionary
```

Get neutral icon (overrideable).
[return] Dictionary of icon config.

### _get_unknown_icon

```gdscript
func _get_unknown_icon() -> Dictionary
```

Get unknown icon (overrideable).
[return] Dictionary of icon config.

### _get_default_icon

```gdscript
func _get_default_icon() -> Dictionary
```

Get default icon (overrideable).
[return] Dictionary of icon config.
