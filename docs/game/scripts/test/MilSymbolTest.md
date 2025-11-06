# MilSymbolTest Class Reference

*File:* `scripts/test/MilSymbolTest.gd`
*Inherits:* `Control`

## Synopsis

```gdscript
extends Control
```

## Brief

Test script for MilSymbol generator

## Detailed Description

Demonstrates how to create and display military symbols

## Public Member Functions

- [`func _ready() -> void`](MilSymbolTest/functions/_ready.md)
- [`func _input(event: InputEvent) -> void`](MilSymbolTest/functions/_input.md) — Handle Enter for designation and arrow-key selection for focused OptionButtons.
- [`func _change_option_selection(ob: OptionButton, delta: int) -> void`](MilSymbolTest/functions/_change_option_selection.md) — Increment/decrement selection on an OptionButton and emit item_selected.
- [`func _generate_symbols() -> void`](MilSymbolTest/functions/_generate_symbols.md) — Generate all test symbols and display them in a grid
- [`func _on_refresh() -> void`](MilSymbolTest/functions/_on_refresh.md) — Called when refresh button is clicked.
- [`func _refresh_options() -> void`](MilSymbolTest/functions/_refresh_options.md) — Refreshes option buttons.

## Public Attributes

- `MilSymbolConfig config`
- `MilSymbol generator`
- `OptionButton u_type`
- `OptionButton u_size`
- `OptionButton u_modifier_1`
- `OptionButton u_modifier_2`
- `LineEdit u_designation`
- `OptionButton u_status`
- `OptionButton u_reinforced_reduced`
- `CheckBox u_frame`
- `Button refresh_btn`

## Public Constants

- `const SYMBOLS_PER_ROW: int` — Grid layout settings
- `const SYMBOL_SPACING: int`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _input

```gdscript
func _input(event: InputEvent) -> void
```

Handle Enter for designation and arrow-key selection for focused OptionButtons.

### _change_option_selection

```gdscript
func _change_option_selection(ob: OptionButton, delta: int) -> void
```

Increment/decrement selection on an OptionButton and emit item_selected.
`ob` The OptionButton to change.
`delta` +1 to move down/right, -1 to move up/left.

### _generate_symbols

```gdscript
func _generate_symbols() -> void
```

Generate all test symbols and display them in a grid

### _on_refresh

```gdscript
func _on_refresh() -> void
```

Called when refresh button is clicked.

### _refresh_options

```gdscript
func _refresh_options() -> void
```

Refreshes option buttons.

## Member Data Documentation

### config

```gdscript
var config: MilSymbolConfig
```

### generator

```gdscript
var generator: MilSymbol
```

### u_type

```gdscript
var u_type: OptionButton
```

### u_size

```gdscript
var u_size: OptionButton
```

### u_modifier_1

```gdscript
var u_modifier_1: OptionButton
```

### u_modifier_2

```gdscript
var u_modifier_2: OptionButton
```

### u_designation

```gdscript
var u_designation: LineEdit
```

### u_status

```gdscript
var u_status: OptionButton
```

### u_reinforced_reduced

```gdscript
var u_reinforced_reduced: OptionButton
```

### u_frame

```gdscript
var u_frame: CheckBox
```

### refresh_btn

```gdscript
var refresh_btn: Button
```

## Constant Documentation

### SYMBOLS_PER_ROW

```gdscript
const SYMBOLS_PER_ROW: int
```

Grid layout settings

### SYMBOL_SPACING

```gdscript
const SYMBOL_SPACING: int
```
