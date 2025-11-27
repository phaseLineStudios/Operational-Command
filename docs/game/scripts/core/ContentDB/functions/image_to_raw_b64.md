# ContentDB::image_to_raw_b64 Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 522–539)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func image_to_raw_b64(img: Image) -> Dictionary
```

## Description

Serialize a floating-point image to Base 64 (lossless raw format)

## Source

```gdscript
func image_to_raw_b64(img: Image) -> Dictionary:
	if img == null or img.is_empty():
		return {}
	# Store raw float data directly - more efficient than EXR for single-channel data
	var width := img.get_width()
	var height := img.get_height()
	var data := PackedFloat32Array()
	data.resize(width * height)

	var idx := 0
	for y in height:
		for x in width:
			data[idx] = img.get_pixel(x, y).r
			idx += 1

	return {"width": width, "height": height, "data": Marshalls.raw_to_base64(data.to_byte_array())}
```
