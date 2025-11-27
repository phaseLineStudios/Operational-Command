# Game::set_replacement_pool Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 146–149)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func set_replacement_pool(v: int) -> void
```

## Description

Set replacement pool (non-persistent placeholder)

## Source

```gdscript
func set_replacement_pool(v: int) -> void:
	campaign_replacement_pool = max(0, int(v))
```
