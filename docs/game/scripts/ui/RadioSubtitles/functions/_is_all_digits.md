# RadioSubtitles::_is_all_digits Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 510–517)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _is_all_digits(s: String) -> bool
```

## Description

Check if string is all digits

## Source

```gdscript
func _is_all_digits(s: String) -> bool:
	if s.length() == 0:
		return false
	for i in s.length():
		var cp := s.unicode_at(i)
		if not _is_ascii_digit_cp(cp):
			return false
	return true
```
