# MapController::_set_read_mode Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 194–200)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _set_read_mode(enabled: bool) -> void
```

## Source

```gdscript
func _set_read_mode(enabled: bool) -> void:
	var pp := get_tree().root.find_child("PostProcess", true, false)
	if pp != null and pp.has_method("set"):
		if "read_mode_enabled" in pp:
			pp.read_mode_enabled = enabled
```
