# MilSymbolIcons::_get_icon_generators Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolIcons.gd` (lines 14–32)</br>
*Belongs to:* [MilSymbolIcons](../../MilSymbolIcons.md)

**Signature**

```gdscript
func _get_icon_generators() -> Dictionary
```

- **Return Value**: Dictionary of generators keyed by MilSymbol.UnitType.

## Description

Load and cache icon generators from ICONS_PATH.
Skips files with global class_names.

## Source

```gdscript
static func _get_icon_generators() -> Dictionary:
	if not _generators.is_empty():
		return _generators

	var files := ResourceLoader.list_directory(ICONS_PATH)
	for file in files:
		var is_dir := file[file.length() - 1] == "/"
		var extension := file.split(".")[-1]
		if not is_dir and extension == "gd":
			var script := load(ICONS_PATH.path_join(file)) as GDScript
			if script:
				var inst: Variant = script.new()
				if inst is BaseMilSymbolIcon:
					var unit_type: MilSymbol.UnitType = inst.get_type()
					_generators[unit_type] = inst

	return _generators
```
