# Game::record_casualties Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 241–244)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func record_casualties(fr: int, en: int) -> void
```

## Description

Record casualties

## Source

```gdscript
func record_casualties(fr: int, en: int) -> void:
	resolution.add_casualties(fr, en)
```
