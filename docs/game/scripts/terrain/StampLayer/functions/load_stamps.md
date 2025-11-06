# StampLayer::load_stamps Function Reference

*Defined at:* `scripts/terrain/StampLayer.gd` (lines 15–32)</br>
*Belongs to:* [StampLayer](../../StampLayer.md)

**Signature**

```gdscript
func load_stamps(stamps: Array) -> void
```

- **stamps**: Array of ScenarioDrawingStamp to render.

## Description

Load stamps from scenario data.

## Source

```gdscript
func load_stamps(stamps: Array) -> void:
	_stamps.clear()
	_texture_cache.clear()

	for stamp in stamps:
		if stamp is ScenarioDrawingStamp and stamp.visible:
			_stamps.append(stamp)
			# Preload texture
			if stamp.texture_path != "" and ResourceLoader.exists(stamp.texture_path):
				if not _texture_cache.has(stamp.texture_path):
					var tex := load(stamp.texture_path) as Texture2D
					if tex:
						_texture_cache[stamp.texture_path] = tex

	LogService.info("StampLayer loaded %d stamps" % _stamps.size(), "StampLayer.gd")
	queue_redraw()
```
