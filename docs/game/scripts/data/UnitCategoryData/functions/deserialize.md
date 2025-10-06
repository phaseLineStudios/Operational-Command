# UnitCategoryData::deserialize Function Reference

*Defined at:* `scripts/data/UnitCategoryData.gd` (lines 30–44)</br>
*Belongs to:* [UnitCategoryData](../UnitCategoryData.md)

**Signature**

```gdscript
func deserialize(data: Variant) -> UnitCategoryData
```

## Description

Deserialize data from JSON

## Source

```gdscript
static func deserialize(data: Variant) -> UnitCategoryData:
	if typeof(data) != TYPE_DICTIONARY:
		return null

	var inst := UnitCategoryData.new()
	inst.id = data.get("id", inst.id)
	inst.title = data.get("title", inst.title)

	var icon_path = data.get("editor_icon_path", null)
	if icon_path != null and typeof(icon_path) == TYPE_STRING and icon_path != "":
		var tex := load(icon_path)
		if tex is Texture2D:
			inst.editor_icon = tex

	return inst
```
