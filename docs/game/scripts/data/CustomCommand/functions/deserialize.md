# CustomCommand::deserialize Function Reference

*Defined at:* `scripts/data/CustomCommand.gd` (lines 48–61)</br>
*Belongs to:* [CustomCommand](../../CustomCommand.md)

**Signature**

```gdscript
func deserialize(d: Variant) -> CustomCommand
```

## Description

Deserialize from dictionary.

## Source

```gdscript
static func deserialize(d: Variant) -> CustomCommand:
	if typeof(d) != TYPE_DICTIONARY:
		return null
	var cmd := CustomCommand.new()
	cmd.keyword = str(d.get("keyword", ""))
	var grammar = d.get("additional_grammar", [])
	if typeof(grammar) == TYPE_ARRAY:
		var arr: Array[String] = []
		for w in grammar:
			arr.append(str(w))
		cmd.additional_grammar = arr
	cmd.trigger_id = str(d.get("trigger_id", ""))
	cmd.route_as_order = bool(d.get("route_as_order", false))
	return cmd
```
