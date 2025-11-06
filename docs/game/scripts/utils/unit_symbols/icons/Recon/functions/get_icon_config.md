# Recon::get_icon_config Function Reference

*Defined at:* `scripts/utils/unit_symbols/icons/Recon.gd` (lines 9–20)</br>
*Belongs to:* [Recon](../../Recon.md)

**Signature**

```gdscript
func get_icon_config(affiliation: MilSymbol.UnitAffiliation) -> Dictionary
```

## Source

```gdscript
func get_icon_config(affiliation: MilSymbol.UnitAffiliation) -> Dictionary:
	match affiliation:
		MilSymbol.UnitAffiliation.FRIEND:
			return {"type": "lines", "paths": [[Vector2(25, 150), Vector2(175, 50)]]}
		MilSymbol.UnitAffiliation.ENEMY:
			return {"type": "lines", "paths": [[Vector2(64, 136), Vector2(136, 64)]]}
		MilSymbol.UnitAffiliation.NEUTRAL:
			return {"type": "lines", "paths": [[Vector2(45, 155), Vector2(155, 45)]]}
		MilSymbol.UnitAffiliation.UNKNOWN:
			return {"type": "lines", "paths": [[Vector2(50, 135), Vector2(150, 65)]]}
		_:
			return {}
```
