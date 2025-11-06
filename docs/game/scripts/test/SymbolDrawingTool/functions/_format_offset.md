# SymbolDrawingTool::_format_offset Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 480–488)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func _format_offset(value: float) -> String
```

## Description

Format offset as string with sign

## Source

```gdscript
func _format_offset(value: float) -> String:
	if abs(value) < 0.01:
		return ""
	elif value > 0:
		return "+ half * %.2f" % value
	else:
		return "- half * %.2f" % abs(value)
```
