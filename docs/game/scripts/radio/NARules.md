# NARules Class Reference

*File:* `scripts/radio/NARules.gd`
*Inherits:* `Node`

## Synopsis

```gdscript
extends Node
```

## Brief

NATO radio phrasebook, callsigns, and grammar helpers.

## Detailed Description

Provides tables and pattern helpers for validating and assisting the
construction of voice commands.

Build a deduped list of grammar words (and phrases) with mission overrides.

Build and return Vosk grammar JSON with mission overrides.

## Public Member Functions

- [`func get_parser_tables() -> Dictionary`](NARules/functions/get_parser_tables.md) — Build and return the parser table

## Public Attributes

- `Array[String] words`
- `Array calls`
- `Dictionary qlbl`
- `Array[String] out`

## Member Function Documentation

### get_parser_tables

```gdscript
func get_parser_tables() -> Dictionary
```

Build and return the parser table

## Member Data Documentation

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

### out

```gdscript
var out: Array[String]
```
