# DrawingController::_split_into_segments Function Reference

*Defined at:* `scripts/core/DrawingController.gd` (lines 175–203)</br>
*Belongs to:* [DrawingController](../../DrawingController.md)

**Signature**

```gdscript
func _split_into_segments(surviving_points: Array[Vector3], original_points: Array) -> Array
```

## Description

Split points into continuous segments by detecting gaps in the original sequence

## Source

```gdscript
func _split_into_segments(surviving_points: Array[Vector3], original_points: Array) -> Array:
	var segments: Array = []
	var current_segment: Array[Vector3] = []

	# Build index map of surviving points
	var surviving_indices: Array[int] = []
	for surv_point in surviving_points:
		for i in range(original_points.size()):
			if original_points[i] == surv_point:
				surviving_indices.append(i)
				break

	# Split into segments where indices are not consecutive
	for i in range(surviving_indices.size()):
		var idx := surviving_indices[i]
		current_segment.append(original_points[idx])

		# Check if next index is not consecutive (gap detected)
		var is_last := i == surviving_indices.size() - 1
		var has_gap := not is_last and (surviving_indices[i + 1] != idx + 1)

		if is_last or has_gap:
			if current_segment.size() >= 2:
				segments.append(current_segment.duplicate())
			current_segment.clear()

	return segments
```
