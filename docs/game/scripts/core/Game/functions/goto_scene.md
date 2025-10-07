# Game::goto_scene Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 39–45)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func goto_scene(path: String) -> void
```

## Description

Change to scene at [param path]; logs error if missing.

## Source

```gdscript
func goto_scene(path: String) -> void:
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)
	else:
		push_error("Scene not found: %s" % path)
```
