extends Resource
class_name UnitCategoryData

## Unique key identifying this category
@export var id: String
## Unit Category Title
@export var title: String
## Unit Category Editor Icon
@export var editor_icon: Texture2D

## Serialize data to JSON
func serialize() -> Dictionary:
	return {
		"id": id,
		"title": title,
		"editor_icon_path": (editor_icon.resource_path as Variant if editor_icon and editor_icon.resource_path != "" else null as Variant),
	}

## Deserialize data from JSON
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
