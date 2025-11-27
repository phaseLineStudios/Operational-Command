# NARules Class Reference

*File:* `scripts/radio/NARules.gd`
*Inherits:* `Node`

## Synopsis

```gdscript
extends Node
```

## Brief

Set mission-specific overrides for custom actions and extra words.

## Detailed Description

Merges custom action keywords into `action_synonyms` table and adds
extra words to Vosk grammar for better STT recognition.
  
  

**Called automatically by SimWorld._init_custom_commands() during mission init.**
`custom_actions` Dictionary mapping keyword -> OrderType (or any int).
Added to action_synonyms. `extra_words` Array of additional words to recognize in STT
(keywords + additional_grammar).

Build a deduped list of grammar words (and phrases) with mission overrides.

Build and return Vosk grammar JSON with mission overrides.

## Public Member Functions

- [`func clear_mission_overrides() -> void`](NARules/functions/clear_mission_overrides.md) — Clear mission overrides (call when leaving a mission).
- [`func get_parser_tables() -> Dictionary`](NARules/functions/get_parser_tables.md) — Build and return the parser table

## Public Attributes

- `Dictionary _mission_overrides` — NATO radio phrasebook, callsigns, and grammar helpers.
- `Array[String] words`
- `Array calls`
- `Dictionary qlbl`
- `Array extra`
- `Array[String] out`

## Member Function Documentation

### clear_mission_overrides

```gdscript
func clear_mission_overrides() -> void
```

Clear mission overrides (call when leaving a mission).
Should be called on mission end to reset grammar to defaults.

### get_parser_tables

```gdscript
func get_parser_tables() -> Dictionary
```

Build and return the parser table

## Member Data Documentation

### _mission_overrides

```gdscript
var _mission_overrides: Dictionary
```

NATO radio phrasebook, callsigns, and grammar helpers.

Provides tables and pattern helpers for validating and assisting the
construction of voice commands.

### words

```gdscript
var words: Array[String]
```

### calls

```gdscript
var calls: Array
```

### qlbl

```gdscript
var qlbl: Dictionary
```

### extra

```gdscript
var extra: Array
```

### out

```gdscript
var out: Array[String]
```
