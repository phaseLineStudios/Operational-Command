# Briefing::_build_board Function Reference

*Defined at:* `scripts/ui/Briefing.gd` (lines 46–51)</br>
*Belongs to:* [Briefing](../../Briefing.md)

**Signature**

```gdscript
func _build_board() -> void
```

## Description

Put the whiteboard background.

## Source

```gdscript
func _build_board() -> void:
	if not _brief:
		return
	var tex: Texture2D = _brief.board_texture
	_whiteboard.texture = tex
```
