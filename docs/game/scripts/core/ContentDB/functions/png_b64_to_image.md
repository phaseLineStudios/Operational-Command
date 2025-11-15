# ContentDB::png_b64_to_image Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 507–515)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func png_b64_to_image(b64: Variant) -> Image
```

## Description

Deserialize a image from Base 64

## Source

```gdscript
func png_b64_to_image(b64: Variant) -> Image:
	if typeof(b64) != TYPE_STRING or String(b64) == "":
		return Image.new()
	var bytes: PackedByteArray = Marshalls.base64_to_raw(String(b64))
	var img := Image.new()
	var err := img.load_png_from_buffer(bytes)
	return img if err == OK else Image.new()
```
