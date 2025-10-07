# NewScenarioDialog::_on_thumbnail_clear Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 105–110)</br>
*Belongs to:* [NewScenarioDialog](../../NewScenarioDialog.md)

**Signature**

```gdscript
func _on_thumbnail_clear() -> void
```

## Source

```gdscript
func _on_thumbnail_clear() -> void:
	thumb_path.text = ""
	thumb_preview.texture = null
	thumbnail = null
```
