# UnitData::deserialize Function Reference

*Defined at:* `scripts/data/UnitData.gd` (lines 239–321)</br>
*Belongs to:* [UnitData](../../UnitData.md)

**Signature**

```gdscript
func deserialize(data: Variant) -> UnitData
```

## Description

Deserialize Unit JSON

## Source

```gdscript
static func deserialize(data: Variant) -> UnitData:
	if typeof(data) != TYPE_DICTIONARY:
		return null

	var u := UnitData.new()

	u.id = data.get("id", u.id)
	u.title = data.get("title", u.title)
	u.role = data.get("role", u.role)
	u.cost = int(data.get("cost", u.cost))
	var slots = data.get("allowed_slots", null)
	if typeof(slots) == TYPE_ARRAY:
		var tmp_slots: Array[String] = []
		for s in slots:
			tmp_slots.append(str(s))
		u.allowed_slots = tmp_slots

	u.size = int(data.get("size", u.size)) as MilSymbol.UnitSize
	u.type = int(data.get("type", u.type)) as MilSymbol.UnitType
	u.movement_profile = (
		int(data.get("movement_profile", u.movement_profile)) as TerrainBrush.MoveProfile
	)
	u.strength = int(data.get("strength", u.strength))
	u.is_engineer = bool(data.get("is_engineer", u.is_engineer))
	u.is_medical = bool(data.get("is_medical", u.is_medical))
	u.equipment = data.get("equipment", u.equipment)
	u.experience = float(data.get("experience", u.experience))

	var stats: Dictionary = data.get("stats", {})
	if typeof(stats) == TYPE_DICTIONARY:
		u.attack = float(stats.get("attack", u.attack))
		u.defense = float(stats.get("defense", u.defense))
		u.spot_m = float(stats.get("spot_m", u.spot_m))
		u.range_m = float(stats.get("range_m", u.range_m))
		u.morale = float(stats.get("morale", u.morale))
		u.speed_kph = float(stats.get("speed_kph", u.speed_kph))

	var state: Dictionary = data.get("state", {})
	if typeof(state) == TYPE_DICTIONARY:
		u.state_strength = float(state.get("state_strength", u.state_strength))
		u.state_injured = float(state.get("state_injured", u.state_injured))
		u.state_equipment = float(state.get("state_equipment", u.state_equipment))
		u.cohesion = float(state.get("cohesion", u.cohesion))

	var editor: Dictionary = data.get("editor", {})
	if typeof(editor) == TYPE_DICTIONARY:
		u.unit_category = ContentDB.get_unit_category(editor.get("unit_category", u.unit_category))

	u.throughput = data.get("throughput", u.throughput)
	u.doctrine = data.get("doctrine", u.doctrine)
	var equipment_t = data.get("equipment_tags", null)
	if typeof(equipment_t) == TYPE_ARRAY:
		var tmp_tags: Array[String] = []
		for e in equipment_t:
			tmp_tags.append(str(e))
		u.equipment_tags = tmp_tags

	# --- Ammo + Logistics fields ---
	var am_caps = data.get("ammunition", null)
	if typeof(am_caps) == TYPE_DICTIONARY:
		u.ammunition = am_caps

	var am_state = data.get("state_ammunition", null)
	if typeof(am_state) == TYPE_DICTIONARY:
		u.state_ammunition = am_state

	u.ammunition_low_threshold = float(
		data.get("ammunition_low_threshold", u.ammunition_low_threshold)
	)
	u.ammunition_critical_threshold = float(
		data.get("ammunition_critical_threshold", u.ammunition_critical_threshold)
	)
	u.supply_transfer_rate = float(data.get("supply_transfer_rate", u.supply_transfer_rate))
	u.supply_transfer_radius_m = float(
		data.get("supply_transfer_radius_m", u.supply_transfer_radius_m)
	)

	# Backfill ammo state if missing (for older saves)
	if u.state_ammunition.is_empty() and not u.ammunition.is_empty():
		for k in u.ammunition.keys():
			u.state_ammunition[k] = int(u.ammunition[k])

	return u
```
