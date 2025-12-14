# MilSymbol::cleanup Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbol.gd` (lines 280–286)</br>
*Belongs to:* [MilSymbol](../../MilSymbol.md)

**Signature**

```gdscript
func cleanup() -> void
```

## Description

Clean up resources

## Source

```gdscript
func cleanup() -> void:
	if _viewport != null:
		_viewport.queue_free()
		_viewport = null
		_renderer = null
```
