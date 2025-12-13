# Game::select_save Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 56–67)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func select_save(save_id: StringName) -> void
```

## Description

Set current save and emit `signal save_selected`.

## Source

```gdscript
func select_save(save_id: StringName) -> void:
	current_save_id = save_id
	current_save = Persistence.load_save(save_id)

	if current_save:
		LogService.info("Loaded save: %s" % current_save.save_name, "Game")
	else:
		push_warning("Failed to load save: %s" % save_id)

	emit_signal("save_selected", save_id)
```

## References

- [`signal save_selected`](../../Game.md#save_selected)
