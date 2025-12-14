# RadioSubtitles::_is_ascii_digit_cp Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 430–433)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _is_ascii_digit_cp(cp: int) -> bool
```

## Description

ASCII digit test

## Source

```gdscript
func _is_ascii_digit_cp(cp: int) -> bool:
	return cp >= 48 and cp <= 57
```
