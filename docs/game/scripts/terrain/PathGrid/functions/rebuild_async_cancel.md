# PathGrid::rebuild_async_cancel Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 360–364)</br>
*Belongs to:* [PathGrid](../PathGrid.md)

**Signature**

```gdscript
func rebuild_async_cancel() -> void
```

## Description

Cancel an ongoing async build (best-effort)

## Source

```gdscript
func rebuild_async_cancel() -> void:
	if _build_running:
		_build_cancel = true
```
