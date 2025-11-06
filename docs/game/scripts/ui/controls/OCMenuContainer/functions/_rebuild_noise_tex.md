# OCMenuContainer::_rebuild_noise_tex Function Reference

*Defined at:* `scripts/ui/controls/OcMenuContainer.gd` (lines 125–141)</br>
*Belongs to:* [OCMenuContainer](../../OCMenuContainer.md)

**Signature**

```gdscript
func _rebuild_noise_tex()
```

## Source

```gdscript
func _rebuild_noise_tex():
	if _noise_tex != null:
		return
	var w := 256
	var h := 256
	var img := Image.create(w, h, false, Image.FORMAT_L8)
	var rng := RandomNumberGenerator.new()
	rng.seed = int(_noise_seed)

	for y in h:
		for x in w:
			var v := rng.randi_range(0, 255)
			img.set_pixelv(Vector2i(x, y), Color8(v, 0, 0, 255))

	_noise_tex = ImageTexture.create_from_image(img)
```
