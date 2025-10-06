# STTService::_build_full_sentence Function Reference

*Defined at:* `scripts/radio/STTService.gd` (lines 171–174)</br>
*Belongs to:* [STTService](../STTService.md)

**Signature**

```gdscript
func _build_full_sentence() -> String
```

## Description

Build the visible sentence from committed + segment with single spacing.

## Source

```gdscript
func _build_full_sentence() -> String:
	return _join_non_empty(_committed, _segment).strip_edges()
```
