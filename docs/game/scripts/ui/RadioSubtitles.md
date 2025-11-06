# RadioSubtitles Class Reference

*File:* `scripts/ui/RadioSubtitles.gd`
*Inherits:* `Control`

## Synopsis

```gdscript
extends Control
```

## Brief

Displays radio subtitles and suggests valid next words based on current input.

## Detailed Description

Shows partial speech recognition results and provides intelligent suggestions
for completing valid radio commands using NARules tables.

## Public Member Functions

- [`func _ready() -> void`](RadioSubtitles/functions/_ready.md)
- [`func show_partial(text: String) -> void`](RadioSubtitles/functions/show_partial.md) — Show subtitle with current partial text
- [`func show_result(text: String) -> void`](RadioSubtitles/functions/show_result.md) — Show final result text
- [`func hide_subtitles() -> void`](RadioSubtitles/functions/hide_subtitles.md) — Hide the subtitle display
- [`func set_terrain_labels(labels: Array[String]) -> void`](RadioSubtitles/functions/set_terrain_labels.md) — Set terrain labels for suggestions
- [`func set_unit_callsigns(callsigns: Array[String]) -> void`](RadioSubtitles/functions/set_unit_callsigns.md) — Set unit callsigns for suggestions
- [`func _update_display() -> void`](RadioSubtitles/functions/_update_display.md) — Update the display with current text and suggestions
- [`func _update_suggestions() -> void`](RadioSubtitles/functions/_update_suggestions.md) — Analyze current text and generate suggestions for next word
- [`func _clear_suggestions() -> void`](RadioSubtitles/functions/_clear_suggestions.md) — Clear all suggestions
- [`func _generate_suggestions(tokens: PackedStringArray) -> Array[String]`](RadioSubtitles/functions/_generate_suggestions.md) — Generate suggestions based on current token state
- [`func _suggest_for_move(state: Dictionary, last_token: String) -> Array[String]`](RadioSubtitles/functions/_suggest_for_move.md) — Contextual suggestions for MOVE command
- [`func _suggest_for_fire(state: Dictionary, last_token: String) -> Array[String]`](RadioSubtitles/functions/_suggest_for_fire.md) — Contextual suggestions for FIRE command
- [`func _suggest_for_defend_recon(state: Dictionary, last_token: String) -> Array[String]`](RadioSubtitles/functions/_suggest_for_defend_recon.md) — Contextual suggestions for DEFEND/RECON commands
- [`func _suggest_for_report(_state: Dictionary, _last_token: String) -> Array[String]`](RadioSubtitles/functions/_suggest_for_report.md) — Suggestions for REPORT command
- [`func _analyze_tokens(tokens: PackedStringArray) -> Dictionary`](RadioSubtitles/functions/_analyze_tokens.md) — Analyze tokens to determine current order state
- [`func _get_callsign_suggestions() -> Array[String]`](RadioSubtitles/functions/_get_callsign_suggestions.md) — Get callsign suggestions
- [`func _get_action_suggestions() -> Array[String]`](RadioSubtitles/functions/_get_action_suggestions.md) — Get action suggestions
- [`func _get_direction_suggestions() -> Array[String]`](RadioSubtitles/functions/_get_direction_suggestions.md) — Get direction suggestions
- [`func _get_quantity_suggestions() -> Array[String]`](RadioSubtitles/functions/_get_quantity_suggestions.md) — Get quantity suggestions (numbers and units)
- [`func _get_terrain_label_suggestions() -> Array[String]`](RadioSubtitles/functions/_get_terrain_label_suggestions.md) — Get terrain label suggestions
- [`func _get_unit_callsign_suggestions() -> Array[String]`](RadioSubtitles/functions/_get_unit_callsign_suggestions.md) — Get unit callsign suggestions (for targeting)
- [`func _get_grid_coordinate_suggestions() -> Array[String]`](RadioSubtitles/functions/_get_grid_coordinate_suggestions.md) — Get grid coordinate suggestions (6 and 8 digit)
- [`func _is_number_word(token: String) -> bool`](RadioSubtitles/functions/_is_number_word.md) — Check if a token is a number word
- [`func _normalize_and_tokenize(text: String) -> PackedStringArray`](RadioSubtitles/functions/_normalize_and_tokenize.md) — Normalize and tokenize text (same as OrdersParser)
- [`func _is_ascii_alpha_cp(cp: int) -> bool`](RadioSubtitles/functions/_is_ascii_alpha_cp.md) — ASCII alpha test
- [`func _is_ascii_digit_cp(cp: int) -> bool`](RadioSubtitles/functions/_is_ascii_digit_cp.md) — ASCII digit test
- [`func _deduplicate(arr: Array[String]) -> Array[String]`](RadioSubtitles/functions/_deduplicate.md) — Deduplicate array
- [`func _on_hide_timer_timeout() -> void`](RadioSubtitles/functions/_on_hide_timer_timeout.md) — Handle hide timer timeout
- [`func _convert_numbers_to_digits(text: String) -> String`](RadioSubtitles/functions/_convert_numbers_to_digits.md) — Convert number words to digits in text (e.g., "five hundred" -> "500")
- [`func _read_number_sequence(tokens: Array, idx: int, number_words: Dictionary) -> Dictionary`](RadioSubtitles/functions/_read_number_sequence.md) — Read a number sequence from tokens and return the value
- [`func _is_all_digits(s: String) -> bool`](RadioSubtitles/functions/_is_all_digits.md) — Check if string is all digits

## Public Attributes

- `float result_display_time` — Display time for result text after PTT release (in seconds)
- `int max_suggestions` — Maximum number of suggestions to show
- `Dictionary _tables`
- `Timer _hide_timer`
- `String _current_text`
- `bool _is_transmitting`
- `Array[String] _terrain_labels`
- `Array[String] _unit_callsigns`
- `Label _subtitle_label`
- `HBoxContainer _suggestions_container`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### show_partial

```gdscript
func show_partial(text: String) -> void
```

Show subtitle with current partial text

### show_result

```gdscript
func show_result(text: String) -> void
```

Show final result text

### hide_subtitles

```gdscript
func hide_subtitles() -> void
```

Hide the subtitle display

### set_terrain_labels

```gdscript
func set_terrain_labels(labels: Array[String]) -> void
```

Set terrain labels for suggestions

### set_unit_callsigns

```gdscript
func set_unit_callsigns(callsigns: Array[String]) -> void
```

Set unit callsigns for suggestions

### _update_display

```gdscript
func _update_display() -> void
```

Update the display with current text and suggestions

### _update_suggestions

```gdscript
func _update_suggestions() -> void
```

Analyze current text and generate suggestions for next word

### _clear_suggestions

```gdscript
func _clear_suggestions() -> void
```

Clear all suggestions

### _generate_suggestions

```gdscript
func _generate_suggestions(tokens: PackedStringArray) -> Array[String]
```

Generate suggestions based on current token state

### _suggest_for_move

```gdscript
func _suggest_for_move(state: Dictionary, last_token: String) -> Array[String]
```

Contextual suggestions for MOVE command

### _suggest_for_fire

```gdscript
func _suggest_for_fire(state: Dictionary, last_token: String) -> Array[String]
```

Contextual suggestions for FIRE command

### _suggest_for_defend_recon

```gdscript
func _suggest_for_defend_recon(state: Dictionary, last_token: String) -> Array[String]
```

Contextual suggestions for DEFEND/RECON commands

### _suggest_for_report

```gdscript
func _suggest_for_report(_state: Dictionary, _last_token: String) -> Array[String]
```

Suggestions for REPORT command

### _analyze_tokens

```gdscript
func _analyze_tokens(tokens: PackedStringArray) -> Dictionary
```

Analyze tokens to determine current order state

### _get_callsign_suggestions

```gdscript
func _get_callsign_suggestions() -> Array[String]
```

Get callsign suggestions

### _get_action_suggestions

```gdscript
func _get_action_suggestions() -> Array[String]
```

Get action suggestions

### _get_direction_suggestions

```gdscript
func _get_direction_suggestions() -> Array[String]
```

Get direction suggestions

### _get_quantity_suggestions

```gdscript
func _get_quantity_suggestions() -> Array[String]
```

Get quantity suggestions (numbers and units)

### _get_terrain_label_suggestions

```gdscript
func _get_terrain_label_suggestions() -> Array[String]
```

Get terrain label suggestions

### _get_unit_callsign_suggestions

```gdscript
func _get_unit_callsign_suggestions() -> Array[String]
```

Get unit callsign suggestions (for targeting)

### _get_grid_coordinate_suggestions

```gdscript
func _get_grid_coordinate_suggestions() -> Array[String]
```

Get grid coordinate suggestions (6 and 8 digit)

### _is_number_word

```gdscript
func _is_number_word(token: String) -> bool
```

Check if a token is a number word

### _normalize_and_tokenize

```gdscript
func _normalize_and_tokenize(text: String) -> PackedStringArray
```

Normalize and tokenize text (same as OrdersParser)

### _is_ascii_alpha_cp

```gdscript
func _is_ascii_alpha_cp(cp: int) -> bool
```

ASCII alpha test

### _is_ascii_digit_cp

```gdscript
func _is_ascii_digit_cp(cp: int) -> bool
```

ASCII digit test

### _deduplicate

```gdscript
func _deduplicate(arr: Array[String]) -> Array[String]
```

Deduplicate array

### _on_hide_timer_timeout

```gdscript
func _on_hide_timer_timeout() -> void
```

Handle hide timer timeout

### _convert_numbers_to_digits

```gdscript
func _convert_numbers_to_digits(text: String) -> String
```

Convert number words to digits in text (e.g., "five hundred" -> "500")

### _read_number_sequence

```gdscript
func _read_number_sequence(tokens: Array, idx: int, number_words: Dictionary) -> Dictionary
```

Read a number sequence from tokens and return the value

### _is_all_digits

```gdscript
func _is_all_digits(s: String) -> bool
```

Check if string is all digits

## Member Data Documentation

### result_display_time

```gdscript
var result_display_time: float
```

Decorators: `@export`

Display time for result text after PTT release (in seconds)

### max_suggestions

```gdscript
var max_suggestions: int
```

Decorators: `@export`

Maximum number of suggestions to show

### _tables

```gdscript
var _tables: Dictionary
```

### _hide_timer

```gdscript
var _hide_timer: Timer
```

### _current_text

```gdscript
var _current_text: String
```

### _is_transmitting

```gdscript
var _is_transmitting: bool
```

### _terrain_labels

```gdscript
var _terrain_labels: Array[String]
```

### _unit_callsigns

```gdscript
var _unit_callsigns: Array[String]
```

### _subtitle_label

```gdscript
var _subtitle_label: Label
```

### _suggestions_container

```gdscript
var _suggestions_container: HBoxContainer
```
