# RadioSubtitles::_is_number_word Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 394–398)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _is_number_word(token: String) -> bool
```

## Description

Check if a token is a number word

## Source

```gdscript
func _is_number_word(token: String) -> bool:
	var number_words: Dictionary = _tables.get("number_words", {})
	return number_words.has(token)
```
