# Subtitle::serialize Function Reference

*Defined at:* `scripts/data/Subtitle.gd` (lines 22–25)</br>
*Belongs to:* [Subtitle](../../Subtitle.md)

**Signature**

```gdscript
func serialize() -> Dictionary
```

## Description

Serialize subtitle to dictionary

## Source

```gdscript
func serialize() -> Dictionary:
	return {"start_time": start_time, "end_time": end_time, "text": text}
```
