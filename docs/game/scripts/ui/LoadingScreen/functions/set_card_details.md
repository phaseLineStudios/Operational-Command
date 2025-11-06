# LoadingScreen::set_card_details Function Reference

*Defined at:* `scripts/ui/LoadingScreen.gd` (lines 22–29)</br>
*Belongs to:* [LoadingScreen](../../LoadingScreen.md)

**Signature**

```gdscript
func set_card_details() -> void
```

## Description

Set scenario details in card.

## Source

```gdscript
func set_card_details() -> void:
	if _scenario == null:
		return
	_card_title.text = _scenario.title
	_card_desc.text = _scenario.description
	_card_image.texture = _scenario.preview
```
