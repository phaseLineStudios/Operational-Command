# ScenarioEditorFileOps::init Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorFileOps.gd` (lines 26–30)</br>
*Belongs to:* [ScenarioEditorFileOps](../../ScenarioEditorFileOps.md)

**Signature**

```gdscript
func init(parent: ScenarioEditor) -> void
```

- **parent**: Parent ScenarioEditor instance.

## Description

Initialize with parent editor reference.

## Source

```gdscript
func init(parent: ScenarioEditor) -> void:
	editor = parent
	_init_file_dialogs()
```
