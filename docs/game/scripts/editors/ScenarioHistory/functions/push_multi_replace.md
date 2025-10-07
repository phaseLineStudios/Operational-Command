# ScenarioHistory::push_multi_replace Function Reference

*Defined at:* `scripts/editors/ScenarioHistory.gd` (lines 122–139)</br>
*Belongs to:* [ScenarioHistory](../../ScenarioHistory.md)

**Signature**

```gdscript
func push_multi_replace(data: Resource, changes: Array, desc: String) -> void
```

## Description

Replace multiple arrays atomically. changes = [{prop:String, before:Array, after:Array}, ...]

## Source

```gdscript
func push_multi_replace(data: Resource, changes: Array, desc: String) -> void:
	_ur.create_action(desc)

	for c in changes:
		if typeof(c) == TYPE_DICTIONARY and c.has("prop") and c.has("after"):
			var prop := String(c["prop"])
			var after_arr: Array = _deep_copy_array_res(c["after"])
			_ur.add_do_method(Callable(self, "_apply_array").bind(data, prop, after_arr))

	for c in changes:
		if typeof(c) == TYPE_DICTIONARY and c.has("prop") and c.has("before"):
			var prop := String(c["prop"])
			var before_arr: Array = _deep_copy_array_res(c["before"])
			_ur.add_undo_method(Callable(self, "_apply_array").bind(data, prop, before_arr))
	_ur.commit_action()
	_record_commit(desc)
```
