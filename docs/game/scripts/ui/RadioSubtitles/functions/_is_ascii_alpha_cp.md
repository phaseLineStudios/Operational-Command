# RadioSubtitles::_is_ascii_alpha_cp Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 378–381)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _is_ascii_alpha_cp(cp: int) -> bool
```

## Description

ASCII alpha test

## Source

```gdscript
func _is_ascii_alpha_cp(cp: int) -> bool:
	return (cp >= 65 and cp <= 90) or (cp >= 97 and cp <= 122)
```
