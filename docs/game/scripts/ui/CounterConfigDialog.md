# CounterConfigDialog Class Reference

*File:* `scripts/ui/CounterConfigDialog.gd`
*Class name:* `CounterConfigDialog`
*Inherits:* `Window`
> **Experimental**

## Synopsis

```gdscript
class_name CounterConfigDialog
extends Window
```

## Brief

Dialog for creating unit counters with specified parameters

## Public Member Functions

- [`func _ready() -> void`](CounterConfigDialog/functions/_ready.md)
- [`func _populate_affiliation() -> void`](CounterConfigDialog/functions/_populate_affiliation.md)
- [`func _populate_types() -> void`](CounterConfigDialog/functions/_populate_types.md)
- [`func _populate_sizes() -> void`](CounterConfigDialog/functions/_populate_sizes.md)
- [`func _on_create_pressed() -> void`](CounterConfigDialog/functions/_on_create_pressed.md)

## Public Attributes

- `OptionButton affiliation`
- `OptionButton type`
- `OptionButton unit_size`
- `LineEdit callsign`
- `Button close_btn`
- `Button create_btn`

## Signals

- `signal counter_create_requested` — Emitted when the user requests to create a counter

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _populate_affiliation

```gdscript
func _populate_affiliation() -> void
```

### _populate_types

```gdscript
func _populate_types() -> void
```

### _populate_sizes

```gdscript
func _populate_sizes() -> void
```

### _on_create_pressed

```gdscript
func _on_create_pressed() -> void
```

## Member Data Documentation

### affiliation

```gdscript
var affiliation: OptionButton
```

### type

```gdscript
var type: OptionButton
```

### unit_size

```gdscript
var unit_size: OptionButton
```

### callsign

```gdscript
var callsign: LineEdit
```

### close_btn

```gdscript
var close_btn: Button
```

### create_btn

```gdscript
var create_btn: Button
```

## Signal Documentation

### counter_create_requested

```gdscript
signal counter_create_requested
```

Emitted when the user requests to create a counter
