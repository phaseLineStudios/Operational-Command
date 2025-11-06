# MilSymbolRenderer::_ready Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolRenderer.gd` (lines 22–27)</br>
*Belongs to:* [MilSymbolRenderer](../../MilSymbolRenderer.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	if config == null:
		config = MilSymbolConfig.create_default()
	_calculate_scale()
```
