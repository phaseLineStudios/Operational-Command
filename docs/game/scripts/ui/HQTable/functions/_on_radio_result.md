# HQTable::_on_radio_result Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 310–313)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _on_radio_result(text: String) -> void
```

## Description

Handle final speech recognition result

## Source

```gdscript
func _on_radio_result(text: String) -> void:
	radio_subtitles.show_result(text)
```
