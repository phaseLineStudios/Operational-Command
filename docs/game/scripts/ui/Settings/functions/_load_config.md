# Settings::_load_config Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 187–192)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func _load_config() -> void
```

## Description

Load config file (if present).

## Source

```gdscript
func _load_config() -> void:
	var err := _cfg.load(CONFIG_PATH)
	if err != OK:
		return
```
