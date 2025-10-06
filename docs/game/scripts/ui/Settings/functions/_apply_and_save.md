# Settings::_apply_and_save Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 173–179)</br>
*Belongs to:* [Settings](../Settings.md)

**Signature**

```gdscript
func _apply_and_save() -> void
```

## Description

Apply settings and persist.

## Source

```gdscript
func _apply_and_save() -> void:
	_apply_video()
	_apply_audio()
	_apply_gameplay()
	_save_config()
```
