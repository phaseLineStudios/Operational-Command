# SurfaceLayer::_start_union_thread Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 336–356)</br>
*Belongs to:* [SurfaceLayer](../SurfaceLayer.md)

**Signature**

```gdscript
func _start_union_thread(key: String) -> void
```

## Description

Starts/queues a worker thread to compute AABB-filtered union for a group

## Source

```gdscript
func _start_union_thread(key: String) -> void:
	if not _groups.has(key):
		return
	var group = _groups[key]
	if _threads.has(key):
		var th: Thread = _threads[key]
		if th and th.is_started():
			_pending_ver[key] = int(_pending_ver.get(key, 0)) + 1
			return
	var polys: Array = group.polys.values()
	var bboxes: Array = []
	for id in group.bboxes.keys():
		bboxes.append(group.bboxes[id])
	var ver := int(_pending_ver.get(key, 0)) + 1
	_pending_ver[key] = ver
	var thrd := Thread.new()
	_threads[key] = thrd
	var callable := Callable(self, "_union_worker").bind(key, polys, bboxes, ver)
	thrd.start(callable, Thread.PRIORITY_NORMAL)
```
