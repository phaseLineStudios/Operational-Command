# Game::select_save Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 53–57)</br>
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
	emit_signal("save_selected", save_id)
```

## References

- [`signal save_selected`](../../Game.md#save_selected)
