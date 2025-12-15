# Game::end_playtest Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 608–614)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func end_playtest() -> void
```

## Description

End playtest mode and return to editor

## Source

```gdscript
func end_playtest() -> void:
	if play_mode == PlayMode.SOLO_PLAY_TEST and playtest_return_scene != "":
		var return_to := playtest_return_scene
		play_mode = PlayMode.SOLO_CAMPAIGN
		playtest_return_scene = ""
		# Note: playtest_history_state and playtest_file_path are preserved for the editor to retrieve
		goto_scene(return_to)
```
