# Debrief::set_score Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 193–206)</br>
*Belongs to:* [Debrief](../../Debrief.md)

**Signature**

```gdscript
func set_score(score: Dictionary) -> void
```

## Description

Sets base, bonus, penalty, and total score fields.
"total" is derived as base + bonus - penalty if omitted.

## Source

```gdscript
func set_score(score: Dictionary) -> void:
	_score = score.duplicate(true)
	var base := int(_score.get("base", 0))
	var bonus := int(_score.get("bonus", 0))
	var penalty := int(_score.get("penalty", 0))
	var total := int(_score.get("total", base + bonus - penalty))
	_score["total"] = total
	_score_base.text = str(base)
	_score_bonus.text = str(bonus)
	_score_penalty.text = str(penalty)
	_score_total.text = str(total)
	_request_align()
```
