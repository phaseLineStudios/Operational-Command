# DocumentFace::_ready Function Reference

*Defined at:* `scripts/ui/DocumentFace.gd` (lines 15–25)</br>
*Belongs to:* [DocumentFace](../../DocumentFace.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	# Connect button signals
	if prev_button:
		prev_button.pressed.connect(_on_prev_pressed)
	if next_button:
		next_button.pressed.connect(_on_next_pressed)

	# Initial update
	update_page_indicator()
```
