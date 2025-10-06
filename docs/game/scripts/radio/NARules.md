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

## Public Member Functions

- [`func get_parser_tables() -> Dictionary`](NARules/functions/get_parser_tables.md) — Build and return the parser table
- [`func get_vosk_grammar_words() -> String`](NARules/functions/get_vosk_grammar_words.md) — Build and return a vosk grammar list

## Member Function Documentation

### get_parser_tables

```gdscript
func get_parser_tables() -> Dictionary
```

Build and return the parser table

### get_vosk_grammar_words

```gdscript
func get_vosk_grammar_words() -> String
```

Build and return a vosk grammar list
