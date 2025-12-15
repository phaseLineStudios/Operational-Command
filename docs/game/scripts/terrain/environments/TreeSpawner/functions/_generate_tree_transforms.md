# TreeSpawner::_generate_tree_transforms Function Reference

*Defined at:* `scripts/terrain/environments/tree_spawner.gd` (lines 203–265)</br>
*Belongs to:* [TreeSpawner](../../TreeSpawner.md)

**Signature**

```gdscript
func _generate_tree_transforms() -> void
```

## Description

Generate tree transforms (positions, rotations, scales)

## Source

```gdscript
func _generate_tree_transforms() -> void:
	_tree_transforms.clear()

	if random_seed != 0:
		seed(random_seed)

	var half_size := area_size / 2.0
	var placed := 0
	var attempts := 0
	var max_attempts := tree_count * 20

	while placed < tree_count and attempts < max_attempts:
		attempts += 1

		# Generate position
		var pos_2d := Vector2(
			randf_range(-half_size.x, half_size.x), randf_range(-half_size.y, half_size.y)
		)

		# Apply clustering
		var noise_val := (_noise.get_noise_2d(pos_2d.x, pos_2d.y) + 1.0) / 2.0
		if randf() > lerp(1.0, noise_val, clustering):
			continue

		# Check spacing
		if not _check_spacing(pos_2d):
			continue

		# Sample terrain height
		var y_pos := _sample_terrain_height(pos_2d) + height_offset
		var sink_amount := ground_sink + randf_range(-sink_variation, sink_variation) * ground_sink
		var pos_3d := Vector3(pos_2d.x, y_pos - sink_amount, pos_2d.y)

		# Generate transform
		var t := Transform3D()
		t = t.rotated(Vector3.UP, randf() * TAU)  # Random Y rotation

		# Optionally align to slope
		if align_to_slope:
			var slope_normal := _sample_terrain_normal(pos_2d)
			if slope_normal != Vector3.UP:
				var angle := Vector3.UP.angle_to(slope_normal)
				if angle > deg_to_rad(max_slope_angle):
					continue  # Skip if slope too steep
				# Apply slope rotation
				var axis := Vector3.UP.cross(slope_normal).normalized()
				t = t.rotated(axis, angle)

		t = t.scaled(Vector3.ONE * randf_range(scale_range.x, scale_range.y))
		t.origin = pos_3d

		_tree_transforms.append(t)
		placed += 1

	if placed < tree_count:
		push_warning(
			(
				"[TreeSpawner] Only placed %d/%d trees due to spacing constraints"
				% [placed, tree_count]
			)
		)
```
