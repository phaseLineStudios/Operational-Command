# CampaignEditor::_ready Function Reference

*Defined at:* `scripts/editors/CampaignEditor.gd` (lines 11–16)</br>
*Belongs to:* [CampaignEditor](../../CampaignEditor.md)

**Signature**

```gdscript
func _ready()
```

## Source

```gdscript
func _ready():
	AudioManager.stop_music(0.5)

	back_btn.connect("pressed", _on_back_pressed)
```
