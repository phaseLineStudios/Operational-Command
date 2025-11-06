# HQTable::_on_radio_partial Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 265–268)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _on_radio_partial(text: String) -> void
```

## Description

Handle partial speech recognition

## Source

```gdscript
func _on_radio_partial(text: String) -> void:
	radio_subtitles.show_partial(text)
```
