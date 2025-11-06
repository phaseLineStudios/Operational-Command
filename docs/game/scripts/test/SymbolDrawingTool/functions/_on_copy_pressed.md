# SymbolDrawingTool::_on_copy_pressed Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 490–495)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func _on_copy_pressed() -> void
```

## Description

Copy generated code to clipboard

## Source

```gdscript
func _on_copy_pressed() -> void:
	if code_output.text != "":
		DisplayServer.clipboard_set(code_output.text)
		print("Code copied to clipboard!")
```
