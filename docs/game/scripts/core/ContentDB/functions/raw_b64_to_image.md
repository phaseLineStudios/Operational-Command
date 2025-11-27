# ContentDB::raw_b64_to_image Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 541–572)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func raw_b64_to_image(raw_dict: Variant) -> Image
```

## Description

Deserialize a floating-point image from raw Base 64 format

## Source

```gdscript
func raw_b64_to_image(raw_dict: Variant) -> Image:
	if typeof(raw_dict) != TYPE_DICTIONARY:
		return Image.new()

	var width: int = raw_dict.get("width", 0)
	var height: int = raw_dict.get("height", 0)
	var b64: String = raw_dict.get("data", "")

	if width <= 0 or height <= 0 or b64 == "":
		return Image.new()

	var bytes := Marshalls.base64_to_raw(b64)
	var data := PackedFloat32Array()
	data.resize(width * height)

	# Convert bytes back to float array
	for i in data.size():
		var offset := i * 4  # 4 bytes per float32
		if offset + 3 < bytes.size():
			data[i] = bytes.decode_float(offset)

	# Create image and populate with float data
	var img := Image.create(width, height, false, Image.FORMAT_RF)
	var idx := 0
	for y in height:
		for x in width:
			img.set_pixel(x, y, Color(data[idx], 0, 0, 1))
			idx += 1

	return img
```
