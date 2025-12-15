# Game::delete_save Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 184–194)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func delete_save(save_id: StringName) -> void
```

## Source

```gdscript
func delete_save(save_id: StringName) -> void:
	var success := Persistence.delete_save(save_id)

	if success:
		LogService.info("Deleted save: %s" % save_id, "Game")
	else:
		push_warning("Failed to delete save: %s" % save_id)

	emit_signal("save_deleted", save_id)
```
