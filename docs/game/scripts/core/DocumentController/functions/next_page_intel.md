# DocumentController::next_page_intel Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 780–784)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func next_page_intel() -> void
```

## Description

Public API for page navigation (can be called from HQTable or input handlers)

## Source

```gdscript
func next_page_intel() -> void:
	if _intel_face:
		_intel_face.next_page()
```
