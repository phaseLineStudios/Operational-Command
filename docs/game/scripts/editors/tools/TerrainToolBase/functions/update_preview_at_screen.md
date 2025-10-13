# TerrainToolBase::update_preview_at_screen Function Reference

*Defined at:* `scripts/editors/tools/TerrainToolBase.gd` (lines 72–82)</br>
*Belongs to:* [TerrainToolBase](../../TerrainToolBase.md)

**Signature**

```gdscript
func update_preview_at_screen(screen_pos: Vector2) -> void
```

## Description

Update preview position on screen

## Source

```gdscript
func update_preview_at_screen(screen_pos: Vector2) -> void:
	if not _inside or _preview == null or viewport_container == null or render == null:
		return

	var local_m := editor.screen_to_map(screen_pos, true)
	if not local_m.is_finite():
		return

	_place_preview(local_m)
```
