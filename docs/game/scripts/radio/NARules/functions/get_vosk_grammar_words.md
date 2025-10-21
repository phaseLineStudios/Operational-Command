# NARules::get_vosk_grammar_words Function Reference

*Defined at:* `scripts/radio/NARules.gd` (lines 172–202)</br>
*Belongs to:* [NARules](../../NARules.md)

**Signature**

```gdscript
func get_vosk_grammar_words() -> String
```

## Description

Build and return a vosk grammar list

## Source

```gdscript
func get_vosk_grammar_words() -> String:
	var words := []

	var tables := get_parser_tables()

	# Actions / prowords
	words.append_array(tables["action_synonyms"].keys())
	words.append_array(["now", "immediately"])

	# Callsigns / Directions
	words.append_array(tables["callsigns"].keys())
	words.append_array(tables["directions"].keys())

	# Prepositions (from tables)
	words.append_array(tables["prepositions"].keys())

	# Quantity labels (all variants + normalized units)
	var qlbl: Dictionary = tables["quantity_labels"]
	words.append_array(qlbl.keys())
	for v in qlbl.values():
		words.append(v)

	# Number words & digits
	words.append_array(tables["number_words"].keys())
	for d in 10:
		words.append(str(d))

	# Unknown token
	words.append("[unk]")

	return JSON.stringify(words)
```
