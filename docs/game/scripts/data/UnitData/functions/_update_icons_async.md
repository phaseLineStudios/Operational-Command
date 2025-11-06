# UnitData::_update_icons_async Function Reference

*Defined at:* `scripts/data/UnitData.gd` (lines 165–191)</br>
*Belongs to:* [UnitData](../../UnitData.md)

**Signature**

```gdscript
func _update_icons_async(rev: int) -> void
```

- **rev**: Internal version token to ignore out-of-date completions.

## Description

Build both friend/enemy icons asynchronously. Drops stale results.

## Source

```gdscript
func _update_icons_async(rev: int) -> void:
	# In editor, make sure a frame passes so resources/servers are ready.
	var tree := Engine.get_main_loop() as SceneTree
	if tree:
		await tree.process_frame

	var task_friend = await MilSymbol.create_symbol(
		MilSymbol.UnitAffiliation.FRIEND, type, MilSymbolConfig.Size.MEDIUM, size
	)
	var task_enemy = await MilSymbol.create_symbol(
		MilSymbol.UnitAffiliation.ENEMY, type, MilSymbolConfig.Size.MEDIUM, size
	)

	var friend_tex: ImageTexture = task_friend
	var enemy_tex: ImageTexture = task_enemy

	if rev != _icon_rev:
		return

	icon = friend_tex
	enemy_icon = enemy_tex

	# Notify editor/consumers.
	emit_changed()
	emit_signal("icons_ready")
```
