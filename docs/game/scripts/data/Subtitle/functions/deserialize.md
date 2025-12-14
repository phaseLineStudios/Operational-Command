# Subtitle::deserialize Function Reference

*Defined at:* `scripts/data/Subtitle.gd` (lines 27–32)</br>
*Belongs to:* [Subtitle](../../Subtitle.md)

**Signature**

```gdscript
func deserialize(data: Dictionary) -> Subtitle
```

## Description

Deserialize subtitle from dictionary

## Source

```gdscript
static func deserialize(data: Dictionary) -> Subtitle:
	var subtitle := Subtitle.new()
	subtitle.start_time = data.get("start_time", 0.0)
	subtitle.end_time = data.get("end_time", 0.0)
	subtitle.text = data.get("text", "")
	return subtitle
```
