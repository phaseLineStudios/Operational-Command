# Persistence::load_save Function Reference

*Defined at:* `scripts/core/Persistence.gd` (lines 81–89)</br>
*Belongs to:* [Persistence](../../Persistence.md)

**Signature**

```gdscript
func load_save(save_id: String) -> CampaignSave
```

## Description

Load a save by ID. Returns null if not found.

## Source

```gdscript
func load_save(save_id: String) -> CampaignSave:
	# Check cache first
	if _save_cache.has(save_id):
		return _save_cache[save_id]

	# Load from file
	return load_save_from_file(save_id)
```
