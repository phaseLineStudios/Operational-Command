# Briefing::_build_board Function Reference

*Defined at:* `scripts/ui/Briefing.gd` (lines 50–57)</br>
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
	if _brief.board_texture != null:
		var tex: Texture2D = _brief.board_texture
		_whiteboard.texture = tex
```
