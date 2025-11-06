# MilSymbol::_init Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbol.gd` (lines 57–63)</br>
*Belongs to:* [MilSymbol](../../MilSymbol.md)

**Signature**

```gdscript
func _init(p_config: MilSymbolConfig = null) -> void
```

## Source

```gdscript
func _init(p_config: MilSymbolConfig = null) -> void:
	if p_config != null:
		config = p_config
	else:
		config = MilSymbolConfig.create_default()
```
