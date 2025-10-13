# ContentDB::image_to_png_b64 Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 435–441)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func image_to_png_b64(img: Image) -> String
```

## Description

Serialize a image to Base 64

## Source

```gdscript
func image_to_png_b64(img: Image) -> String:
	if img == null or img.is_empty():
		return ""
	var png: PackedByteArray = img.save_png_to_buffer()
	return Marshalls.raw_to_base64(png)
```
