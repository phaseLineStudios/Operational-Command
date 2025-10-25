# AmmoProfile::deserialize Function Reference

*Defined at:* `scripts/data/AmmoProfile.gd` (lines 38–49)</br>
*Belongs to:* [AmmoProfile](../../AmmoProfile.md)

**Signature**

```gdscript
func deserialize(data: Variant) -> AmmoProfile
```

## Description

Deserialize from JSON

## Source

```gdscript
static func deserialize(data: Variant) -> AmmoProfile:
	if typeof(data) != TYPE_DICTIONARY:
		return null

	var o := AmmoProfile.new()
	o.default_caps = data.get("default_caps", o.default_caps)
	o.default_low_threshold = float(data.get("default_low_threshold", o.default_low_threshold))
	o.default_critical_threshold = float(
		data.get("default_critical_threshold", o.default_critical_threshold)
	)

	return o
```
