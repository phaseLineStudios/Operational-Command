# ScenarioPersistenceService::ensure_json_ext Function Reference

*Defined at:* `scripts/editors/services/ScenarioPersistenceService.gd` (lines 13–16)</br>
*Belongs to:* [ScenarioPersistenceService](../../ScenarioPersistenceService.md)

**Signature**

```gdscript
func ensure_json_ext(p: String) -> String
```

## Source

```gdscript
func ensure_json_ext(p: String) -> String:
	return p if p.to_lower().ends_with(".json") else "%s.json" % p
```
