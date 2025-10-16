# Debrief::set_units Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 233–277)</br>
*Belongs to:* [Debrief](../../Debrief.md)

**Signature**

```gdscript
func set_units(units: Array) -> void
```

## Description

Populates the Units tree with per-unit rows.
Accepted per-row shapes:
- {"name": String, "kills"?: int, "wia"?: int, "kia"?: int, "xp"?: int, "status"?: String}
- {"unit": Object with "title" or "name", same optional stats as above}

## Source

```gdscript
func set_units(units: Array) -> void:
	_units_tree.clear()
	_init_units_tree_columns()

	var root := _units_tree.create_item()
	for u in units:
		var unit_name := ""
		var status := ""
		var kills := 0
		var wia := 0
		var kia := 0
		var xp := 0

		if u is Dictionary:
			if u.has("name"):
				unit_name = str(u["name"])
			elif u.has("unit"):
				var ud = u["unit"]
				if ud != null:
					var t = ud.get("title")
					if t != null and str(t) != "":
						unit_name = str(t)
					else:
						var n = ud.get("name")
						if n != null and str(n) != "":
							unit_name = str(n)
			status = str(u.get("status", ""))
			kills = int(u.get("kills", 0))
			wia = int(u.get("wia", 0))
			kia = int(u.get("kia", 0))
			xp = int(u.get("xp", 0))
		else:
			unit_name = str(u)

		var it := _units_tree.create_item(root)
		it.set_text(0, unit_name)
		it.set_text(1, status)
		it.set_text(2, str(kills))
		it.set_text(3, str(wia))
		it.set_text(4, str(kia))
		it.set_text(5, str(xp))

	_request_align()
```
