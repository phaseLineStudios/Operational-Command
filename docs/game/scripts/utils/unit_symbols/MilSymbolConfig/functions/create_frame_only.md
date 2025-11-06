# MilSymbolConfig::create_frame_only Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolConfig.gd` (lines 84–100)</br>
*Belongs to:* [MilSymbolConfig](../../MilSymbolConfig.md)

**Signature**

```gdscript
func create_frame_only() -> MilSymbolConfig
```

## Description

Create a configuration for frame-only symbols (no fill)
Useful for outline-style unit symbols
Uses white lines for easy color modulation

## Source

```gdscript
static func create_frame_only() -> MilSymbolConfig:
	var config := MilSymbolConfig.new()
	config.filled = false

	# Set all frame colors to white for easy modulation
	config.frame_colors[MilSymbol.UnitAffiliation.FRIEND] = Color.WHITE
	config.frame_colors[MilSymbol.UnitAffiliation.ENEMY] = Color.WHITE
	config.frame_colors[MilSymbol.UnitAffiliation.NEUTRAL] = Color.WHITE
	config.frame_colors[MilSymbol.UnitAffiliation.UNKNOWN] = Color.WHITE

	# Set icon and text colors to white as well
	config.icon_color = Color.WHITE
	config.text_color = Color.WHITE

	return config
```
